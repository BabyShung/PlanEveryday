//
//  Category.m
//  PlanEveryday
//
//  Created by Hao Zheng on 4/29/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "Category.h"

@implementation Category
- (NSString *)description
{
	NSString *desc  = [NSString stringWithFormat:@"%@", self.CName];
	
	return desc;
}
@end
