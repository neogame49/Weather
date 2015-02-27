//
//  SRSettingManager.h
//  Weather
//
//  Created by Macbook on 20.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRTemperatureConverter.h"

@interface SRSettingsManager : NSObject

+(SRSettingsManager*) sharedManager;

-(void) saveLocation:(NSString*) location;
-(NSString*) loadLocation;

-(void) saveMeasurementScale:(SRTemperatureConverterMeasure) measurementScale;
-(SRTemperatureConverterMeasure) measurementScale;

-(void)saveDaysOfWeatherForecast:(NSNumber*) numberOfDays;
-(NSNumber*) daysOfWeatherForecast;

@end
