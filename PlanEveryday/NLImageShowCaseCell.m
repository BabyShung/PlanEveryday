


#import "NLImageShowCaseCell.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "TimeConverting.h"
@implementation NLImageShowCaseCell

@synthesize index = _index;
@synthesize image = _image;
@synthesize cellDelegate = _cellDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    CGFloat delButtonSize = 60;
    
    _deleteMode = NO;
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, delButtonSize, delButtonSize)];
    _deleteButton.center = CGPointMake(0, 0);
    _deleteButton.backgroundColor = [UIColor clearColor];
    
    [_deleteButton setImage: [UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    _deleteButton.hidden = YES;
    
    _mainImage = [[UIButton alloc] initWithFrame:self.bounds];
    
    //-----------hao modified
    
    _labelTop = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, 5, 10, 15)];
    
    _bottomImage = [[UIButton alloc] initWithFrame:self.bounds];
    //
    [self addSubview:_bottomImage];
  
    [self addSubview:_labelTop];
    
    [self addSubview:_mainImage];
    
    
    [self addSubview:_deleteButton];
    
    //shadow
    _bottomImage.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bottomImage.imageView.layer.shadowOffset = CGSizeMake(3, 3);
    _bottomImage.imageView.layer.shadowOpacity = 0.6;
    _bottomImage.imageView.layer.shadowRadius = 1.0;
    _bottomImage.imageView.clipsToBounds = NO;
    _bottomImage.userInteractionEnabled = YES;
    
    
    
    //bond methods
    [_mainImage addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];

    [_deleteButton addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    [_mainImage addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [_mainImage addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchUpOutside];

    return self;
}

- (id)initWithImage:(UIImage*)image andPid:(NSInteger) Pid andCreateDate:(NSInteger) CreateDate
{
    return [self setMainImage:image andPid:Pid andCreateDate:CreateDate];
}

-(void) setDeleteMode:(BOOL)deleteMode
{
    _deleteMode = deleteMode;
    if(deleteMode)
    {
        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [anim setToValue:[NSNumber numberWithFloat:0.0f]];
        [anim setFromValue:[NSNumber numberWithDouble:M_PI/64]];
        [anim setDuration:0.1];
        [anim setRepeatCount:NSUIntegerMax];
        [anim setAutoreverses:YES];
        self.layer.shouldRasterize = YES;
        [self.layer addAnimation:anim forKey:@"SpringboardShake"];
        //_mainImage.userInteractionEnabled = NO;
        _deleteButton.hidden = NO;
    }
    else
    {
        [self.layer removeAllAnimations];
        //_mainImage.userInteractionEnabled = YES;
        _deleteButton.hidden = YES;
    }
}

- (NSInteger)getInfo
{
    NSLog(@"Pid:  %i",_Pid);
    return _Pid;
}



- (void)resetView
{
    [self.layer removeAllAnimations];
//    self.userInteractionEnabled = YES;
    [self setDeleteMode:NO];
}

- (id)setMainImage:(UIImage*)image andPid:(NSInteger) Pid andCreateDate:(NSInteger) CreateDate
{
    _Pid = Pid;
    
    _image = image;
    
    [_bottomImage setImage:image forState:UIControlStateNormal];
    
    [_mainImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _labelTop.text = [NSString stringWithFormat:@"%i",Pid];
    
    [_mainImage setTitle:[NSString stringWithFormat:@"%@",[TimeConverting TimeDateINTToString:CreateDate]] forState:UIControlStateNormal];

    return self;
}

- (UIImage*)getThumbnail:(UIImage*) image
{
    
    float imgWidth = image.size.width;
    float imgHeight = image.size.height;
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    NSLog(@"height: %f",image.size.height);
    NSLog(@"width: %f",image.size.width);

    
    NSLog(@"height: %f",self.bounds.size.height);
    NSLog(@"width: %f",self.bounds.size.width);
    
    float horz =  imgWidth / width;
    float vert =  imgHeight / height;

    
    float x1 = 0,x2 = 0,y1 = 0,y2 = 0;
    
    float scalingFactor = vert < horz ? vert  : horz;
    
    UIImage* resizedImage = [self resizeImage:image resizeSize:CGSizeMake(imgWidth/scalingFactor, imgHeight/scalingFactor)];
    
    if(vert < horz)
    {
        x1 = (imgWidth/vert)/2 - width/2;
        x2 = (imgWidth/vert)/2 + width/2;
        y1 = 0;
        y2 = imgHeight / vert;
    }
    else if(horz < vert)
    {
        x1 = 0;
        x2 = imgWidth / horz;
        y1 = (imgHeight/horz)/2 - height/2;
        y2 = (imgHeight/horz)/2 + height/2;
    }
    else //Horz == vert
    {
        x1 = 0;
        x2 = imgWidth / horz;
        y1 = 0;
        x2 = imgHeight / vert;
    }
    
    CGRect imageRect = CGRectMake(x1, y1, x2 - x1, y2 - y1);
    CGImageRef imageRef = CGImageCreateWithImageInRect([resizedImage CGImage], imageRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:resizedImage.scale
                                    orientation:resizedImage.imageOrientation];
    CGImageRelease(imageRef);    
    return result;
}

- (UIImage *)resizeImage:(UIImage*)image resizeSize:(CGSize)resizeSize {
    CGImageRef refImage = image.CGImage;
    CGRect resizedRect = CGRectIntegral(CGRectMake(0, 0, resizeSize.width, resizeSize.height));
    UIGraphicsBeginImageContextWithOptions(resizeSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform vertFlip = CGAffineTransformMake(1, 0, 0, -1, 0, resizeSize.height);
    CGContextConcatCTM(context, vertFlip);
    CGContextDrawImage(context, resizedRect, refImage);
    CGImageRef resizedRefImage = CGBitmapContextCreateImage(context);
    UIImage *resizedImage = [UIImage imageWithCGImage:resizedRefImage];
    CGImageRelease(resizedRefImage);
    UIGraphicsEndImageContext();
    
    return resizedImage;
}


- (IBAction)buttonClicked {
    if(_deleteMode)
        return;
    [_timer invalidate];
    [_cellDelegate imageClicked:self imageIndex:_index];
}
- (IBAction) deleteImage {
    [_cellDelegate deleteImage:self imageIndex:_index];
    [_timer invalidate];
}

- (IBAction)touchCancel {
    [_timer invalidate];
}

- (IBAction)touchDown {
    if(_deleteMode)
        return;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                              target:self
                                            selector:@selector(imagePushedLonger)
                                            userInfo:nil
                                             repeats:YES];
}
- (IBAction)imagePushedLonger
{
    [_timer invalidate];
    [_cellDelegate imageTouchLonger:self imageIndex:_index];
}

@end
