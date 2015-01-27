//
//  SRIcon.h
//  Weather
//
//  Created by Macbook on 19.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class SRWeatherForecastItem;

@interface SRIcon : NSManagedObject

@property (nonatomic, retain) NSString * iconID;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) NSSet *owners;
@end

@interface SRIcon (CoreDataGeneratedAccessors)

- (void)addOwnersObject:(SRWeatherForecastItem *)value;
- (void)removeOwnersObject:(SRWeatherForecastItem *)value;
- (void)addOwners:(NSSet *)values;
- (void)removeOwners:(NSSet *)values;

@end
