//
//  SQLHelper.h
//  FaceBookNav2
//
//  Created by Hao Zheng on 4/1/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
@interface SQLHelper : NSObject
{
    sqlite3 *database;
}
@property (nonatomic) sqlite3 *database;

// filePath
- (NSString *) sqliteDBFilePath;

- (void) openDB;

- (void) closeDB;

- (void) createEditableCopyOfDatabaseIfNeeded;

-(void) createPlanTable: (NSString *) tablename
                withPid:(NSString *) field1
               withCreateDate:(NSString *) field2
               withPlanDone:(NSString *) field3
                withExecuteDateTime:(NSString *) field4;

-(void) createEventTable: (NSString *) tablename
              withEid:(NSString *) field1
              withPid:(NSString *) field2
              withEname:(NSString *) field3
              withStartTime:(NSString *) field4
              withEndTime:(NSString *) field5
            withPriority:(NSString *) field6
            withCategory:(NSString *) field7
        withNotificationID:(NSString *) field8
            withisFinished:(NSString *) field9
            withExecuteDateTime:(NSString *) field10;

-(void) createThoughtsTable: (NSString *) tablename
                    withTid:(NSString *) field1
                    withPid:(NSString *) field2
                  withTitle:(NSString *) field3
                withContent:(NSString *) field4
        withExecuteDateTime:(NSString *) field5;

-(void) createCategoryTable: (NSString *) tablename
                    withCid:(NSString *) field1
                  withCName:(NSString *) field2
        withExecuteDateTime:(NSString *) field3;

-(void) createAlarmClockTable: (NSString *) tablename
                    withACid:(NSString *) field1
                    withAlarmTime:(NSString *) field2
                  withLabel:(NSString *) field3
                withRepeatence:(NSString *) field4
               withPickedSong:(NSString *) field5
               withEnabled:(NSString *) field6
               withNotificationID:(NSString *) field7
        withExecuteDateTime:(NSString *) field8;
@end
