//
//  SRWeatherForecastListController.h
//  Weather
//
//  Created by Macbook on 18.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRWeatherForecastListController : UITableViewController

@property(strong, nonatomic) NSString* location;

-(IBAction) reloadData;

@end
