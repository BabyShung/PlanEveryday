//
//  AC03ViewController.m
//  PlanEveryday
//
//  Created by Hao Zheng on 5/6/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "AC03ViewController.h"
#import <MediaPlayer/MPMediaPickerController.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TDBadgedCell.h"
#import "UIAlertView+Blocks.h"
@interface AC03ViewController ()

@end

@implementation AC03ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DismissAC03:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pick:(id)sender {
    @try
    {
        MPMediaPickerController *picker =
        [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
        
        picker.delegate = self;
        picker.allowsPickingMultipleItems       = NO;
        picker.prompt = @"Select any song from the list";
        
        if(picker != NULL)
        {
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
    @catch(NSException *e)
    {
        
    }
}

#pragma mark - delegete

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Collection %@",mediaItemCollection);
    
    MPMusicPlayerController *player = [MPMusicPlayerController iPodMusicPlayer];
    [player setQueueWithItemCollection:mediaItemCollection];
    [player play];
    
    
    
    //
    //    // use the first item in the collection
    //    MPMediaItem *item = [[mediaItemCollection items] objectAtIndex:0];
    //
    //    // get the URL to the MP3
    //    NSURL *URL = [item valueForProperty:MPMediaItemPropertyAssetURL];
    //
    //    NSLog(@"!!!%@",URL);
    //    // URL uses a proprietary scheme, but AVFoundation understands it, so...
    //    AVAudioPlayer *player = [[AVAudioPlayer alloc]
    //                             initWithContentsOfURL:URL error:NULL];
    //    [player play];
    
}
//After you are done with selecting the song, implement the delegate to dismiss the picker:

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    @try
    {
        MPMediaPickerController *picker =
        [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
        
        picker.delegate = self;
        picker.allowsPickingMultipleItems       = NO;
        picker.prompt = @"Select any song from the list";
        
        if(picker != NULL)
        {
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
    @catch(NSException *e)
    {
        [UIAlertView showWarningWithMessage:@"Can't connect to music library."
                                    handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                        
                                        NSLog(@"Warning dismissed");
                                    }];
    }
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

 
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    TDBadgedCell *cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
 
            cell.textLabel.text = [NSString stringWithFormat:@"No Event today,create one?"];
 
  
             
            cell.badgeString = @"123";
            
 
                    cell.badgeColor = [UIColor colorWithRed:0.197 green:0.592 blue:0.219 alpha:1.000];
  
        
        //settings
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
		
        cell.badge.fontSize = 16;
        cell.badgeLeftOffset = 8;
        cell.badgeRightOffset = 40;
        
 
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //the height of every cell
    
    return 60.0;
    
}




@end
