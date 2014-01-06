//
//  Event.m
//  PlanEveryday
//
//  Created by Hao Zheng on 4/20/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "Event.h"

@implementation Event

- (NSString *)description
{
	NSString *desc  = [NSString stringWithFormat:@"Event--- Eid: %i,Pid: %i,Ename is %@,StartTime is: %i,EndTime is: %i,Priority is: %i,Category is: %@,isFinished %d..", self.Eid, self.Pid, self.Ename, self.StartTime, self.EndTime,self.Priority,self.Category,self.isFinished];
	
	return desc;
}

@end
