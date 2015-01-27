//
//  SRSettingManager.h
//  Weather
//
//  Created by Macbook on 20.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRSettingManager : NSObject

+(SRSettingManager*) sharedManager;

-(void) saveLocation:(NSString*) location;
-(NSString*) loadLocation;

@end
