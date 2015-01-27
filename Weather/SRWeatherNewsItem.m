//
//  SRWeatherNewsItem.m
//  Weather
//
//  Created by Macbook on 19.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import "SRWeatherNewsItem.h"
#import "SRWeatherForecastItem.h"

#import "SRDataManager.h"
#import "SRWeatherForecastItem.h"
#import "SRIcon.h"



@implementation SRWeatherNewsItem

@dynamic city;
@dynamic date;
@dynamic location;
@dynamic weatherForecast;

@end

@implementation SRWeatherNewsItem (RequestResultParser)

+(SRWeatherNewsItem*) getWeatherNewsItemWithRequestResult:(NSDictionary*) requestResult
                                              andLocation:(NSString*) location
{

    SRWeatherNewsItem* weatherNewsItem = [[SRDataManager sharedManager]
                                          getWeatherNewsItemByLocationIfNotFoundCreateNew:location];
    
    NSDictionary* city = requestResult[@"city"];
    
    weatherNewsItem.city = city[@"name"];
    weatherNewsItem.date = [NSDate date];
    
    
    NSArray* listOfWeather = requestResult[@"list"];
    
    [SRWeatherNewsItem setWeatherForecast:listOfWeather forWeatherNewsItem:weatherNewsItem];
    
    [[SRDataManager sharedManager] saveContext];
    
    return weatherNewsItem;
    
    }

+(void) setWeatherForecast:(NSArray*) weatherForecastList
        forWeatherNewsItem:(SRWeatherNewsItem*) weatherNewsItem
{
    NSArray* oldWeatherForecast = [weatherNewsItem.weatherForecast allObjects];
    
    int index = 0;
    
    // update curent weather forecast items
    for( ; index < oldWeatherForecast.count && index < weatherForecastList.count ; index++)
    {
        NSDictionary* weatherForecatListItem = weatherForecastList[index];
        
        SRWeatherForecastItem* weatherForecastItem = oldWeatherForecast[index];
        
        [weatherForecastItem updateToRequestResult:weatherForecatListItem];
        
    }
    
    // if true = we got more items than is now, adding missing items
    if(index  < weatherForecastList.count)
    {
        for(;index < weatherForecastList.count; index++)
        {
            NSDictionary* weatherForecatListItem = weatherForecastList[index];
            
            SRWeatherForecastItem* weatherForecastItem = [[SRDataManager sharedManager] newWeatherForecastItem];
            [weatherForecastItem updateToRequestResult:weatherForecatListItem];
            
            
            [weatherNewsItem addWeatherForecastObject:weatherForecastItem];
            
            
        }
        
        return;
    }
    
    // if true = was to may cached items. Deleting excess items
    if(index  < oldWeatherForecast.count)
    {
        NSArray* itemsForDelete = [oldWeatherForecast subarrayWithRange:
                                   NSMakeRange(index, oldWeatherForecast.count -index)];
        
        NSSet* setOfItemsForDelete = [NSSet setWithArray:itemsForDelete];
        
        [weatherNewsItem removeWeatherForecast:setOfItemsForDelete];
        
        [[SRDataManager sharedManager] deleteObjects:itemsForDelete];
    }
}



@end


