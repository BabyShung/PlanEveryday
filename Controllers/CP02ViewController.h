//
//  CP02ViewController.h
//  PlanEveryday
//
//  Created by Hao Zheng on 4/9/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

//hao

#import <UIKit/UIKit.h>
#import "CP04ViewController.h"
#import "CP03ViewController.h"

@class AbstractActionSheetPicker;

@interface CP02ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,CP04Delegate,CP03Delegate>
{
    NSMutableArray *contents;
    
}

//segue passed data
@property (nonatomic) NSInteger choseDate;

@property (strong,nonatomic) NSString *chosePlan;

@property (strong,nonatomic) Thoughts *ToCP04Thought;

@property (strong,nonatomic) Event *ToCP03Event;

@property (nonatomic, assign) BOOL isLoadingAExistingTodayPlan;
//

@property (nonatomic, assign) BOOL DeleteRowFlag;
 
- (IBAction)SelectADate:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *DateSelectBtn;


@property (nonatomic, retain) NSDate *selectedDate;

@property (nonatomic, retain) AbstractActionSheetPicker *actionSheetPicker;

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element;


@property (strong, nonatomic) IBOutlet UITableView *SwipeEventView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *CreateModifyBTN;

- (IBAction)CreateModifyBTNAction:(id)sender;

@end
