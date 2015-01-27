//
//  SRWeatherForecastItem.h
//  Weather
//
//  Created by Macbook on 19.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SRIcon, SRWeatherNewsItem;

@interface SRWeatherForecastItem : NSManagedObject

@property (nonatomic, retain) NSString * clouds;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * humidity;
@property (nonatomic, retain) NSString * pressure;
@property (nonatomic, retain) NSString * temperatureMax;
@property (nonatomic, retain) NSString * temperatureMin;
@property (nonatomic, retain) NSString * weatherDescription;
@property (nonatomic, retain) NSString * wind;
@property (nonatomic, retain) SRWeatherNewsItem *weatherNewsItem;
@property (nonatomic, retain) SRIcon *icon;

@end

@interface SRWeatherForecastItem (RequestResultParser)

-(void) updateToRequestResult:(NSDictionary*) requestResult;

@end



