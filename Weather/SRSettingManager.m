//
//  SRSettingManager.m
//  Weather
//
//  Created by Macbook on 20.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import "SRSettingManager.h"

@implementation SRSettingManager

+(SRSettingManager*) sharedManager
{
    static SRSettingManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SRSettingManager alloc] init];
    });
    
    return manager;
}

-(void) saveLocation:(NSString*) location
{
    [[NSUserDefaults standardUserDefaults] setObject:location forKey:[self locationKey]];
}
-(NSString*) loadLocation
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self locationKey]];
}

-(NSString*) locationKey
{
    return @"locationKey";
}
@end
