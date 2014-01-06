//
//  LocalNotification.m
//  PlanEveryday
//
//  Created by Hao Zheng on 7/1/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "LocalNotification.h"

@implementation LocalNotification

+ (void)CancelExistingNotification:(int) notificationID
{
    //cancel alarm
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"notificationID"]];
        if ([uid isEqualToString:[NSString stringWithFormat:@"%i",notificationID]])
        {
            //Cancelling local notification
            [app cancelLocalNotification:oneEvent];
            NSLog(@"cancel suceeded ! ! ! ! ! ! ! ! !");
            break;
        }
    }
}


+ (void)scheduleLocalNotificationWithDate:(NSDate *)fireDate atIndex:(int)indexOfObject andAlertBody:(NSString *)AlertName andAlertAction:(NSString *)Judgement{
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (!localNotification)
        return;
    
    localNotification.repeatInterval = NSDayCalendarUnit;
    
    [localNotification setFireDate:fireDate];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    
    //notif.soundName = [soundPaths objectAtIndex:soundIndex];
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    // Setup alert notification
    [localNotification setAlertBody:AlertName ];
    [localNotification setAlertAction:Judgement];
    [localNotification setHasAction:YES];
    
    
    NSLog(@"%@", fireDate);
    //This array maps the alarms uid to the index of the alarm so that we can cancel specific local notifications
    
    NSNumber* uidToStore = [NSNumber numberWithInt:indexOfObject];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:uidToStore forKey:@"notificationID"];
    
    localNotification.userInfo = userInfo;
    NSLog(@"Uid Store in userInfo %@", [localNotification.userInfo objectForKey:@"notificationID"]);
    
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    
}




//Get Unique Notification ID for a new alarm O(n)
+(int)getUniqueNotificationID
{
    NSMutableDictionary * hashDict = [[NSMutableDictionary alloc]init];
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSNumber *uid= [userInfoCurrent valueForKey:@"notificationID"];
        NSNumber *value =[NSNumber numberWithInt:1];
        [hashDict setObject:value forKey:uid];
    }
    for (int i=0; i<[eventArray count]+1; i++)
    {
        NSNumber * value = [hashDict objectForKey:[NSNumber numberWithInt:i]];
        if(!value)
        {
            return i;
        }
    }
    return 0;
}


@end
