//
//  AITicker.m
//  PlanEveryday
//
//  Created by Hao Zheng on 5/12/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "AITicker.h"
#import "TimeConverting.h"
#import "OperationsWithDB.h"
#import "Event.h"
@implementation AITicker

+(NSString *) getNumberOfTodayPlan:(NSDate *)date
{
    int count = [OperationsWithDB EventNumbersOfADay:date];
    NSString *result;
    if(count == 0)
    {
        result = [NSString stringWithFormat:@"No Event today. "];

    }
    else if(count == 1)
    {
        result = [NSString stringWithFormat:@"You have %i event today. ",count];
    }
    else
    {
        result = [NSString stringWithFormat:@"You have %i events today. ",count];
    }
    return  result;
}

+(NSString *) Greetings
{
    int now = [TimeConverting transfromNSDATEMinuteHourtoInt:[NSDate date]];
    NSString *result;
    if(now>=500&&now<1100)  //5am to 11am
    {
        result = [NSString stringWithFormat:@"Good morning! "];
    }
    else if(now>=1200&&now<1700)    //12pm to 17pm
    {
        result = [NSString stringWithFormat:@"Good afternoon! "];
    }
    else if(now>=1700&&now<2300)    //17pm to 23pm
    {
        result = [NSString stringWithFormat:@"Good evening! "];
    }
    else if((now>=2300&&now<=2400)||(now>=0&&now<=300)) //23pm to 3am
    {
        result = [NSString stringWithFormat:@"Have a Good night! "];
    }
    else
    {
        result = @"Have a good one! ";
    }
    return  result;
}

//show the next upcoming event
+(NSString *) UpcomingEventOfTodayPlan:(NSDate *)date
{
    NSMutableArray *tmpM = [OperationsWithDB fetchEvents:date];
    
    if([tmpM count]==0)
    {
        return @"";
    }
    else
    {
        int now = [TimeConverting transfromNSDATEMinuteHourtoInt:date];
        Event *minE = [[Event alloc]init];

        for(Event *tmpE in tmpM)
        {
            if(minE.StartTime==0&&tmpE.StartTime>now)
            {
                minE=tmpE;
            }
            else if(minE.StartTime>tmpE.StartTime&&tmpE.StartTime>now)
            {
                minE=tmpE;
            }
        }
        
        if(minE.Ename.length==0)
        {
            return @"";
        }
        NSString *trans = [TimeConverting TimeIntToString:minE.StartTime];
        NSString *hourminLeft = [TimeConverting LEFTHOURSIntValueTOString:minE.StartTime];
        NSString *result = [NSString stringWithFormat:@"Upcoming event: %@ at %@, %@. ",minE.Ename,trans,hourminLeft];
        return result;
    }
    
}

@end
