//
//  RBTTweetCell.h
//  RibotChallenge
//
//  Created by Patrick Rocliffe on 15/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RBTTweet;
@interface RBTTweetCell : UITableViewCell

-(void)setUpFromTweet:(RBTTweet *)tweet;
    
@end
