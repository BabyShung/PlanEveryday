//
//  MainViewController.h
//  PlanEveryday
//
//  Created by Hao Zheng on 4/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

//hao
#import <UIKit/UIKit.h>
#import "CollapseClick.h"

@interface MainViewController : UIViewController <CollapseClickDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
        NSMutableArray *contents;
        NSMutableArray *contents2;

}

@property (strong, nonatomic) IBOutlet UILabel *dayOfWeek;

@property (weak, nonatomic) IBOutlet CollapseClick *myCollapseClick;

@property (strong, nonatomic) IBOutlet UIView *test1View;
@property (strong, nonatomic) IBOutlet UIView *test2View;

- (IBAction)LeftToggleBtn:(id)sender;
- (IBAction)RightToggleBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *MainSubTableView1;
@property (strong, nonatomic) IBOutlet UITableView *MainSubTableView2;
@end
