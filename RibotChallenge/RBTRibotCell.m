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
    if (ribot.hexColor && ![ribot.hexColor isEqualToString:@"(null)"])
    {
    [self setBackgroundColor:[UIColor colorWithHexString:ribot.hexColor]];
    }
#warning TODO: set up cell from ribot
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
