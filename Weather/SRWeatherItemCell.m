//
//  SRWeatherItemCell.m
//  Weather
//
//  Created by Macbook on 18.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import "SRWeatherItemCell.h"

@implementation SRWeatherItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat) height
{
    return 140.0f;
}


@end
