//
//  SRServerManager.h
//  Wather
//
//  Created by Macbook on 15.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRWeatherNewsItem;

typedef void(^successBlock)(SRWeatherNewsItem* watherItem);
typedef void(^failureBlock)(NSError* error, NSInteger statusCode);


@interface SRServerManager : NSObject

+ (SRServerManager*) sharedManager;


- (void) getWeatherForecastByCityName:(NSString*) cityName numberOfDays:(NSInteger) numberOfDays
                          onSuccess:(successBlock) success
                          onFailure:(failureBlock) failure;

- (void) getWeatherForecastByLatityde:(double) latitude andLongtitude:(double) longtitude
                            andDescription:(NSString*) description numberOfDays:(NSInteger) numberOfDays
                            onSuccess:(successBlock) success
                            onFailure:(failureBlock) failure;
@end
