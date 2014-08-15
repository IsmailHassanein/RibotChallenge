//
//  UIImage+Tiling.m
//  RibotChallenge
//
//  Created by IsHass on 15/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import "UIImage+Tiling.h"

@implementation UIImage (Tiling)

-(UIImage *)imageResizingModeTile
{
    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if( iOSVersion >= 6.0f )
    {
        return [self resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    }
    else
    {
        return [self resizableImageWithCapInsets:UIEdgeInsetsZero];
    }
}

@end
