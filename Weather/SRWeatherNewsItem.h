//
//  SRWeatherNewsItem.h
//  Weather
//
//  Created by Macbook on 19.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SRWeatherForecastItem;

@interface SRWeatherNewsItem : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSSet *weatherForecast;
@end

@interface SRWeatherNewsItem (CoreDataGeneratedAccessors)

- (void)addWeatherForecastObject:(SRWeatherForecastItem *)value;
- (void)removeWeatherForecastObject:(SRWeatherForecastItem *)value;
- (void)addWeatherForecast:(NSSet *)values;
- (void)removeWeatherForecast:(NSSet *)values;

@end

@interface SRWeatherNewsItem (RequestResultParser)

+(SRWeatherNewsItem*) getWeatherNewsItemWithRequestResult:(NSDictionary*) requestResult
                                              andLocation:(NSString*) location;

@end
