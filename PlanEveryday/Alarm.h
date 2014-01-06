//
//  Alarm.h
//  PlanEveryday
//
//  Created by Hao Zheng on 5/4/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject

@property (nonatomic, assign) NSUInteger ACid;
@property (nonatomic, strong) NSString *Label;
@property (nonatomic, assign) NSUInteger AlarmTime;
@property (nonatomic, assign) NSUInteger Repeatence;
@property (nonatomic, strong) NSString *PickedSong;
@property (nonatomic, assign) NSUInteger IndexInSwipeTable;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic,assign) int notificationID;
@end
