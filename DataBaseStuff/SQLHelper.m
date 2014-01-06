//
//  SQLHelper.m
//  FaceBookNav2
//
//  Created by Hao Zheng on 4/1/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "SQLHelper.h"
#import "OperationsWithDB.h"

static NSString *kSQLiteFileName = @"planeverydayDB.sqlite3";

@implementation SQLHelper
@synthesize database;
//get the file path of DB
- (NSString *) sqliteDBFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:kSQLiteFileName];
	NSLog(@"path = %@", path);
	
	return path;
}

//Open DB
- (void) openDB
{
    if (sqlite3_open([[self sqliteDBFilePath] UTF8String], &database) != SQLITE_OK)
	{
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }else{
        NSLog(@"Database opened");
    }
}

//Close DB
- (void) closeDB
{
    if (sqlite3_close(database) != SQLITE_OK)
	{
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
    else{
        NSLog(@"Database closed");
    }
}

// Creates a writable copy of the bundled default database in the application Documents directory.
- (void) createEditableCopyOfDatabaseIfNeeded
{
    // First, test for existence.
    NSFileManager *fileManager = [NSFileManager defaultManager];
	
    NSString *writableDBPath = [self sqliteDBFilePath];
    // NSLog(@"%@", writableDBPath);
    BOOL success = [fileManager fileExistsAtPath: writableDBPath];
    if (success)
	{
		return;
	}
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kSQLiteFileName];
    NSError *error;
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success)
	{
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

/***** There are three tables temporarily:   Plan    Event   Thoughts  Category  AlarmClock
 
 Plan:  Pid,CreateDate,PlanDone,ExecuteDateTime
 Event:  Eid,Pid,Ename,StartTime,EndTime,Priority,Category,isFinished,ExecuteDateTime
 Thoughts: Tid,Pid,Title,Content,ExecuteDateTime
 Category: Cid,Cname;
 AlarmClock :ACid,AlarmTime,Label,Repeatence,PickedSong,ExecuteDateTime
 
 ****************************************************************/




-(void) createPlanTable: (NSString *) tablename
                withPid:(NSString *) field1
         withCreateDate:(NSString *) field2
           withPlanDone:(NSString *) field3
    withExecuteDateTime:(NSString *) field4
{
    char *err;
    NSString *sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER,'%@' BOOLEAN,'%@' TimeStamp NOT NULL DEFAULT (datetime('now','localtime')));",tablename,field1,field2,field3,field4];
    
    if(sqlite3_exec(database, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK){
        sqlite3_close(database);
        NSAssert1(0, @"Failed to create Plan table with message '%s'.", sqlite3_errmsg(database));
    }else{
        NSLog(@"Plan table created.");
    }
    
}

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
     withExecuteDateTime:(NSString *) field10
{
    char *err;
    NSString *sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' INTEGER, '%@' TEXT,'%@' INTEGER,'%@' INTEGER,'%@' INTEGER,'%@' TEXT,'%@' INTEGER,'%@' BOOLEAN,'%@' TimeStamp NOT NULL DEFAULT (datetime('now','localtime')));",tablename,field1,field2,field3,field4,field5,field6,field7,field8,field9,field10];
    
    if(sqlite3_exec(database, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK){
        sqlite3_close(database);
        NSAssert1(0, @"Failed to create Event table with message '%s'.", sqlite3_errmsg(database));
    }else{
        NSLog(@"Event table created.");
    }
    
}


-(void) createThoughtsTable: (NSString *) tablename
                    withTid:(NSString *) field1
                    withPid:(NSString *) field2
                  withTitle:(NSString *) field3
                withContent:(NSString *) field4
        withExecuteDateTime:(NSString *) field5
{
    char *err;
    NSString *sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' INTEGER, '%@' TEXT,'%@' TEXT,'%@' TimeStamp NOT NULL DEFAULT (datetime('now','localtime')));",tablename,field1,field2,field3,field4,field5];
    
    if(sqlite3_exec(database, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK){
        sqlite3_close(database);
        NSAssert1(0, @"Failed to create Thoughts table with message '%s'.", sqlite3_errmsg(database));
    }else{
        NSLog(@"Thoughts table created.");
    }
    
}

-(void) createCategoryTable: (NSString *) tablename
                    withCid:(NSString *) field1
                  withCName:(NSString *) field2
        withExecuteDateTime:(NSString *) field3
{
    char *err;
    NSString *sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT,'%@' TimeStamp NOT NULL DEFAULT (datetime('now','localtime')));",tablename,field1,field2,field3];
    
    if(sqlite3_exec(database, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK){
        sqlite3_close(database);
        NSAssert1(0, @"Failed to create Category table with message '%s'.", sqlite3_errmsg(database));
    }else{
        NSLog(@"Category table created.");
    }
    if(![OperationsWithDB CheckCategoryNotEmpty])//if table is empty
    {
        //insert some data
        [OperationsWithDB initializeCategoryTable];
    }
}

-(void) createAlarmClockTable: (NSString *) tablename
                     withACid:(NSString *) field1
                withAlarmTime:(NSString *) field2
                    withLabel:(NSString *) field3
               withRepeatence:(NSString *) field4
               withPickedSong:(NSString *) field5
                  withEnabled:(NSString *) field6
           withNotificationID:(NSString *) field7
          withExecuteDateTime:(NSString *) field8
{
    char *err;
    NSString *sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' INTEGER, '%@' TEXT,'%@' INTEGER,'%@' TEXT,'%@' BOOLEAN,'%@' INTEGER,'%@' TimeStamp NOT NULL DEFAULT (datetime('now','localtime')));",tablename,field1,field2,field3,field4,field5,field6,field7,field8];
    
    if(sqlite3_exec(database, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK){
        sqlite3_close(database);
        NSAssert1(0, @"Failed to create AlarmClock table with message '%s'.", sqlite3_errmsg(database));
    }else{
        NSLog(@"AlarmClock table created.");
    }

}

@end
