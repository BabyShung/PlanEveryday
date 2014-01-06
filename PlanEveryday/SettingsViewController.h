//
//  SettingsViewController.h
//  PlanEveryday
//
//  Created by Hao Zheng on 5/6/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingData.h"

@interface SettingsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


- (IBAction)DismissSettings:(id)sender;
- (IBAction)DoneWithSetting:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *settingview;
@property (strong, nonatomic) NSArray *group;
@property (strong, nonatomic) NSArray *section1;
@property (strong, nonatomic) NSArray *section2;

- (void)saveSelections: (SettingData *) settings;

@end
