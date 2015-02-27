//
//  NSDate+Utilities.m
//  Converter
//
//  Created by Macbook on 13.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)



- (NSInteger) minutesAfterDate: (NSDate *) date
{
    NSTimeInterval ti = [self timeIntervalSinceDate:date];
    return (NSInteger) (ti / 60);
    
}

- (NSInteger) hoursAfterDate: (NSDate *) date
{
    NSTimeInterval ti = [self timeIntervalSinceDate:date];
    return (NSInteger) (ti / 3600);
}

-(NSDate*) beginingOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *components = [calendar components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:self];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [calendar dateFromComponents:components];

}


#pragma mark - supported methods

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) date
{
    const unsigned componentFlags = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);
    
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:componentFlags fromDate:date];
    
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}



@end
