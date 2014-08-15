//
//  RBTMemberDetailViewController.m
//  RibotChallenge
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import "RBTMemberDetailViewController.h"
#import "RBTRibot.h"
#import "UIColor+HexString.h"
#import "STTwitter.h"
#import "RBTTweet.h"
#import "RBTTweetCell.h"

@interface RBTMemberDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ribotarView;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *favSweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favSeasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UITableView *twitterFeedTable;
@property (strong, nonatomic) NSMutableArray *twitterFeed;

@end

@implementation RBTMemberDetailViewController
@synthesize ribot, ribotarView, roleLabel, favSeasonLabel, favSweetLabel, twitterLabel, descriptionText, twitterFeed, twitterFeedTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [twitterFeedTable registerClass:[RBTTweetCell class]
             forCellReuseIdentifier:@"tweetCell"];
    [twitterFeedTable registerNib:[UINib nibWithNibName:@"RBTTweetCell"
                                                 bundle:[NSBundle mainBundle]]
           forCellReuseIdentifier:@"tweetCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpFromRibot:(RBTRibot *)newRibot
{
    ribot = newRibot;
#warning TODO: set up view from ribot
    if (ribot.hexColor && ![ribot.hexColor isEqualToString:@"(null)"]) {
        [self.view setBackgroundColor:[UIColor colorWithHexString:ribot.hexColor]];
    }

    if (ribot.nickname && ![ribot.nickname isEqualToString:@"(null)"])
    {
        [self setTitle:[NSString stringWithFormat:@"%@ '%@' %@", ribot.firstName, ribot.nickname, ribot.lastName]];
    } else {
        [self setTitle:[NSString stringWithFormat:@"%@ %@", ribot.firstName, ribot.lastName]];
    }

#warning TODO: needs cancel!!!
    [ribot getAllInfo:^{
#warning TODO: animate

        [roleLabel setText:ribot.role];
        [descriptionText setText:ribot.details];
        [favSweetLabel setText:ribot.favSweet];
        [favSeasonLabel setText:ribot.favSeason];
        [twitterLabel setText:ribot.twitter];
        [self getTwitterFeedForRibot:ribot.twitter];
    }];
    [ribot getRibotar:^(UIImage *ribotar) {
        [ribotarView setImage:ribotar];
    }];
}

- (void)getTwitterFeedForRibot:(NSString *)twitterName
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"lw0xV8VufxjHvhpn0xRzTeeJw"
                                                                consumerSecret:@"i2TQvqhghPpQlHBNqZOgm1frtaYwJgBBAE8YTITE2ZhWCwZVfL"];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        
        NSLog(@"Access granted with %@", bearerToken);
        
        [twitter getUserTimelineWithScreenName:twitterName successBlock:^(NSArray *statuses) {
            //NSLog(@"-- statuses: %@", statuses);
            twitterFeed = [[NSMutableArray alloc] init];
            for (NSDictionary *tempDict in statuses)
            {
                RBTTweet *tweet = [[RBTTweet alloc] init];
                [tweet setText:[tempDict objectForKey:@"text"]];
                [tweet setCreated_at:[tempDict objectForKey:@"created_at"]];
                [twitterFeed addObject:tweet];
                
                [self.twitterFeedTable reloadData];
            }
        } errorBlock:^(NSError *error) {
            NSLog(@"-- error: %@", error);
        }];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"-- error %@", error);
    }];
}

#pragma mark - Table view delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [twitterFeed count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RBTTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    
    RBTTweet *tweet = [twitterFeed objectAtIndex:indexPath.row];
    [cell setUpFromTweet:tweet];
    
    return cell;
}

@end
