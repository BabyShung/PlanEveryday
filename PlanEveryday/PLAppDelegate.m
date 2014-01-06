//
//  PLAppDelegate.m
//  PlanEveryday
//
//  Created by Hao Zheng on 4/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "PLAppDelegate.h"
#import "OperationsWithDB.h"
#import "SQLHelper.h"
#import "GCOLaunchImageTransition.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIAlertView+Blocks.h"
#import "AudioToolbox/AudioToolbox.h"
#import "TimeConverting.h"
@implementation PLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [OperationsWithDB StaticInit];
    
    //test db staffs
    SQLHelper *sqlh=[[SQLHelper alloc] init];
    //open sql connection
    [sqlh openDB];
    //get the dbfile path
    [sqlh sqliteDBFilePath];
    //Three tables, if not exist
    [sqlh createPlanTable:@"Plan" withPid:@"Pid" withCreateDate:@"CreateDate" withPlanDone:@"PlanDone" withExecuteDateTime:@"ExecuteDateTime"];
    [sqlh createEventTable:@"Event" withEid:@"Eid" withPid:@"Pid" withEname:@"Ename" withStartTime:@"StartTime" withEndTime:@"EndTime" withPriority:@"Priority" withCategory:@"Category" withNotificationID:@"NotificationID" withisFinished:@"isFinished" withExecuteDateTime:@"ExecuteDateTime"];
    [sqlh createThoughtsTable:@"Thoughts" withTid:@"Tid" withPid:@"Pid" withTitle:@"Title" withContent:@"Content" withExecuteDateTime:@"ExecuteDateTime"];
    [sqlh createCategoryTable:@"Category" withCid:@"Cid" withCName:@"CName" withExecuteDateTime:@"ExecuteDateTime"];
    [sqlh createAlarmClockTable:@"Alarm" withACid:@"ACid" withAlarmTime:@"AlarmTime" withLabel:@"Label" withRepeatence:@"Repeatence" withPickedSong:@"PickedSong" withEnabled:@"Enabled" withNotificationID:@"NotificationID" withExecuteDateTime:@"ExecuteDateTime"];
    
    //close db
    [sqlh closeDB];
    
    
    
    
    
    
    
    // Override point for customization after application launch.
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:
(UILocalNotification *)notification {
    /* This is all kinds of broken. If the application is running in the foreground,
     * iOS does not play the sound and display the local notification, so we have
     * to fake it.
     */
    
    NSLog(@"alert action: %@",notification.alertAction);
    
    if(application.applicationState == UIApplicationStateActive )
    {

        
        if([notification.alertAction isEqualToString:@"Go to App"])
        {//means this is an event
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Coming Event"
                                                            message: notification.alertBody delegate: self
                                                  cancelButtonTitle:@"Close" otherButtonTitles:@"View",  nil];
            [alert show];
            
            [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                if (buttonIndex == [alertView cancelButtonIndex]) {
  
                }
                else if(buttonIndex==1) //click modify
                {
                    NSLog(@"yeah");
                }
                
            }];
        }
        else    //alarm clock
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Best_Morning_Alarm" ofType:@"m4r"];
            
            NSURL *file = [[NSURL alloc] initFileURLWithPath:path];
            
            self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
            [self.player prepareToPlay];
            [self.player play];
            
            
            
            NSString *convertDate = [TimeConverting transfromNSDATEtoNSString2:notification.fireDate];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Alarm Clock"
                                                            message: convertDate delegate: self
                                                  cancelButtonTitle:@"Close" otherButtonTitles:@"View",  nil];

            [alert show];

            
            [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                if (buttonIndex == [alertView cancelButtonIndex]) {
                    [self.player stop];
                }
                else if(buttonIndex==1) //click modify
                {
                    NSLog(@"yeah yeah, you clicked View");
                }
                
            }];
        }
        

        
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
  //  AudioServicesDisposeSystemSoundID(notifSound);
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        //iPod is playing
        NSLog(@"stop playing...");
        [[MPMusicPlayerController iPodMusicPlayer] stop];
    } else {
        //iPod is not playing
    }

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [OperationsWithDB finalizeStatementsAndCloseDB];
}

//launch
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Choose a demo by setting values from 1 to 3
    NSUInteger demo = 2;
    
    switch( demo )
    {
        default:
        case 1:
        {
            // Create transition with a given style that begins immediately
            [GCOLaunchImageTransition transitionWithDuration:0.5 style:GCOLaunchImageTransitionAnimationStyleZoomIn];
            
            break;
        }
        case 2:
        {
            // Create transition with an near-infinite delay that requires manual dismissal via notification
            [GCOLaunchImageTransition transitionWithInfiniteDelayAndDuration:0.5 style:GCOLaunchImageTransitionAnimationStyleFade];
            
            // Dissmiss the launch image transition by posting a notification after a few seconds
            [self performSelector:@selector(finishLaunchImageTransitionNow) withObject:nil afterDelay:1.0];
            
            break;
        }
            
        case 3:
        {
            // Create fully customizable transition including an optional activity indicator
            // The 'activityIndicatorPosition' is a percentage value ('CGPointMake( 0.5, 0.5 )' being the center)
            // See https://github.com/gonecoding/GCOLaunchImageTransition for more documentation
            
            [GCOLaunchImageTransition transitionWithDelay:5.0 duration:0.5 style:GCOLaunchImageTransitionAnimationStyleZoomOut activityIndicatorPosition:CGPointMake( 0.5, 0.9 ) activityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            break;
        }
    }
}

- (void)finishLaunchImageTransitionNow
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GCOLaunchImageTransitionHideNotification object:self];
}

@end
