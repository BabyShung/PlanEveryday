//
//  AC01ViewController.h
//  PlanEveryday
//
//  Created by Hao Zheng on 5/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AC02ViewController.h"
@class Alarm;
@interface AC01ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,AC02Delegate>
{
    NSMutableArray *contents;
    
}
- (IBAction)DismissAC01:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *AC01TableView;
- (IBAction)DoneWithAC01:(id)sender;

@property (strong,nonatomic) Alarm *ToAC02Alarm;

@end
