//
//  EventOperationWithDB.h
//  PlanEveryday
//
//  Created by Hao Zheng on 4/20/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "Thoughts.h"
#import "Alarm.h"
#import "Category.h"
@interface OperationsWithDB : NSObject

//static init
+ (id) StaticInit;
// fetch events in a plan/day
+ (NSMutableArray *)fetchPlans;

+ (NSMutableArray *)fetchPlans:(NSInteger) doneOrNot;

+ (NSMutableArray *)fetchEvents: (NSDate *) TheDate;

+ (NSMutableArray *)fetchEventsByInt: (NSInteger) date;

+ (NSMutableArray *)fetchEventsByPid: (NSInteger) Pid;

+ (NSMutableArray *)fetchEventNamesByPid: (NSInteger) Pid;

+ (NSMutableArray *)fetchPlansWithLimits: (NSInteger) limit butExceptToday:(NSDate *)date;

+(NSInteger)fetchCreateDateByPid:(NSInteger) pid;

+(NSInteger)fetchPidByCreateDate:(NSDate *) date;

+ (NSInteger)PlanHaveMade;

+  (NSInteger)EventNumbersOfADay:(NSDate *) date;

+ (BOOL)CheckAPlanIsThere: (NSDate *) TheDate;

+ (void) finalizeStatementsAndCloseDB;

+ (void)deleteAnEvent: (Event *) event;

+ (void)deleteAThought: (NSInteger) pid;

+ (BOOL)CheckAnEventIsThere: (Event *) event;

+ (void) CreateAPlan: (NSMutableArray *) events andThoughts:(Thoughts *) thought andEffectedDate:(NSDate *) date;

+ (void) ModifyAPlan: (NSMutableArray *) events andThoughts:(Thoughts *) thought andEffectedDate:(NSDate *) date;

+ (Thoughts *)fetchThought: (NSDate *) TheDate;

+ (Thoughts *)fetchThoughtByInt: (NSInteger) date;

+ (NSMutableArray *)fetchEventNamesWithLimits: (NSInteger) limit;

+(void)initializeCategoryTable;

+ (NSMutableArray *)fetchCategory;

+ (BOOL)CheckCategoryNotEmpty;

+ (NSInteger)FetchACategoryForItsCidMinusOne:(NSString *) name;

+ (void) InsertIntoThoughtTable: (Thoughts *) thought andPid:(NSInteger) pid;

//---------
+(NSInteger) InsertIntoAlarmTable:(Alarm *) alarm;

+ (void) UpdateIntoAlarmTable: (Alarm *) tmpAlarm;

+ (NSMutableArray *)fetchAlarms;
//---------

+ (void)deleteAnAlarm: (Alarm *) alarm;

+ (void) UpdateIntoCategoryTable: (Category *) category andOld: (Category *) old;

+(NSInteger) InsertIntoCategoryTable:(Category *) category;

+ (NSMutableArray *)fetchAllTheThoughts;

+ (void) UpdateJustEnabledOfAlarmTable: (Alarm *) tmpAlarm;

+ (void) UpdateThoughtTable: (Thoughts *) thought andPid:(NSInteger) pid;
@end
