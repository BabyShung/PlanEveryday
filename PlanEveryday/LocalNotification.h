//
//  LocalNotification.h
//  PlanEveryday
//
//  Created by Hao Zheng on 7/1/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotification : NSObject

+ (void)CancelExistingNotification:(int) notificationID;

+ (void)scheduleLocalNotificationWithDate:(NSDate *)fireDate atIndex:(int)indexOfObject andAlertBody:(NSString *)AlertName andAlertAction:(NSString *)Judgement;

+(int)getUniqueNotificationID;

@end
