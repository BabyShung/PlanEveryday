//
//  Thoughts.h
//  PlanEveryday
//
//  Created by Hao Zheng on 4/21/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Thoughts : NSObject

@property (nonatomic, assign) NSUInteger Tid;
@property (nonatomic, assign) NSUInteger Pid;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *Content;
@property (nonatomic, assign) NSUInteger CreateDate;

@end
