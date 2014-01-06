//
//  AITicker.h
//  PlanEveryday
//
//  Created by Hao Zheng on 5/12/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AITicker : NSObject

+(NSString *) getNumberOfTodayPlan:(NSDate *)date;

+(NSString *) UpcomingEventOfTodayPlan:(NSDate *)date;

+(NSString *) Greetings;
@end
