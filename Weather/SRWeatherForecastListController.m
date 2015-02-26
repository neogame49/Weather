//
//  SRWeatherForecastListController.m
//  Weather
//
//  Created by Macbook on 18.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import "SRWeatherForecastListController.h"

#import "SRDataManager.h"
#import "SRServerManager.h"
#import "SRWeatherNewsItem.h"
#import "SRWeatherForecastItem.h"
#import "SRIcon.h"
#import "NSDate+Utilities.h"

#import "SRWeatherItemCell.h"

#import <UIImageView+AFNetworking.h>
#import <MapKit/MapKit.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define NUMBER_OF_DAYS_FOR_WEATHER_FORECAST 7

#define USER_LOCATION_STR @"My location"


@interface SRWeatherForecastListController () <NSFetchedResultsControllerDelegate ,CLLocationManagerDelegate>

@property(strong, nonatomic) successBlock success;
@property(strong, nonatomic) failureBlock failure;

@property(strong, nonatomic) UIRefreshControl* refreshControl;

@property(strong, nonatomic) SRWeatherNewsItem* weatherNewsItem;

@property(strong, nonatomic) NSFetchedResultsController* fetchedResultsController;

@property(strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation SRWeatherForecastListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // blocks implementation
    __weak SRWeatherForecastListController* weakSelf = self;

    self.success = ^(SRWeatherNewsItem *watherItem)
    {
        weakSelf.weatherNewsItem = watherItem;
        
        [weakSelf updateUIElements];
    };
    
    self.failure = ^(NSError *error, NSInteger statusCode)
    {
        NSLog(@"error");
        
        [weakSelf stopRefreshAnimations];
        
        NSString* errorMessage = @"failed to load data. Check the internet connection.";
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    };

    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    
    
    if(self.location)
    {
        // get cached data if it was ceched
        SRWeatherNewsItem* tempWeatherNewsItem = [[SRDataManager sharedManager] getWeatherNewsItemByLocationIfNotFoundCreateNew:self.location];
        
        if (tempWeatherNewsItem)
        {
            self.weatherNewsItem = tempWeatherNewsItem;
            
            [self updateUIElements];
        }
        
        // updete data
        [self reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopRefreshAnimations];
    
    //  save images
    [[SRDataManager sharedManager] saveContext];
}

-(void) setWeatherNewsItem:(SRWeatherNewsItem *)weatherNewsItem
{
    if (![_weatherNewsItem isEqual:weatherNewsItem])
    {
        _weatherNewsItem = weatherNewsItem;
        //self.fetchedResultsController
    }
}


-(CLLocationManager*) locationManager
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    
    return _locationManager;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSInteger numberOfRows = [sectionInfo numberOfObjects];
    
    if (numberOfRows > 0)
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.backgroundView = nil;
    }
    else // non data. display massage
    {
        UILabel* massageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,
                                    CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        
        massageLabel.text = @"No data is currently available. Try pull down to refresh.";
        massageLabel.textAlignment = NSTextAlignmentCenter;
        massageLabel.font = [UIFont systemFontOfSize:20.f];
        massageLabel.numberOfLines = 0;
        [massageLabel sizeToFit];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        tableView.backgroundView = massageLabel;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"WeatherItemCell";
    
    SRWeatherItemCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [self configCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SRWeatherItemCell height];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:
                                   NSStringFromClass([SRWeatherForecastItem class]) inManagedObjectContext:
                                   [SRDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];

    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // predicate setup
    NSDate* beginingOfToday = [[NSDate date] beginingOfDay];
    fetchRequest.predicate =
    [NSPredicate predicateWithFormat:@"weatherNewsItem = %@ and date >= %@",
                                                    self.weatherNewsItem, beginingOfToday];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:
        [SRDataManager sharedManager].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}



- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configCell:(SRWeatherItemCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *) manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* currentUserLocation = [locations lastObject];
    
    // location was updated, send request
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[SRServerManager sharedManager] getWeatherForecastByLatityde:currentUserLocation.coordinate.latitude andLongtitude:currentUserLocation.coordinate.longitude andDescription:USER_LOCATION_STR numberOfDays:NUMBER_OF_DAYS_FOR_WEATHER_FORECAST onSuccess:self.success onFailure:self.failure ];
    });
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"location updating error = %@", error);
    
    
    [manager stopUpdatingLocation];
    [self stopRefreshAnimations];
    
    NSString* errorMessage = nil;
    
    if(error.code == 1) // user banned access to location
    {
        errorMessage = @"Dear user, you are banned from the program access to your location. If you" "change your mind, go to settings and allow access to your location.";
    }
    else // failed load location
    {
        errorMessage =@"failed to load location. Check the internet connection.";
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}


#pragma mark - supported methods
-(void) configCell:(SRWeatherItemCell*) cell atIndexPath:(NSIndexPath*) indexPath
{
    //SRWeatherForecastItem* weatherForecastItem = self.weatherForecast[indexPath.row];
    SRWeatherForecastItem* weatherForecastItem =
    [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.descriptionLabel.text = weatherForecastItem.weatherDescription;
    
    // temperature setup add celsius sumbol
    cell.temperatureMaxLabel.text =
                      [weatherForecastItem.temperatureMax stringByAppendingString:@"\u00B0C"];
    cell.temperatureMinLabel.text =
                      [weatherForecastItem.temperatureMin stringByAppendingString:@"\u00B0C"];
    
    //  further stuff setup
    cell.cloudsLabel.text = [weatherForecastItem.clouds stringByAppendingString:@"%"];
    cell.windLabel.text = [weatherForecastItem.wind stringByAppendingString:@" mps"];
    cell.humidityLabel.text = [weatherForecastItem.humidity stringByAppendingString:@"%"];
    
    // coverted from hPa to KhPa
    double convertedPressureValue = weatherForecastItem.pressure.doubleValue / 1000;
    NSString* convertedPressureStr = [NSString stringWithFormat:@"%.2g", convertedPressureValue];
    cell.pressureLabel.text = [convertedPressureStr stringByAppendingString:@" KhPa"];
    
    // day setup
    cell.dayLabel.text = [self formatedDayStringFromDate:weatherForecastItem.date];
    
    // icon setup
    // if icon was cached show them
    if (weatherForecastItem.icon.image)
    {
        cell.iconImageView.image = weatherForecastItem.icon.image;
    }
    else // download and cache icon
    {
        NSString* imageURLStr = [self ImageURLStringFromImageID:weatherForecastItem.icon.iconID];
        NSURL* imageURL = [NSURL URLWithString:imageURLStr];
        NSURLRequest* imageURLRequest = [NSURLRequest requestWithURL:imageURL];
        
        [cell.iconImageView setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            cell.iconImageView.image = image;
            weatherForecastItem.icon.image = image;
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"image download error = %@", error);
        }];
    }
   
}

-(NSString*) ImageURLStringFromImageID:(NSString*) imageID
{
    NSString* baseImageURLString = @"http://openweathermap.org/img/w/";
    
    // added imageID and extension .png
    return [[baseImageURLString stringByAppendingString:imageID] stringByAppendingString:@".png"];
}

-(NSString*) formatedDayStringFromDate:(NSDate*) date
{
    if ([date isToday])
    {
        return @"Today";
    }
    else if ([date isTomorrow])
    {
        return @"Tomorrow";
    }
    else
    {
        NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"EEEE"];
        
        return [dateFormater stringFromDate:date];
    }
}

-(NSString*) lastUpdateStringFromDate:(NSDate*) date
{
    NSDate* now = [NSDate date];
    
    NSInteger hoursAfterUpdate = [now hoursAfterDate:date];
    
    NSString* resultString = @"Last update: ";
    
    if (hoursAfterUpdate < 1) // time interval between 1 and 59 minutes
    {
        NSInteger minutesAfterUpdate = [date minutesAfterDate:date];
        
        if (minutesAfterUpdate < 3)
        {
            resultString = [resultString stringByAppendingString:@"now"];
        }
        else
        {
            resultString = [NSString stringWithFormat:@"%@%ld minutes ago",resultString, (long)minutesAfterUpdate];
        }
    }
    else if(hoursAfterUpdate > 24)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        
        resultString = [resultString stringByAppendingString:[formatter stringFromDate:date]];
    }
    else // time interval between 1 and 24 hours
    {
        resultString = [NSString stringWithFormat:@"%@%ld hours ago",resultString, (long)hoursAfterUpdate];

    }
    
    return resultString;
}

-(IBAction) reloadData
{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    if ([self.location isEqualToString:USER_LOCATION_STR]) // for user location
    {
        if (IS_OS_8_OR_LATER)
        {
            [self.locationManager requestAlwaysAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    }
    else if(self.location) // for all cities
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[SRServerManager sharedManager] getWeatherForecastByCityName:self.location numberOfDays:NUMBER_OF_DAYS_FOR_WEATHER_FORECAST onSuccess:self.success onFailure:self.failure];
        });
        
    }
    
    
    
}

-(void) updateUIElements
{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (self.weatherNewsItem.city)
    {
        self.title = self.weatherNewsItem.city;
    }
    else
    {
        self.title = self.weatherNewsItem.location;
    }
    
    // update title on refreshControl
    if (self.weatherNewsItem.date) // if have date to last update
    {
        NSString* lastUpdateStr = [self lastUpdateStringFromDate:self.weatherNewsItem.date];
        NSDictionary* attributedDictionary = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        NSAttributedString* attributedLastUpdateStr =
        [[NSAttributedString alloc] initWithString:lastUpdateStr attributes:attributedDictionary];
        
        self.refreshControl.attributedTitle = attributedLastUpdateStr;
    }
   
    
    [self stopRefreshAnimations];
    
    
    [self.tableView reloadData];
}

-(void) stopRefreshAnimations
{
    if ([self.refreshControl isRefreshing])
    {
        [self.refreshControl endRefreshing];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end

 
