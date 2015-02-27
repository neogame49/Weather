//
//  SRSettingManager.m
//  Weather
//
//  Created by Macbook on 20.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import "SRSettingsManager.h"

@implementation SRSettingsManager

+(SRSettingsManager*) sharedManager
{
    static SRSettingsManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SRSettingsManager alloc] init];
    });
    
    return manager;
}

-(void) saveLocation:(NSString*) location
{
    [[NSUserDefaults standardUserDefaults] setObject:location forKey:[self locationKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString*) loadLocation
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self locationKey]];
    
}

-(void) saveMeasurementScale:(SRTemperatureConverterMeasure) measurementScale
{
    [[NSUserDefaults standardUserDefaults] setInteger:measurementScale forKey:[self measurementScaleKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
-(SRTemperatureConverterMeasure) measurementScale
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:[self measurementScaleKey]];
}

-(void)saveDaysOfWeatherForecast:(NSNumber*) numberOfDays
{
    [[NSUserDefaults standardUserDefaults] setObject:numberOfDays forKey:[self daysOfWeatherForecastKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSNumber*) daysOfWeatherForecast
{
    NSNumber* result =[[NSUserDefaults standardUserDefaults] objectForKey:[self daysOfWeatherForecastKey]];
    return result ? result : @7;
}

#pragma mark - supported keys methods

-(NSString*) locationKey
{
    return @"com.SherbiyRoman locationKey";
}
-(NSString*) measurementScaleKey
{
    return @"com.SherbiyRoman measurementScaleKey";
}

-(NSString*) daysOfWeatherForecastKey
{
    return @"com.SherbiyRoman daysOfWeatherForecast";
}


@end
