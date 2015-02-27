//
//  SRSettingsController.h
//  Weather
//
//  Created by Macbook on 27.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRSettingsController : UITableViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *measurementsScaleSegmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *daysOfWeatherForecastSegmentControl;

- (IBAction)measurementsScaleChanged:(UISegmentedControl *)sender;
- (IBAction)daysOfWeatherForecastChanged:(UISegmentedControl *)sender;

@end
