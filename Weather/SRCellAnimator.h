//
//  SRCellAnimator.h
//  Weather
//
//  Created by Macbook on 27.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UITableViewCell;

@interface SRCellAnimator : NSObject

+(void) appearAnimationForCell:(UITableViewCell*) cell duration:(double) duration;

@end
