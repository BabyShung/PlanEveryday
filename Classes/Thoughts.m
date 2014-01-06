//
//  Thoughts.m
//  PlanEveryday
//
//  Created by Hao Zheng on 4/21/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "Thoughts.h"

@implementation Thoughts

- (NSString *)description
{
	NSString *desc  = [NSString stringWithFormat:@"Thoughts--- Title is %@,Content is: %@", self.Title, self.Content];
	
	return desc;
}

@end
