//
//  Event.h
//  PlanEveryday
//
//  Created by Hao Zheng on 4/20/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, assign) NSUInteger Eid;
@property (nonatomic, assign) NSUInteger Pid;
@property (nonatomic, strong) NSString *Ename;
@property (nonatomic, assign) NSUInteger StartTime;
@property (nonatomic, assign) NSUInteger EndTime;
@property (nonatomic, assign) NSUInteger Priority;
@property (nonatomic, strong) NSString *Category;
@property (nonatomic, assign) BOOL isFinished;

@property (nonatomic, assign) BOOL ShouldBeUpdatedInDB; //an existing event

@property (nonatomic, assign) NSUInteger IndexInSwipeTable;

@property (nonatomic, assign) BOOL didSelectAVirtualCell;

@property (nonatomic, assign) NSInteger IndexInDBCategory;

@property (nonatomic,assign) int notificationID;//important

@end
