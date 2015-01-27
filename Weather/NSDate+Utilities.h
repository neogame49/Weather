//
//  NSDate+Utilities.h
//  Converter
//
//  Created by Macbook on 13.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utilities)


- (BOOL) isToday;
- (BOOL) isTomorrow;


- (NSInteger) minutesAfterDate: (NSDate *) date;
- (NSInteger) hoursAfterDate: (NSDate *) date;

-(NSDate*) beginingOfDay;
@end
