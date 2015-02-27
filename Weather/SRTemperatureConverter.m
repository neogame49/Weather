//
//  SRTemperatureConverter.m
//  Weather
//
//  Created by Macbook on 27.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import "SRTemperatureConverter.h"

static  NSString* kCelsiusSymbol = @"\u00B0C";
static  NSString* kFahrenheitSymbol = @"\u2109";
static  NSString*  kKelvinSymbol = @"\u212A";


@implementation SRTemperatureConverter

-(NSString*) converFromKelvin:(NSString*) kelvin to:(SRTemperatureConverterMeasure) targetType
{
    NSString* result = nil;
    double doubleValue = kelvin.doubleValue;
    
    switch (targetType)
    {
        case SRTemperatureConverterMeasureKelvin:
            doubleValue = round(doubleValue);
            result = [[NSString stringWithFormat:@"%ld", (NSInteger)doubleValue]
                      stringByAppendingString:kKelvinSymbol];
            break;
        case SRTemperatureConverterMeasureCelsius:
            doubleValue = round(doubleValue - 273.15);
            result = [[NSString stringWithFormat:@"%ld", (NSInteger)doubleValue]
                      stringByAppendingString:kCelsiusSymbol];
            break;
        case SRTemperatureConverterFahrenheit:
            doubleValue = round(1.8 * (doubleValue - 273.15) + 32);
            result = [[NSString stringWithFormat:@"%ld", (NSInteger)doubleValue]
                      stringByAppendingString:kFahrenheitSymbol];

            break;
    }
    
    return result;
}


@end
