//
//  SRImageTransformer.m
//  Weather
//
//  Created by Macbook on 18.01.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

#import "SRImageTransformer.h"
#import <UIKit/UIKit.h>

@implementation SRImageTransformer

+(BOOL) allowsReverseTransformation
{
    return YES;
}

+(Class)transformedValueClass
{
    return [NSData class];
}

- (id)transformedValue:(id)value
{
    if(value)
    {
        UIImage* image = (UIImage*)value;
        
        NSData* dataFromImage = UIImagePNGRepresentation(image);
        
        return dataFromImage;
    }
    else
    {
        return nil;
    }
}
- (id)reverseTransformedValue:(id)value
{
    if(value)
    {
        NSData* imageData = (NSData*)value;
        
        UIImage* image = [UIImage imageWithData:imageData];
        
        return image;
    }
    else
    {
        return nil;
    }
}
@end
