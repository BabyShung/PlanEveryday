//
//  Alarm.m
//  PlanEveryday
//
//  Created by Hao Zheng on 5/4/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "Alarm.h"

@implementation Alarm

- (NSString *)description
{
	NSString *desc  = [NSString stringWithFormat:@"Alarm--- Label is %@,AlarmTime is: %i", self.Label, self.AlarmTime];
	
	return desc;
}

@end
