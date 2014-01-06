//
//  AC03ViewController.h
//  PlanEveryday
//
//  Created by Hao Zheng on 5/6/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMediaPickerController.h>
#import <AVFoundation/AVAudioPlayer.h>
@interface AC03ViewController : UIViewController <MPMediaPickerControllerDelegate,AVAudioPlayerDelegate ,UITableViewDelegate,UITableViewDataSource>

- (IBAction)DismissAC03:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
