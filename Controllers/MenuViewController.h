//
//  MenuViewController.h
//  PlanEveryday
//
//  Created by Hao Zheng on 4/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *PETableView;
@property (strong, nonatomic) IBOutlet UISearchBar *PESearchBar;
@property (strong, nonatomic) NSArray *menu;
@property (strong, nonatomic) NSArray *section1;
@property (strong, nonatomic) NSArray *section2;
@property (strong, nonatomic) UIViewController *MainView;
@property (strong, nonatomic) NSString *CurrentTopViewName;
@end
