


#import "NLImageViewer.h"
#import <QuartzCore/QuartzCore.h>

#define IMAGE_BOUNDRY_SPACE 10

@implementation NLImageViewer
@synthesize image = _image;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        [self addSubview:_imageView];
    }

    return self;
}

-(void) setImage:(UIImage *)image
{
    _image = image;
    [_imageView setImage:image];
    [self reLayoutView];
    
}
-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(_image != nil)
       [self reLayoutView];
}

- (void) reLayoutView
{
    float imgWidth = _image.size.width;
    float imgHeight = _image.size.height;
    float viewWidth = self.bounds.size.width - 2*IMAGE_BOUNDRY_SPACE;
    float viewHeight = self.bounds.size.height - 2*IMAGE_BOUNDRY_SPACE;
    
    float widthRatio = imgWidth / viewWidth;
    float heightRatio = imgHeight / viewHeight;
    _scalingFactor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    _imageView.bounds = CGRectMake(0, 0, imgWidth / _scalingFactor, imgHeight/_scalingFactor);
    _imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _imageView.layer.shadowOffset = CGSizeMake(3, 3);
    _imageView.layer.shadowOpacity = 0.6;
    _imageView.layer.shadowRadius = 1.0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
