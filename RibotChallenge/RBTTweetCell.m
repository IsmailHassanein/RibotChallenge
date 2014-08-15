//
//  RBTTweetCell.m
//  RibotChallenge
//
//  Created by IsHass on 15/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import "RBTTweetCell.h"
#import "RBTTweet.h"

@interface RBTTweetCell ()
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation RBTTweetCell
@synthesize tweetText, dateLabel;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUpFromTweet:(RBTTweet *)tweet
{
    [dateLabel setText:tweet.created_at];
    [tweetText setText:tweet.text];
    [tweetText setFont:[UIFont systemFontOfSize:15]];
}

@end
