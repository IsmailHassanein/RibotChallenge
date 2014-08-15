//
//  UIColor+Tint.m
//  RibotChallenge
//
//  Created by IsHass on 15/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import "UIColor+Tint.h"

@implementation UIColor (Tint)

+(UIColor *)tintFromColor:(UIColor *)baseColor
{
    CGFloat red, blue, green, alpha;
    if ([baseColor getRed:&red
                    green:&green
                     blue:&blue
                    alpha:&alpha])
    {
        red += (0.25 * (1.0 - red));
        blue += (0.25 * (1.0 - blue));
        green += (0.25 * (1.0 - green));
    }

    return [UIColor colorWithRed:red
                           green:green
                            blue:blue
                           alpha:alpha];
}

@end
