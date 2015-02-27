//
//  SRCellAnimator.m
//  Weather
//
//  Created by Macbook on 27.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import "SRCellAnimator.h"
#import <UIKit/UIKit.h>

@implementation SRCellAnimator

+(void) appearAnimationForCell:(UITableViewCell*) cell duration:(double) duration
{
    UIView* contentView = cell.contentView;
    
    contentView.layer.opacity = 0.1;
    
    [UIView animateWithDuration:duration animations:^{
        contentView.layer.opacity = 1.0;

    }];
}

@end
