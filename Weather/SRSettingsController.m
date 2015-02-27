//
//  SRSettingsController.m
//  Weather
//
//  Created by Macbook on 27.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import "SRSettingsController.h"
#import "SRSettingsManager.h"

@implementation SRSettingsController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    self.measurementsScaleSegmentControl.selectedSegmentIndex = [[SRSettingsManager sharedManager] measurementScale];
    self.daysOfWeatherForecastSegmentControl.selectedSegmentIndex =
                                              [self indexForDaysOfWeatherForecastSegmentedControl];

}

#pragma mark - Actions
- (IBAction)measurementsScaleChanged:(UISegmentedControl *)sender
{
    [[SRSettingsManager sharedManager] saveMeasurementScale:sender.selectedSegmentIndex];
}

- (IBAction)daysOfWeatherForecastChanged:(UISegmentedControl *)sender
{
    NSString* daysOfWeatherForecastStr = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    [[SRSettingsManager sharedManager] saveDaysOfWeatherForecast:@(daysOfWeatherForecastStr.integerValue)];
}

#pragma supported methods

-(NSInteger) indexForDaysOfWeatherForecastSegmentedControl
{
    NSString* savedTitle = [[SRSettingsManager sharedManager] daysOfWeatherForecast].description;
    for (NSInteger index = 0; index < self.daysOfWeatherForecastSegmentControl.numberOfSegments; index++)
    {
        NSString* currentTitle = [self.daysOfWeatherForecastSegmentControl titleForSegmentAtIndex:index];
        if ([savedTitle isEqualToString:currentTitle])
        {
            return index;
        }
    }
    
    return 1;
}

@end
