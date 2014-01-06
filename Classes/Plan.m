//
//  Plan.m
//  PlanEveryday
//
//  Created by Hao Zheng on 4/21/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "Plan.h"

@implementation Plan

- (NSString *)description
{
	NSString *desc  = [NSString stringWithFormat:@"Plan--- Pid: %i,CreateDate is %i,PlanDone is: %d", self.Pid,self.CreateDate,self.PlanDone];
	
	return desc;
}

@end
