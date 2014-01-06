//
//  CP03ViewController.h
//  PlanEveryday
//
//  Created by Hao Zheng on 4/11/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "ClockView.h"
#import "IZValueSelectorView.h"
#import "AUIAnimatableLabel.h"
#import "CPPickerView.h"
#import "IGAutoCompletionToolbar.h"
#import "SettingData.h"

@class UICircularSlider;
@class CP03ViewController;
@class DCFineTuneSlider;
@protocol CP03Delegate <NSObject>

-(void)passInfoback:(CP03ViewController *)controller withEvent:(Event *)event;
@end

@interface CP03ViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate,IZValueSelectorViewDataSource,IZValueSelectorViewDelegate,CPPickerViewDataSource, CPPickerViewDelegate,IGAutoCompletionToolbarDelegate,UIAlertViewDelegate>
{
    CPPickerView *defaultPickerView;
}
@property (nonatomic) BOOL shouldCategoryToolBeDisabled;

@property (strong,nonatomic) Event *CP03Event;

@property (strong,nonatomic) NSString *selectedCategory;

@property (strong,nonatomic) NSMutableArray *CP03Categories;

@property (strong, nonatomic) IBOutlet IZValueSelectorView *selectorHorizontal;


@property (strong, nonatomic) IBOutlet UITextField *TextField1;


- (IBAction)DoneWithCP03View:(id)sender;

@property (strong,nonatomic) id<CP03Delegate> delegate;


@property (strong, nonatomic) IBOutlet DCFineTuneSlider *ClockSlider;
@property (strong, nonatomic) IBOutlet UICircularSlider *ClockCircleSlider;
@property (strong, nonatomic) IBOutlet UIImageView *ClockBackground;
- (IBAction)SlideUpdate:(UISlider *)sender;



@property (strong, nonatomic) IBOutlet AUIAnimatableLabel *AMPMDisplay;

@property (strong, nonatomic) IBOutlet UILabel *ExpectedTime;

@property (strong, nonatomic) IBOutlet UIButton *AMPMBtn;
@property (strong, nonatomic) IBOutlet UILabel *CountHoursLeftLabel;
//keyboard toolbar
@property (strong, nonatomic) IBOutlet IGAutoCompletionToolbar *toolbar;
@property (strong, nonatomic) IBOutlet ClockView *clockView;
 
- (IBAction)TapOnce:(UITapGestureRecognizer *)sender;


@end
