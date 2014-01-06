


#import <UIKit/UIKit.h>
#import "NLImageShowCase.h"
#import "NLImageViewDataSource.h"
#import "NLImageViewer.h"

@interface PlanViewViewController : UIViewController <NLImageViewDataSource>
{
    NLImageShowCase* _imageShowCase;
    NLImageViewer* _imageViewer;
    UIViewController * _imagViewController;
    
    //db storage
    NSMutableArray *contents;
        
    
}


@property (strong, nonatomic) IBOutlet UIView *containerView;
- (IBAction)LeftToggleBtn:(id)sender;
- (IBAction)RightToggleBtn:(id)sender;
 
@end
