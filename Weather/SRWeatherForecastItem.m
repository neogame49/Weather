//
//  SRWeatherForecastItem.m
//  Weather
//
//  Created by Macbook on 19.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import "SRWeatherForecastItem.h"
#import "SRIcon.h"
#import "SRWeatherNewsItem.h"

#import "SRDataManager.h"
#import "NSDate+Utilities.h"


@implementation SRWeatherForecastItem

@dynamic clouds;
@dynamic date;
@dynamic humidity;
@dynamic pressure;
@dynamic temperatureMax;
@dynamic temperatureMin;
@dynamic weatherDescription;
@dynamic wind;
@dynamic weatherNewsItem;
@dynamic icon;

@end

@implementation SRWeatherForecastItem (RequestResultParser)

-(void) updateToRequestResult:(NSDictionary *)requestResult
{
    // date setup
    NSNumber* dt = requestResult[@"dt"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:dt.doubleValue];
    self.date = date;
    
    // clouds setup
    NSNumber* clouds = requestResult[@"clouds"];
    self.clouds = [clouds description];
    
    // wind setup
    NSNumber* wind = requestResult[@"speed"];
    self.wind = [wind description];
    
    // humidity setup
    NSNumber* humidity = requestResult[@"humidity"];
    self.humidity = [humidity description];
    
    // pressure setup
    NSNumber* pressure = requestResult[@"pressure"];
    self.pressure = [pressure description];
    
    // temperature setup
    NSDictionary* temperature = requestResult[@"temp"];
    NSNumber* celvinMaxTemperature = temperature[@"max"];
    NSNumber* celvinMinTemperature = temperature[@"min"];
        
    self.temperatureMax = [celvinMaxTemperature description];
    self.temperatureMin = [celvinMinTemperature description];
    
    
    // description setup
    NSArray* weather = requestResult[@"weather"];
    NSDictionary* weatherItem = [weather firstObject];
    
    self.weatherDescription = weatherItem[@"description"];
    
    // iconID setup
    NSString* iconID = weatherItem[@"icon"];
    if(![self.icon.iconID isEqualToString:iconID])
    {
        self.icon = [[SRDataManager sharedManager]
                                    getIconByIconIDIfNotFoundCreateNew:iconID];
    }
    else
    {
        // if equal is true, maybe icon is cashed
    }
    
    [[SRDataManager sharedManager] saveContext];
}

@end

