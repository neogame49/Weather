//
//  SRLactionsListController.m
//  Weather
//
//  Created by Macbook on 15.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import "SRLoctionsListController.h"
#import "SRWeatherForecastListController.h"

#import "SRSettingManager.h"

#define INDEX_FOR_MY_LOCATION 24


@interface SRLoctionsListController () 



@property(strong, nonatomic) NSArray* locations;
@end

@implementation SRLoctionsListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load locations from file
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"plist"];
    self.locations = [NSArray arrayWithContentsOfFile:filePath];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // user back to list. Non current location
    [[SRSettingManager sharedManager] saveLocation:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = self.locations[indexPath.row];
    
    if (indexPath.row == INDEX_FOR_MY_LOCATION)
    {
        cell.imageView.image = [UIImage imageNamed:@"location icon.png"];
    }
    
    return cell;
}




#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"WeatherForecastList"])
    {
        SRWeatherForecastListController* desstinationController =
        (SRWeatherForecastListController*)segue.destinationViewController;
        
        NSIndexPath* selectedCellIndexPath = [self.tableView indexPathForSelectedRow];
        
        NSString* location = self.locations[selectedCellIndexPath.row];

        
        desstinationController.location = location;
        
        // save user location direction
        [[SRSettingManager sharedManager] saveLocation:location];
    }
}




@end
