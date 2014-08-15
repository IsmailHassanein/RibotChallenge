//
//  RBTRibotCell.m
//  RibotChallenge
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import "RBTRibotCell.h"
#import "RBTRibot.h"
#import "UIColor+HexString.h"

@implementation RBTRibotCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setUpFromRibot:(RBTRibot *)ribot
{
    if (ribot.hexColor && ![ribot.hexColor isEqualToString:@""])
    {
        [self setBackgroundColor:[UIColor colorWithHexString:ribot.hexColor]];
    } else {
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
    UILabel *nameLabel = ((UILabel *)[self viewWithTag:101]);
    if (ribot.nickname && ![ribot.nickname isEqualToString:@""])
    {
        [nameLabel setText:ribot.nickname];
    } else {
        [nameLabel setText:ribot.firstName];
    }
    [ribot getRibotar:^(UIImage *ribotar) {
        if (ribotar)
        {
            UIImageView *ribotarView = ((UIImageView *)[self viewWithTag:102]);
            [ribotarView setImage:ribotar];
        }
    }];
}

@end
