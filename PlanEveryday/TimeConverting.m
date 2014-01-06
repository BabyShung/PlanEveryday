//
//  TimeConverting.m
//  PlanEveryday
//
//  Created by Hao Zheng on 4/28/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "TimeConverting.h"

@implementation TimeConverting

//transfrom NSDATE to int rep.    eg. 130620    year month day
+(NSInteger) transfromNSDATEtoInt:(NSDate *) tmp
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:tmp]; // Get necessary date components
    
    int year = [components year]; //gives you year
    int month = [components month];
    int day = [components day];
    int finalDate = year*10000+month*100+day;
    return finalDate;
}

//transfrom NSDATE to int rep.    EG: 0621  (minute second)
+(NSInteger) transfromNSDATEMinuteHourtoInt:(NSDate *) tmp
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:tmp]; // Get necessary date components
    
    int minute = [components minute]; //gives you minute
    int hour = [components hour];
    int finalTime = hour*100+minute;
    return finalTime;
}

+(NSString *)getDayOfWeek:(NSDate *) date andAbbreviation:(BOOL) abbreviate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(abbreviate)
    {
        [dateFormatter setDateFormat:@"EEE"];
    }
    else
    {
        [dateFormatter setDateFormat:@"EEEE"];
    }
    return [dateFormatter stringFromDate:date];
}


+(BOOL)setDateLargerThenRightNow:(NSDate *) setDate
{    
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* today = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    NSLog(@"source today local: %@",today);
    if([today compare:setDate]==NSOrderedAscending)
    {
        NSLog(@"setDate larger-----");
        return YES;
    }
    else
    {
        NSLog(@"today larger------");
        return NO;
    }
}

+(NSDate *)GetLocalTime:(NSDate *)date
{
    NSDate* sourceDate2 = date;
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate2];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate2];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* today = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate2];
    
    NSLog(@"--!local?-%@",today);
    return today;
}


+(NSDate *)getLocalTime:(NSDate *)date andhourMinute:(NSInteger) hourminute
{
    NSCalendar* calendar2 = [NSCalendar currentCalendar];
    NSDateComponents* components2 = [calendar2 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
    
    int year = [components2 year];
    int month = [components2 month];
    int day = [components2 day];
    int hour=hourminute/100;
    int minute=hourminute%100;
    
    //get the local time
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setTimeZone:[NSTimeZone defaultTimeZone]];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    
    //you can put nsdate date here
    NSDate* sourceDate = [calendar dateFromComponents:components];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    NSLog(@"--!local?-%@",destinationDate);
    return destinationDate;
}

+(NSDate *)getNotLocalTime:(NSDate *)date andhourMinute:(NSInteger) hourminute
{
    NSCalendar* calendar2 = [NSCalendar currentCalendar];
    NSDateComponents* components2 = [calendar2 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
    
    int year = [components2 year];
    int month = [components2 month];
    int day = [components2 day];
    int hour=hourminute/100;
    int minute=hourminute%100;
    
    //get the local time
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setTimeZone:[NSTimeZone defaultTimeZone]];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    
    //you can put nsdate date here
    NSDate* sourceDate = [calendar dateFromComponents:components];
    NSLog(@"Returned, not local: %@",sourceDate);
    //Note!!! just return the machine oringinal date
    return sourceDate;
}

+(NSDate *)getNSDateFromInt:(NSInteger) hourminute
{
    NSCalendar* calendar2 = [NSCalendar currentCalendar];
    NSDateComponents* components2 = [calendar2 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]]; // Get necessary date components
    
    int year = [components2 year];
    int month = [components2 month];
    int day = [components2 day];
    int hour=hourminute/100;
    int minute=hourminute%100;
    
    //get the local time
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setTimeZone:[NSTimeZone defaultTimeZone]];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    
    //you can put nsdate date here
    NSDate* sourceDate = [calendar dateFromComponents:components];
    
    NSLog(@"Get NSDate ****-----: %@",sourceDate);

    //Note!!! just return the machine oringinal date
    return sourceDate;
}



+(int)CurrentYear
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]]; // Get necessary date components
    
    int year = [components year]; //gives you year
    return year;
}

+(int)CurrentTimeToSliderValue  //return minutes corresponding to slider value,minute as unit
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[NSDate date]]; // Get necessary date components
    
    int hour = [components hour]; //gives you hour
    int minute = [components minute]; //gives you minute
    int result = hour*60+minute;
    return result;
}


+(int)SliderValueToIntegerEXPofDate:(NSInteger) value andAMPM:(NSString *) AMPM
{
    //calculate date -------*****
    int tmpInt = value;
    if([AMPM isEqualToString:@"PM"])
    {
        tmpInt+=720;
    }
    
    int leftMinutes = [self CountMinutesLeftByIntSliderValue:value andAMPM:AMPM];
    
    int currentTimeInMinues = [self CurrentTimeToSliderValue];
    int minutesLeftTill24 = [self CountMinutesLeftByIntSliderValue:currentTimeInMinues andAMPM:AMPM];
    
    int result;
    if(minutesLeftTill24<leftMinutes)   //has to add a day, tomorrow
    {
        result = [self sliderValueToIntegerTime:tmpInt] + 2400;
    }
    else
    {
        result = [self sliderValueToIntegerTime:tmpInt];
    }
    
    return result;
}




+(BOOL)EventTimeIsExpired:(NSInteger) time
{
    int currentTimeByInt = [self transfromNSDATEMinuteHourtoInt:[NSDate date]];
    if(time<currentTimeByInt)
        return YES;
    else
        return NO;
}

//---------------1-----------------
//---------------1-----------------
//---------------1-----------------
//para 1st: eg. 1658    means 16:58
+(NSString *)LEFTHOURSIntValueTOString:(NSInteger) intTime
{
    //eg. 1658 -> slider value
    
    int totalMinutes = [self IntegerTimeToSliderValue:intTime];
    NSString *hourleft;
    
    int currentTimeInMinues = [self CurrentTimeToSliderValue];
    
    //choose AM so that doesnt have to add 720
    hourleft = [self calculateReturnString:totalMinutes andCT:currentTimeInMinues];
    return hourleft;
}
//---------------------------------
//---------------------------------
//---------------------------------

+(NSInteger)CountMinutesLeftByIntSliderValue:(NSInteger) totalMinutes andAMPM:(NSString *) AMPM
{
    if([AMPM isEqualToString:@"PM"])
    {
        totalMinutes+=720;
    }
    
    int currentTimeInMinues = [self CurrentTimeToSliderValue];
    
    if(totalMinutes<currentTimeInMinues)
    {
        totalMinutes+=1440;       
    }
    int leftMinutes = totalMinutes-currentTimeInMinues;
    
    return leftMinutes;
}

//----------------2----------------
//----------------2----------------
//----------------2----------------
+(NSString *)CountHoursLeft:(NSInteger) totalMinutes andAMPM:(NSString *) AMPM
{
    NSString *returnString;
    if([AMPM isEqualToString:@"PM"])
    {
        totalMinutes+=720;
    }

    int currentTimeInMinues = [self CurrentTimeToSliderValue];

    if(totalMinutes<currentTimeInMinues)
    {
        totalMinutes+=1440;
        returnString = [self calculateReturnString:totalMinutes andCT:currentTimeInMinues];
        
    }
    else
    {
        returnString = [self calculateReturnString:totalMinutes andCT:currentTimeInMinues];
    }
    return returnString;
}
//---------------------------------
//---------------------------------
//---------------------------------



+(NSString *)CountHoursLeftForAlarmClock:(NSInteger) totalMinutes andAMPM:(NSString *) AMPM
{
    NSString *returnString;
    if([AMPM isEqualToString:@"PM"])
    {
        totalMinutes+=720;
    }
    
    int currentTimeInMinues = [self CurrentTimeToSliderValue];
    
 
    if(totalMinutes<currentTimeInMinues)
    {
        totalMinutes+=1440;
        returnString = [self calculateReturnString:totalMinutes andCT:currentTimeInMinues];
    }
    else
    {
        returnString = [self calculateReturnString:totalMinutes andCT:currentTimeInMinues];
    }
    return returnString;
}


//+(NSString *)CountHoursLeftWithExpired:(NSInteger) totalMinutes andNeedToShowExpire:(BOOL) showExpire
//{
//    NSString *returnString;
//    
//    int currentTimeInMinues = [self CurrentTimeToSliderValue];
//    
//    if(totalMinutes<currentTimeInMinues)
//    {
//        if(showExpire)
//            returnString = @"Expired";
//        else
//            returnString = @"";
//    }
//    else
//    {
//        returnString = [self calculateReturnString:totalMinutes andCT:currentTimeInMinues];
//    }
//    return returnString;
//}


//transfrom NSDATE to NSString
+(NSString *) transfromNSDATEtoNSString2:(NSDate *) tmp
{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:tmp]; // Get necessary date components
    
    int hour = [components hour]; //gives you month
    int minute = [components minute]; //gives you day
    NSString *AMPM;
    NSString *finalDate;
    if(hour>12)
    {
        hour%=12;
        AMPM=@"PM";
        NSLog(@"date goes here");
    }
    else
    {
        AMPM=@"AM";
    }
    if (minute<10) {
        finalDate = [NSString stringWithFormat:@"%i:0%i %@",hour,minute,AMPM];
    }
    else
    {
        finalDate = [NSString stringWithFormat:@"%i:%i %@",hour,minute,AMPM];
    }
    return finalDate;
}


//EG: nsdate -> Jun 26 2013
+(NSString *) transfromNSDATEtoNSString:(NSDate *) tmp
{
    NSLog(@"methoding : %@",tmp);
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd"];
    NSString *myDayString = [NSString stringWithFormat:@"%@",[df stringFromDate:tmp]];
    [df setDateFormat:@"yyyy"];
    NSString *myYearString = [NSString stringWithFormat:@"%@",[df stringFromDate:tmp]];
    [df setDateFormat:@"MMM"];
    NSString *myMonthString = [NSString stringWithFormat:@"%@",[df stringFromDate:tmp]];

    NSLog(@"methoding day: %@",myDayString);

    NSString *finalDate = [NSString stringWithFormat:@"%@ %@ %@",myMonthString,myDayString,myYearString];
    return finalDate;
}

//EG: nsdate -> Jun 26th,2013.
+(NSString *) transfromNSDATEtoNSString3:(NSDate *) tmp
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd"];
    NSString *myDayString = [NSString stringWithFormat:@"%@",[df stringFromDate:tmp]];
    [df setDateFormat:@"yyyy"];
    NSString *myYearString = [NSString stringWithFormat:@"%@",[df stringFromDate:tmp]];
    [df setDateFormat:@"MMM"];
    NSString *myMonthString = [NSString stringWithFormat:@"%@",[df stringFromDate:tmp]];
    
    
    //analysis
    NSString *sub = [myDayString substringToIndex:1];
    
    if([sub isEqualToString:@"0"])
    {
        if([myDayString isEqualToString:@"01"])
        {
            myDayString = @"1st";
        }
        else if([myDayString isEqualToString:@"02"])
        {
            myDayString = @"2nd";
        }
        else if([myDayString isEqualToString:@"01"])
        {
            myDayString = @"3rd";
        }
        else
        {
            myDayString = [NSString stringWithFormat:@"%@th",[myDayString substringFromIndex:1]];
        }
    }
    else
    {
        myDayString = [NSString stringWithFormat:@"%@th",myDayString];
    }
    
    
    NSString *finalDate = [NSString stringWithFormat:@"%@ %@, %@",myMonthString,myDayString,myYearString];
    return finalDate;
}

//eg. 130620 -> 06/20/13
+(NSString *)TimeDateINTToString:(NSInteger) tmp
{
    int year = tmp/10000;
    int month= tmp%10000/100;
    int day= tmp%100;
    NSString *finalString;
    if(month<10&&day<10)
    {
        finalString = [NSString stringWithFormat:@"0%i/0%i/%i",month,day,year];
    }
    else if(month<10)
    {
        finalString = [NSString stringWithFormat:@"0%i/%i/%i",month,day,year];
    }
    else if(day<10)
    {
        finalString = [NSString stringWithFormat:@"%i/0%i/%i",month,day,year];
    }
    
    return finalString;
}

//eg. 130620 -> Tue, Jun 28th 2013
+(NSString *)TimeDateINTToString2:(NSInteger) tmp
{
    int year = tmp/10000;
    int month= tmp%10000/100;
    int day= tmp%100;
    
    
    //get the local time
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setTimeZone:[NSTimeZone defaultTimeZone]];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];    
    //you can put nsdate date here
    NSDate *sourceDate = [calendar dateFromComponents:components];
    NSString *dayofweek = [self getDayOfWeek:sourceDate andAbbreviation:YES];
    NSString *finalString =[NSString stringWithFormat:@"%@, %@", dayofweek,[self transfromNSDATEtoNSString3:sourceDate]];
    
    return finalString;
}

//eg. 1657 -> 04:57 pm
+(NSString *)TimeIntToString:(NSInteger) tmp
{
    int hour = tmp/100;
    int minute= tmp%100;
    NSString *AMPM;
    if(hour-12>=0)
    {
        if (hour!=12) {
            hour-=12;
        }
        AMPM=@"PM";
    }
    else
        AMPM=@"AM";
    
    if (hour == 24) {
        hour = 0;
        AMPM=@"AM";
    }
    
    NSString *finalString;
    if (minute<10) {
        finalString = [NSString stringWithFormat:@"%i:0%i %@",hour,minute,AMPM];
    }
    else
    {
        finalString = [NSString stringWithFormat:@"%i:%i %@",hour,minute,AMPM];
    }
    
    return finalString;
}


//-----------------------------------------------------------------
//-----------Private Helper  --------------------------------------
//-----------------------------------------------------------------
+(NSInteger)sliderValueToIntegerTime:(NSInteger) sliderValue
{
    int hour=sliderValue/60;
    int minute=sliderValue%60;
    sliderValue=hour*100+minute;
    NSLog(@"sliderValueToIntegerTime: %i",sliderValue);
    return sliderValue;
}

+(NSInteger)IntegerTimeToSliderValue:(NSInteger) intTime
{
    int hour=intTime/100;
    int minute=intTime%100;
    intTime=hour*60+minute;
    return intTime;
}

//calculate a return "minute left" string, taking 1st: the int rep. of aimed time
//and 2nd: the int rep. of current time     (minute as unit)
+(NSString *)calculateReturnString:(NSInteger) totalMinutes andCT:(NSInteger) currentTimeInMinues
{
    NSString *returnString;
    int leftMinutes = totalMinutes-currentTimeInMinues;
    if(leftMinutes<0)   //time expired
    {
        returnString = @"expired";
        return returnString;
    }
    
    int minuteInAHour = leftMinutes%60;
    int exactHour = leftMinutes/60;
    if(exactHour == 0)
    {
        if(minuteInAHour==1)
        {
            returnString = @"1 minute left";
        }
        else if(minuteInAHour==0)
        {
            returnString =@"";
        }
        else
        {
            returnString = [NSString stringWithFormat:@"%i minutes left",minuteInAHour];
        }
    }
    else if(exactHour ==1 )
    {
        if(minuteInAHour==0)
        {
            returnString = @"1 hour left";
        }
        else if(minuteInAHour==1)
        {
            returnString = @"1 hour and 1 minute left";
        }
        else
        {
            returnString = [NSString stringWithFormat:@"1 hour and %i minutes left",minuteInAHour];
        }
    }
    else    //hours > 1
    {
        if(minuteInAHour==0)
        {
            returnString = [NSString stringWithFormat:@"%i hours left",exactHour];
        }
        else if(minuteInAHour==1)
        {
            returnString = [NSString stringWithFormat:@"%i hours and 1 minute left",exactHour];
        }
        else
        {
            returnString = [NSString stringWithFormat:@"%i hours and %i minutes left",exactHour,minuteInAHour];
        }
        
    }
    return returnString;
}


@end
