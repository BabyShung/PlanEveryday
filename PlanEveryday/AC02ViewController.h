//
//  AC02ViewController.h
//  PlanEveryday
//
//  Created by Hao Zheng on 5/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//
#import "Alarm.h"
#import <UIKit/UIKit.h>
#import "ClockView.h"
#import "AUIAnimatableLabel.h"
#import "CPPickerView.h"
@class AC02ViewController;
@class UICircularSlider;
@class DCFineTuneSlider;
@protocol AC02Delegate <NSObject>
-(void)passInfoback:(AC02ViewController *)controller withAlarm:(Alarm *)alarm andIsUpdate:(BOOL) isUpdate;
@end

@interface AC02ViewController : UIViewController <UITextFieldDelegate,CPPickerViewDataSource, CPPickerViewDelegate>
{
    CPPickerView *defaultPickerView;
}


@property (strong,nonatomic) id<AC02Delegate> delegate;
@property (strong,nonatomic) Alarm *AC02Alarm;

- (IBAction)DismissAC02:(id)sender;
- (IBAction)DoneWithAC02:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *TextField1;
@property (strong, nonatomic) IBOutlet ClockView *clockView;
@property (strong, nonatomic) IBOutlet UIImageView *ClockBackground;
@property (strong, nonatomic) IBOutlet UICircularSlider *ClockCircleSlider;
@property (strong, nonatomic) IBOutlet DCFineTuneSlider *ClockSlider;
- (IBAction)SlideUpdate:(UISlider *)sender;
 


@property (strong, nonatomic) IBOutlet AUIAnimatableLabel *AMPMDisplay;

@property (strong, nonatomic) IBOutlet UILabel *ExpectedTime;

@property (strong, nonatomic) IBOutlet UIButton *AMPMBtn;
@property (strong, nonatomic) IBOutlet UILabel *CountHoursLeftLabel;

- (IBAction)TapOnce:(UITapGestureRecognizer *)sender;
@end
