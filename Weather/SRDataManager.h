//
//  SRDataManager.h
//  Weather
//
//  Created by Macbook on 16.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SRWeatherNewsItem;
@class SRWeatherForecastItem;
@class SRIcon;

@interface SRDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (SRDataManager*) sharedManager;

-(SRWeatherNewsItem*) getWeatherNewsItemByLocationIfNotFoundCreateNew:(NSString*) location;
// if not found return nil
-(SRWeatherNewsItem*) getWeatherNewsItemByLocation:(NSString*) location;

-(SRIcon*) getIconByIconIDIfNotFoundCreateNew:(NSString*) iconID;
// if not found return nil
-(SRIcon*) getIconByIconID:(NSString*) iconID;

-(SRWeatherForecastItem*) newWeatherForecastItem;
-(void) deleteObjects:(NSArray*) objects;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
