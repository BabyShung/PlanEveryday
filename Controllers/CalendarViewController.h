//
//  CalendarViewController.h
//  PlanEveryday
//
//  Created by Hao Zheng on 4/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperationsWithDB.h"
#import "Event.h"
#import <Calendar/TapkuLibrary/TapkuLibrary.h>


@interface CalendarViewController : TKCalendarMonthTableViewController <UITableViewDelegate, UITableViewDelegate>
{
    NSMutableArray *contents;
}

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableDictionary *dataEvents;

- (void) fetchDataForStartDate:(NSDate*)start endDate:(NSDate*)end;

- (IBAction)LeftToggleBtn:(id)sender;
- (IBAction)RightToggleBtn:(id)sender;

@end
