//
//  RBTRibotCell.m
//  RibotChallenge
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import "RBTRibotCell.h"
#import "RBTRibot.h"

@implementation RBTRibotCell
@synthesize ribot;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setRibot:(RBTRibot *)_ribot
{
    self.ribot = _ribot;
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
