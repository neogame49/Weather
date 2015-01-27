//
//  SRServerManager.m
//  Wather
//
//  Created by Macbook on 15.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import "SRServerManager.h"
#import <AFNetworking.h>

#import "SRWeatherNewsItem.h"

@interface SRServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;

@end

@implementation SRServerManager

+ (SRServerManager*) sharedManager
{
    static SRServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SRServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/"];
        
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}



- (void) getWeatherForecastByCityName:(NSString*) cityName numberOfDays:(NSInteger) numberOfDays
                           onSuccess:(successBlock) success
                           onFailure:(failureBlock) failure
{

     NSDictionary* params = @{@"q" : cityName,
                              @"cnt" : @(numberOfDays)};
    
    [self.requestOperationManager GET:@"forecast/daily" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         SRWeatherNewsItem* weatherNewsItem = nil;
        
            weatherNewsItem = [SRWeatherNewsItem getWeatherNewsItemWithRequestResult:responseObject andLocation:cityName];
        
        if (success)
        {
            success(weatherNewsItem);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@", error);
        
        if (failure)
        {
            failure(error,1000);
        }
    }];
    
}

- (void) getWeatherForecastByLatityde:(double) latitude andLongtitude:(double) longtitude
                       andDescription:(NSString*) description numberOfDays:(NSInteger) numberOfDays
                            onSuccess:(successBlock) success
                            onFailure:(failureBlock) failure
{
    NSDictionary* params = @{@"lat" : @(latitude),
                             @"lon" : @(longtitude),
                             @"cnt" : @(numberOfDays)};
    
    [self.requestOperationManager GET:@"forecast/daily" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         SRWeatherNewsItem* weatherNewsItem = nil;
        
            weatherNewsItem = [SRWeatherNewsItem getWeatherNewsItemWithRequestResult:responseObject andLocation:description];
        
        if (success)
        {
            success(weatherNewsItem);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@", error);
        
        if (failure)
        {
            failure(error,1000);
        }
    }];

}

@end
