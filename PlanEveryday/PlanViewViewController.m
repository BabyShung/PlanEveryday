


#import "PlanViewViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "OperationsWithDB.h"
//return msg
#import "SVProgressHUD.h"
#import "Plan.h"
@interface PlanViewViewController ()

@property(nonatomic, assign) NSUInteger nbItems;

@end

@implementation PlanViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self Preparations];

//    
//    NSLog(@"height: %f",[UIScreen mainScreen].bounds.size.height);
//    NSLog(@"width: %f",[UIScreen mainScreen].bounds.size.width);
//     NSLog(@"testing: %i",CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size));
//    NSLog(@"width2: %f",[UIScreen mainScreen].bounds.size.width);
//    NSLog(@"height2: %f",[UIScreen mainScreen].bounds.size.height);
    
//    if([UIScreen mainScreen].bounds.size.width==320)
//    {
//        NSLog(@"yes!");
//    }
    
    _imageShowCase = [[NLImageShowCase alloc] initWithFrame:self.containerView.bounds];

    _imageShowCase.dataSource = self;
    
    _imageShowCase.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile.png"]];

    [self.containerView addSubview:_imageShowCase];
    
    contents = [OperationsWithDB fetchPlans];
    self.nbItems = [contents count];
    
    //------------------------------------------------------------
    //delay code   -- has to be done. wait delegate method goes first
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        
 
        if(self.nbItems == 0)
        {
            [SVProgressHUD showWarningWithStatus:@"No plan"];
        }
        else
        {
            for(Plan *tmpP in contents)
            {
                [self addCell:tmpP.Pid andCreateDate:tmpP.CreateDate andDON:tmpP.PlanDone];
            }
        }

    });
    //------------------------------------------------------------

    
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



-(void)addCell:(NSInteger)pid andCreateDate:(NSInteger) cd andDON:(BOOL)doneOrNot
{
    NSString* imageName;
    
    if(doneOrNot==YES)  //the plan is done
    {
        imageName = [NSString stringWithFormat:@"PlanDone.jpg"];
    }
    else    //not done
    {
        imageName = [NSString stringWithFormat:@"PlanUndone.jpg"];
    }
    
    [_imageShowCase addImage:[UIImage imageNamed:imageName] andPid:pid andCreateDate:cd];

}

#pragma mark - Image Showcase Protocol
- (CGSize)imageViewSizeInShowcase:(NLImageShowCase *) imageShowCase
{
    return CGSizeMake(120, 80);
//    return CGSizeMake(55, 70);
}
- (CGFloat)imageLeftOffsetInShowcase:(NLImageShowCase *) imageShowCase
{
    return 25.0f;
//    return 20.0f;
}
- (CGFloat)imageTopOffsetInShowcase:(NLImageShowCase *) imageShowCase
{
    return 20.0f + 44.0f;
}
- (CGFloat)rowSpacingInShowcase:(NLImageShowCase *) imageShowCase
{
//    return 20.0f;
    return 25.0f;

}
- (CGFloat)columnSpacingInShowcase:(NLImageShowCase *) imageShowCase
{
//    return 20.0f;
    return 25.0f;
}

#pragma mark - Cell Protocol

- (void)imageClicked:(NLImageShowCase *) imageShowCase imageShowCaseCell:(NLImageShowCaseCell *)imageShowCaseCell;
{
    //[_imageViewer setImage:[imageShowCaseCell image]];
    
    //get pid 
    int tempPid = [imageShowCaseCell getInfo];
    NSLog(@"tmpPid:  %i",tempPid);
    
    //reload a specific plan
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadAPlan" object:self userInfo:@{@"key":[NSNumber numberWithInt:tempPid]}];
    
    
    //slide
    [self.slidingViewController anchorTopViewTo:ECLeft animations:NO onComplete:nil];
    
}

- (void)imageTouchLonger:(NLImageShowCase *)imageShowCase imageIndex:(NSInteger)index;
{
    [_imageShowCase setDeleteMode:!(_imageShowCase.deleteMode)];
}

- (IBAction)LeftToggleBtn:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)RightToggleBtn:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

-(void) Preparations
{
    //shadow stuff
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 2.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

@end
