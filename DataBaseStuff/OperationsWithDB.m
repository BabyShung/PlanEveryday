//
//  EventOperationWithDB.m
//  PlanEveryday
//
//  Created by Hao Zheng on 4/20/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "OperationsWithDB.h"
#import "SQLHelper.h"
#import "Event.h"
#import "Plan.h"
#import "Thoughts.h"
#import "Category.h"
#import "Alarm.h"
#import "TimeConverting.h"
#import "SVProgressHUD.h"
@implementation OperationsWithDB

// db reference
static sqlite3 *PEDatabase;

// SQLite for connection and create table
static SQLHelper *sqlh;


#pragma mark - init and finalize
// init an object to do operations
+ (id) StaticInit
{
	return [[self alloc] init];
}

-(id) init  //set up connection
{
	if ((self=[super init]) )
    {
		if (PEDatabase == nil)
		{
			if (sqlh == nil)
            {
				sqlh = [[SQLHelper alloc] init];
			}
            
			[sqlh openDB];
			
			PEDatabase = [sqlh database];
           // NSLog(@"%@",PEDatabase);
		}
	}
	return self;
}

// close+finalize stuff----pair with staticInit
+ (void) finalizeStatementsAndCloseDB
{
    NSLog(@"--------------finalize-----------------");
    [sqlh closeDB];
}

//-------------------------Helper---------------------------------------------
//----------------------------------------------------
#pragma mark - static methods



+(NSInteger)returnAnInteger:(NSString *)sql
{
    int tmp;
    
    sqlite3_stmt *stm = nil;
    
    if (stm == nil)
    {
		if (sqlite3_prepare_v2(PEDatabase, [sql UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
			NSAssert1(0, @"!Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
		}
	}
    
    while (sqlite3_step(stm) == SQLITE_ROW)   //actually,execute only once
    {
        tmp = sqlite3_column_int(stm, 0);
    }

    return tmp;
    
}

+(void)executeHelper:(NSString *)sql
{
    sqlite3_stmt *stm = nil;
    
    if (stm == nil)
    {
		if (sqlite3_prepare_v2(PEDatabase, [sql UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
			NSAssert1(0, @"!Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
		}
	}
    
    int success = sqlite3_step(stm);
    
    if (success == SQLITE_ERROR)
    {
        NSAssert1(0, @"Error: failed to execute table with message '%s'.", sqlite3_errmsg(PEDatabase));
    }
}

+(NSInteger)executeHelperReturnInt:(NSString *)sql
{
    sqlite3_stmt *stm = nil;
    
    if (stm == nil)
    {
		if (sqlite3_prepare_v2(PEDatabase, [sql UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
			NSAssert1(0, @"!Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
		}
	}
    
    int success = sqlite3_step(stm);
    int returnID = (int)sqlite3_last_insert_rowid(PEDatabase);
    if (success == SQLITE_ERROR)
    {
        NSAssert1(0, @"Error: failed to execute table with message '%s'.", sqlite3_errmsg(PEDatabase));
    }
    return returnID;
}

+(NSInteger)executeHelperReturnPid:(NSString *)sql
{
    sqlite3_stmt *stm = nil;
    
    if (stm == nil)
    {
		if (sqlite3_prepare_v2(PEDatabase, [sql UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
			NSAssert1(0, @"!Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
		}
	}
    
	if(sqlite3_step(stm) == SQLITE_ROW)
	{
        return sqlite3_column_int(stm, 0);//return pid
	}
    else
    {
        return -1;
    }
}

+(BOOL)executeHelperReturnBool:(NSString *)sql
{
    sqlite3_stmt *stm = nil;
    
    if (stm == nil)
    {
		if (sqlite3_prepare_v2(PEDatabase, [sql UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
			NSAssert1(0, @"!Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
		}
	}
    
	if(sqlite3_step(stm) == SQLITE_ROW)
	{
        return YES;
	}
    else
    {
        return NO;
    }
}

+(Thoughts *)executeHelperFetchingAThought:(NSString *)sql
{
    sqlite3_stmt *stm = nil;
    
    if (stm == nil)
    {
		if (sqlite3_prepare_v2(PEDatabase, [sql UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
			NSAssert1(0, @"!Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
		}
	}
    
    Thoughts *tmp = [[Thoughts alloc]init];
    while (sqlite3_step(stm) == SQLITE_ROW)
	{
        tmp.Tid = sqlite3_column_int(stm, 0);
        tmp.Pid = sqlite3_column_int(stm, 1);
        tmp.Title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 2)];
        tmp.Content = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 3)];
    }
    
    return tmp;
}

+(NSMutableArray *)executeHelperFetchingPlans:(NSString *)sql
{
    sqlite3_stmt *stm = nil;
    
    if (stm == nil)
    {
		if (sqlite3_prepare_v2(PEDatabase, [sql UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
			NSAssert1(0, @"!Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
		}
	}
    
    NSMutableArray *Plans = [NSMutableArray array];
	while (sqlite3_step(stm) == SQLITE_ROW)
	{
		Plan *tmpPlan = [[Plan alloc] init];
        tmpPlan.Pid = sqlite3_column_int(stm, 0);
        tmpPlan.CreateDate = sqlite3_column_int(stm, 1);
        tmpPlan.PlanDone = sqlite3_column_int(stm, 2);
		[Plans addObject:tmpPlan];
	}
    
    return Plans;   //might be null
}

//----------------------------------------------------
//----------------------------------------------------
//----------------------------------------------------
//----------------------------------------------------


+ (NSInteger)PlanHaveMade
{
    NSString *sql =@"select count(Pid) from Plan ;";
    
    int countPlans = [self returnAnInteger:sql];
        
    return countPlans;  //might be 0
}

+  (NSInteger)EventNumbersOfADay:(NSDate *) date
{
    int pid = [self FetchAPlanForItsPid:date];
    

    NSString *sql =[NSString stringWithFormat:@"select count(Eid) from Event where Pid = '%i' ;",pid];

    int countEvents = [self returnAnInteger:sql];
    
    return countEvents;  //might be 0
}



//---------------------------Create Modify-------------------------------------------
+ (void) CreateAPlan: (NSMutableArray *) events andThoughts:(Thoughts *) thought andEffectedDate:(NSDate *) date
{
        
    [self InsertIntoPlanTable:date];
    
    //after inserting the plan table, we get the inserted Pid
    int pid = [self FetchAPlanForItsPid:date];
    
    //for each object in the array,insert them into the Event table
    
    for(Event *tmpEvent in events)
    {
        [self InsertIntoEventTable:tmpEvent andPid:pid];
    }
    
    
    
    
    //finally,insert thought into thoughts table
    if(thought.Title.length==0&&thought.Content.length==0)
    {
        //will not insert into the table
    }
    else    //insert thought
    {
        [self InsertIntoThoughtTable:thought andPid:pid];
    }
    
}


+ (void) ModifyAPlan: (NSMutableArray *) events andThoughts:(Thoughts *) thought andEffectedDate:(NSDate *) date
{

    //after inserting the plan table, we get the inserted Pid
    int pid = [self FetchAPlanForItsPid:date];
    
    //for each object in the array,insert them into the Event table
    
    for(Event *tmpEvent in events)
    {
        if(tmpEvent.ShouldBeUpdatedInDB == NO)  //then insert
        {
            [self InsertIntoEventTable:tmpEvent andPid:pid];
        }
        else    //then update
        {
            [self UpdateIntoEventTable:tmpEvent andEid:tmpEvent.Eid];
        }
        
    }
    
    
    NSLog(@"pay attention if showed inserted one...");
    //check if thought already exists
    BOOL thoughtExist = [self CheckAThoughtIsThere:pid];
    
    if (thoughtExist == YES) {
        //update stuff

        if(thought.Title.length!=0||thought.Content.length!=0)
        {
            [self UpdateThoughtTable:thought andPid:pid];
        }
        else    //both of them are empty,then delete this thought
        {
 
            [self deleteAThought:pid];
        }
    }
    else    //insert
    {
        if(thought.Title.length!=0||thought.Content.length!=0)
        {
            [self InsertIntoThoughtTable:thought andPid:pid];

        }

    }

    
}
//---------------------------Update-------------------------------------------
+ (void) UpdateIntoCategoryTable: (Category *) category andOld: (Category *) old
{
    NSString *sql =[NSString stringWithFormat:@"UPDATE Category SET CName='%@' WHERE CName='%@';",category.CName,old.CName];
    
    [self executeHelper:sql];

    NSLog(@"Update Category Table succeeded");
}

+ (void) UpdateJustEnabledOfAlarmTable: (Alarm *) tmpAlarm
{
    NSString *sql =[NSString stringWithFormat:@"UPDATE Alarm SET Enabled='%i' WHERE ACid='%i';",tmpAlarm.enabled,tmpAlarm.ACid];
    
    [self executeHelper:sql];
    
    NSLog(@"Update Enabled of Alarm Table succeeded");
}


+ (void) UpdateIntoAlarmTable: (Alarm *) tmpAlarm
{
    NSString *sql =[NSString stringWithFormat:@"UPDATE Alarm SET AlarmTime='%i',Label='%@i',Repeatence='%i',PickedSong='%@',Enabled='%i',NotificationID='%i',ExecuteDateTime = (datetime('now','localtime')) WHERE ACid='%i';",tmpAlarm.AlarmTime,tmpAlarm.Label,tmpAlarm.Repeatence,tmpAlarm.PickedSong,tmpAlarm.enabled,tmpAlarm.notificationID,tmpAlarm.ACid];
    
    [self executeHelper:sql];
    
    NSLog(@"Update Alarm Table succeeded");
}

+ (void) UpdateIntoEventTable: (Event *) tmpEvent andEid:(NSInteger) eid
{
    NSString *sql =[NSString stringWithFormat:@"UPDATE Event SET Ename='%@',StartTime='%i',EndTime='%i',Priority='%d',Category='%@',ExecuteDateTime = (datetime('now','localtime')) WHERE Eid='%i';",tmpEvent.Ename,tmpEvent.StartTime,tmpEvent.EndTime,tmpEvent.Priority,tmpEvent.Category,eid];
    
    [self executeHelper:sql];
    
    NSLog(@"Update Event Table succeeded");
}

+ (void) UpdateThoughtTable: (Thoughts *) thought andPid:(NSInteger) pid
{
    NSString *sql =[NSString stringWithFormat:@"UPDATE Thoughts SET Title='%@',Content='%@',ExecuteDateTime = (datetime('now','localtime')) WHERE Pid='%i';",thought.Title,thought.Content,pid];
    
    [self executeHelper:sql];

    NSLog(@"Update Thought Table succeeded");
}

//-------------------insert-----------------------

+(void) InsertIntoEventTable:(Event *) tmpEvent andPid:(NSInteger) pid
{
    NSString *sql =[NSString stringWithFormat:@"INSERT INTO Event (Pid,Ename,StartTime,EndTime,Priority,Category,isFinished) VALUES ('%i','%@','%i','%i','%i','%@','%d');",pid,tmpEvent.Ename,tmpEvent.StartTime,tmpEvent.EndTime,tmpEvent.Priority,tmpEvent.Category,tmpEvent.isFinished];
    
    [self executeHelper:sql];
    
    NSLog(@"inserted one in Event table");
}





+(NSInteger) InsertIntoAlarmTable:(Alarm *) alarm
{
    NSString *sql =[NSString stringWithFormat:@"INSERT INTO Alarm (AlarmTime,Label,Repeatence,PickedSong,Enabled,NotificationID) VALUES ('%i','%@','%i','%@','%i','%i');",alarm.AlarmTime,alarm.Label,alarm.Repeatence,alarm.PickedSong,alarm.enabled,alarm.notificationID];
    
    int returnID = [self executeHelperReturnInt:sql];
    
    NSLog(@"inserted one in Alarm table");
    return returnID;
}

+(NSInteger) InsertIntoCategoryTable:(Category *) category
{
    NSString *sql =[NSString stringWithFormat:@"INSERT INTO Category (CName,ExecuteDateTime) VALUES ( '%@',(datetime('now','localtime')));",category.CName];
    
    int returnID = [self executeHelperReturnInt:sql];
    
    NSLog(@"inserted one in Category table");
    return returnID;
}


+ (void) InsertIntoThoughtTable: (Thoughts *) thought andPid:(NSInteger) pid
{
    NSString *sql =[NSString stringWithFormat:@"INSERT INTO Thoughts (Pid,Title,Content) VALUES ('%i','%@','%@');",pid,thought.Title,thought.Content];
    
    [self executeHelper:sql];
    
    NSLog(@"Insert Thought Table succeeded");
}

+ (void) InsertIntoPlanTable:(NSDate *) date
{
    int finalDate = [TimeConverting transfromNSDATEtoInt:date];
    
    NSString *sql =[NSString stringWithFormat:@"INSERT INTO Plan (CreateDate,PlanDone) VALUES ('%i',0);",finalDate];
    
    [self executeHelper:sql];
    
    NSLog(@"Insert Plan Table succeeded");
}

//--------------------delete--------------------------------

+ (void)deleteAnEvent: (Event *) event
{
    NSString *sql =[NSString stringWithFormat:@"DELETE FROM Event WHERE Eid ='%i';",event.Eid];
    
    [self executeHelper:sql];
    
    NSLog(@"delete a row in Event table succeeded");
}

+ (void)deleteAnAlarm: (Alarm *) alarm
{
    NSString *sql =[NSString stringWithFormat:@"DELETE FROM Alarm WHERE ACid ='%i';",alarm.ACid];
    [self executeHelper:sql];
    NSLog(@"delete a row in Alarm table succeeded");
}

+ (void)deleteAThought: (NSInteger) pid
{
    NSString *sql =[NSString stringWithFormat:@"DELETE FROM Thoughts WHERE Pid ='%i';",pid];
    [self executeHelper:sql];
    NSLog(@"delete a row in Thoughts table succeeded");
         
}


//-----------------------Check-----------------------------------------------


+ (BOOL)CheckAThoughtIsThere: (NSInteger) pid
{
    //query part
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM Thoughts WHERE Pid='%i';",pid];
    return [self executeHelperReturnBool:sql];
}

+ (BOOL)CheckAPlanIsThere: (NSDate *) TheDate
{
    int finalDate = [TimeConverting transfromNSDATEtoInt:TheDate];
    //query part
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM Plan WHERE CreateDate='%i';",finalDate];
    
    return [self executeHelperReturnBool:sql];
}

+ (BOOL)CheckAnEventIsThere: (Event *) event
{
    //query part
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM Event WHERE Eid='%i';",event.Eid];
    
    return [self executeHelperReturnBool:sql];
}

+ (BOOL)CheckCategoryNotEmpty
{
    //query part
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM Category;"];
    return [self executeHelperReturnBool:sql];
}

//--------------------------Fetch------------------------------------

+ (NSInteger)FetchAPlanForItsPid: (NSDate *) TheDate
{
    int finalDate = [TimeConverting transfromNSDATEtoInt:TheDate];
    //query part
    NSString *sql =[NSString stringWithFormat:@"SELECT Pid FROM Plan WHERE CreateDate='%i';",finalDate];
    return [self executeHelperReturnPid:sql];

}

+ (NSInteger)FetchAPlanForItsPidByInt: (NSInteger) date
{
    //query part
    NSString *sql =[NSString stringWithFormat:@"SELECT Pid FROM Plan WHERE CreateDate='%i';",date];
    return [self executeHelperReturnPid:sql];
}

+ (NSInteger)FetchACategoryForItsCidMinusOne:(NSString *) name
{
    //query part
    NSString *sql =[NSString stringWithFormat:@"SELECT Cid FROM Category WHERE CName='%@';",name];
    
    int result = [self executeHelperReturnPid:sql];
    
    NSLog(@"result is: %i",result);
    
    if(result!=-1)
    {
        return result-1;
    }
    else
        return result;
}

+ (Thoughts *)fetchThought: (NSDate *) TheDate
{
    int pid = [self FetchAPlanForItsPid:TheDate];

    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM Thoughts WHERE Pid='%i';",pid];

    return [self executeHelperFetchingAThought:sql];
}

+ (Thoughts *)fetchThoughtByInt: (NSInteger) date
{
    int pid = [self FetchAPlanForItsPidByInt:date];

    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM Thoughts WHERE Pid='%i';",pid];
	
    return [self executeHelperFetchingAThought:sql];
}

+ (NSMutableArray *)fetchAllTheThoughts
{
    NSMutableArray *thoughts = [NSMutableArray array];
    
    sqlite3_stmt *stm = nil;
    NSString *sql =[NSString stringWithFormat:@"SELECT b.CreateDate,a.Title,a.Content,a.Tid,a.Pid FROM Thoughts a,Plan b WHERE a.Pid=b.Pid order by b.CreateDate desc;"];
	if (stm == nil)
    {
		if (sqlite3_prepare_v2(PEDatabase, [sql UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
		}
	}
        
    while (sqlite3_step(stm) == SQLITE_ROW)
	{
        Thoughts *tmp = [[Thoughts alloc]init];
        tmp.CreateDate = sqlite3_column_int(stm, 0);
        tmp.Title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 1)];
        tmp.Content = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 2)];
        tmp.Tid = sqlite3_column_int(stm, 3);
        tmp.Pid = sqlite3_column_int(stm, 4);
        [thoughts addObject:tmp];
    }
    
    return thoughts;
    
}


// fetch data from event table
+ (NSMutableArray *)fetchEvents: (NSDate *) TheDate
{
    sqlite3_stmt *stm = nil;
    int finalDate = [TimeConverting transfromNSDATEtoInt:TheDate];
    
    NSMutableArray *Events = [NSMutableArray array];
    
    //query part 1
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM Plan WHERE CreateDate='%i';",finalDate];
	if (stm == nil)
    {
		if (sqlite3_prepare_v2(PEDatabase, [sql UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
		}
	}
    
    while (sqlite3_step(stm) == SQLITE_ROW)   //actually,execute only once
    {
        int gotPid = sqlite3_column_int(stm, 0);
        //query part 2
        Events = [self fetchEventsByPid:gotPid];
    }
    
    return Events;  //might be null
    
}

+ (NSMutableArray *)fetchEventNamesByPid: (NSInteger) Pid
{
    sqlite3_stmt *stm = nil;
    NSMutableArray *EventNames = [NSMutableArray array];
    NSString *sql2 =[NSString stringWithFormat:@"select e.Ename from Event e,Plan p where p.Pid = e.Pid and p.Pid = '%i';",Pid];
    
    if (stm == nil)
    {
        if (sqlite3_prepare_v2(PEDatabase, [sql2 UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
        }
    }
    while (sqlite3_step(stm) == SQLITE_ROW)
    {
        [EventNames addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 0)]];
    }
    return EventNames;
}



+ (NSMutableArray *)fetchEventsByPid: (NSInteger) Pid
{
    sqlite3_stmt *stm = nil;
    NSMutableArray *Events = [NSMutableArray array];
    NSString *sql2 =[NSString stringWithFormat:@"select e.Eid,e.Pid,e.Ename,e.StartTime,e.EndTime,e.Priority,e.Category,e.isFinished from Event e,Plan p where p.Pid = e.Pid and e.isFinished = 0 and p.Pid = '%i';",Pid];
    
    if (stm == nil)
    {
        if (sqlite3_prepare_v2(PEDatabase, [sql2 UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
        }
    }
    while (sqlite3_step(stm) == SQLITE_ROW)
    {
        Event *tmpEvent = [[Event alloc] init];
        tmpEvent.Eid = sqlite3_column_int(stm, 0);
        tmpEvent.Pid = sqlite3_column_int(stm, 1);
        tmpEvent.Ename = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 2)];
        tmpEvent.StartTime = sqlite3_column_int(stm, 3);
        tmpEvent.EndTime = sqlite3_column_int(stm, 4);
        tmpEvent.Priority = sqlite3_column_int(stm, 5);
        tmpEvent.Category = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 6)];
        tmpEvent.isFinished = sqlite3_column_int(stm, 7);
        
        [Events addObject:tmpEvent];
    }
    return Events;
}

+ (NSMutableArray *)fetchEventsByInt: (NSInteger) date
{
    sqlite3_stmt *stm = nil;
        
    NSMutableArray *Events = [NSMutableArray array];
    
    //query part 1
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM Plan WHERE CreateDate='%i';",date];
	if (stm == nil)
    {
		if (sqlite3_prepare_v2(PEDatabase, [sql UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
		}
	}
    
    while (sqlite3_step(stm) == SQLITE_ROW)   //actually,execute only once
    {
        int gotPid = sqlite3_column_int(stm, 0);
        //query part 2
        Events = [self fetchEventsByPid:gotPid];
    }
    
    return Events;  //might be null
    
}



+ (NSMutableArray *)fetchCategory
{
    NSMutableArray *categories = [NSMutableArray array];
    sqlite3_stmt *stm = nil;
    NSString *sql =[NSString stringWithFormat:@"SELECT distinct CName FROM Category order by ExecuteDateTime desc;"];
	if (stm == nil)
    {
		if (sqlite3_prepare_v2(PEDatabase, [sql UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
			NSAssert1(0, @"Error!!: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
		}
	}
    
    
    while (sqlite3_step(stm) == SQLITE_ROW)
	{
        Category *tmp = [[Category alloc]init];
        tmp.CName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 0)];
        [categories addObject:tmp];
    }
    return categories;
    
}

+ (NSMutableArray *)fetchAlarms
{
    NSMutableArray *alarms = [NSMutableArray array];
    sqlite3_stmt *stm = nil;
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM Alarm order by ExecuteDateTime desc;"];
	if (stm == nil)
    {
		if (sqlite3_prepare_v2(PEDatabase, [sql UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
		}
	}
    
    
    while (sqlite3_step(stm) == SQLITE_ROW)
	{
        Alarm *tmp = [[Alarm alloc]init];
        tmp.ACid = sqlite3_column_int(stm, 0);
        tmp.AlarmTime = sqlite3_column_int(stm, 1);
        tmp.Label = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 2)];
        tmp.Repeatence = sqlite3_column_int(stm, 3);
        tmp.PickedSong = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 4)];
        tmp.enabled =  sqlite3_column_int(stm, 5);
        tmp.notificationID =  sqlite3_column_int(stm, 6);
        [alarms addObject:tmp];
    }
    return alarms;
    
}





+ (NSMutableArray *)fetchPlans
{
    //query part
    NSString *sql =[NSString stringWithFormat:@"select * from Plan order by CreateDate desc;" ];

    return [self executeHelperFetchingPlans:sql];   //might be null
}


+ (NSMutableArray *)fetchPlans:(NSInteger) doneOrNot
{
    //query part
    NSString *sql =[NSString stringWithFormat:@"select * from Plan where CreateDate ='%i' order by CreateDate desc;",doneOrNot];
    
    return [self executeHelperFetchingPlans:sql];   //might be null
}

+ (NSMutableArray *)fetchPlansWithLimits: (NSInteger) limit butExceptToday:(NSDate *)date
{
    int finalDate = [TimeConverting transfromNSDATEtoInt:date];
    
    //query part
    NSString *sql =[NSString stringWithFormat:@"select * from Plan where CreateDate!='%i' order by CreateDate desc limit %i;",finalDate,limit];
    
    return [self executeHelperFetchingPlans:sql];   //might be null
}

+ (NSMutableArray *)fetchEventNamesWithLimits: (NSInteger) limit
{
    sqlite3_stmt *stm = nil;

    NSMutableArray *events = [NSMutableArray array];
    //query part
    NSString *sql =[NSString stringWithFormat:@"select Ename from Event order by ExecuteDateTime desc limit %i;",limit];
    if (stm == nil)
    {
		if (sqlite3_prepare_v2(PEDatabase, [sql UTF8String], -1, &stm, NULL) != SQLITE_OK)
        {
			NSAssert1(0, @"!Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(PEDatabase));
		}
	}
	while (sqlite3_step(stm) == SQLITE_ROW)
	{
		Event *tmpEvent = [[Event alloc] init];
        tmpEvent.Ename = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 0)];
		[events addObject:tmpEvent.Ename];  //just add Ename but not Event obj
	}

    return events;   //might be null
}

+(NSInteger)fetchCreateDateByPid:(NSInteger) pid
{
    NSString *sql =[NSString stringWithFormat:@"select CreateDate from Plan where Pid = '%i';",pid];
    
    int returnIntCreateDate = [self returnAnInteger:sql];
    
    return returnIntCreateDate;
}

+(NSInteger)fetchPidByCreateDate:(NSDate *) date
{
    int tmp = [TimeConverting transfromNSDATEtoInt:date];
    NSString *sql =[NSString stringWithFormat:@"select Pid from Plan where CreateDate = '%i';",tmp];
    
    int returnPid = [self returnAnInteger:sql];
    
    return returnPid;
}


+(void)initializeCategoryTable
{
    NSArray *categories = @[@"Class",@"Homework",@"Family",@"Music",@"Date",@"Reading",@"Movie",@"Project",@"Gym"];
    
    for(NSString *tmpC in categories)
    {
        NSString *sql =[NSString stringWithFormat:@"INSERT INTO Category (CName) VALUES ('%@');",tmpC];
    
        [self executeHelper:sql];
    
        NSLog(@"inserted one in Category table");
    }
}


@end
