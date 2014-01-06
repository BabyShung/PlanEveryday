//
//  TimeConverting.h
//  PlanEveryday
//
//  Created by Hao Zheng on 4/28/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeConverting : NSObject 

+(NSString *)getDayOfWeek:(NSDate *) date andAbbreviation:(BOOL) abbreviate;  //Mon, Tue, ..

+(int)CurrentYear;

+(int)CurrentTimeToSliderValue;//720, minute as unit

+(NSInteger)CountMinutesLeftByIntSliderValue:(NSInteger) totalMinutes andAMPM:(NSString *) AMPM;

+(NSString *)CountHoursLeft:(NSInteger) totalMinutes andAMPM:(NSString *) AMPM;

+(NSString *)CountHoursLeftForAlarmClock:(NSInteger) totalMinutes andAMPM:(NSString *) AMPM;

+(int)SliderValueToIntegerEXPofDate:(NSInteger) value andAMPM:(NSString *) AMPM;

+(NSString *) transfromNSDATEtoNSString:(NSDate *) tmp;

+(NSString *) transfromNSDATEtoNSString2:(NSDate *) tmp;

+(NSString *) transfromNSDATEtoNSString3:(NSDate *) tmp;

+(NSString *)TimeIntToString:(NSInteger) tmp;

+(NSString *)LEFTHOURSIntValueTOString:(NSInteger) intTime;

+(BOOL)EventTimeIsExpired:(NSInteger) time;

+(NSDate *)getLocalTime:(NSDate *)date andhourMinute:(NSInteger) hourminute;

+(NSDate *)getNotLocalTime:(NSDate *)date andhourMinute:(NSInteger) hourminute;

+(NSDate *)getNSDateFromInt:(NSInteger) hourminute;

+(BOOL)setDateLargerThenRightNow:(NSDate *) setDate;

+(NSString *)TimeDateINTToString:(NSInteger) tmp;

+(NSString *)TimeDateINTToString2:(NSInteger) tmp;

+(NSDate *)GetLocalTime:(NSDate *)date;

+(NSInteger) transfromNSDATEtoInt:(NSDate *) tmp;

+(NSInteger) transfromNSDATEMinuteHourtoInt:(NSDate *) tmp;

+(NSInteger)IntegerTimeToSliderValue:(NSInteger) intTime;

+(NSInteger)sliderValueToIntegerTime:(NSInteger) sliderValue;


@end
