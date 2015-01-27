//
//  SRWeatherItemCell.h
//  Weather
//
//  Created by Macbook on 18.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRWeatherItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudsLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

+(CGFloat) height;

@end

