//
//  ViewDayViewController.h
//  PlanEveryday
//
//  Created by Hao Zheng on 4/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewDayViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray *selectedMarks;
    NSMutableArray *contents;
}



@property (strong, nonatomic) IBOutlet UITableView *MSTableView;
- (IBAction)FinishEvents:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *navTopLabel;

@end
