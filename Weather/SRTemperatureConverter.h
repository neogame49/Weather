//
//  SRTemperatureConverter.h
//  Weather
//
//  Created by Macbook on 27.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum
//{
//    SRTemperatureConverterMeasureCelsius = 0,
//    SRTemperatureConverterFahrenheit,
//    SRTemperatureConverterMeasureKelvin
//    
//} SRTemperatureConverterMeasure;

typedef NS_ENUM(NSInteger, SRTemperatureConverterMeasure)
{
    SRTemperatureConverterMeasureCelsius = 0,
    SRTemperatureConverterFahrenheit,
    SRTemperatureConverterMeasureKelvin
};

@interface SRTemperatureConverter : NSObject

// convertet string from kelvin measure to target type measure
// and added spacial symbol to the end
// also kelvin parameter must be converted to double value
-(NSString*) converFromKelvin:(NSString*) kelvin to:(SRTemperatureConverterMeasure) targetType;

@end
