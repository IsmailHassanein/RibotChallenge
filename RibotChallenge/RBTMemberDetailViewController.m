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
#import "UIColor+Tint.h"
#import "STTwitter.h"
#import "RBTTweet.h"
#import "RBTTweetCell.h"

@interface RBTMemberDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ribotarView;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *favSweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTitleText;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UITableView *twitterFeedTable;
@property (strong, nonatomic) NSMutableArray *twitterFeed;

@end

@implementation RBTMemberDetailViewController
@synthesize ribot, ribotarView, roleLabel, favSweetLabel, emailLabel, descriptionText, twitterFeed, twitterFeedTable, locationLabel, descriptionTitleText;

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
    if (ribot.hexColor && ![ribot.hexColor isEqualToString:@""]) {
        [self.view setBackgroundColor:[UIColor tintFromColor:[UIColor colorWithHexString:ribot.hexColor]]];
        [ribotarView setBackgroundColor:[UIColor colorWithHexString:ribot.hexColor]];
        //[self.view setAlpha:0.8];
    } else {
        [self.view setBackgroundColor:[UIColor tintFromColor:[UIColor lightGrayColor]]];
        [ribotarView setBackgroundColor:[UIColor lightGrayColor]];
    }

    if (ribot.nickname && ![ribot.nickname isEqualToString:@""])
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
        [descriptionText setFont:[UIFont systemFontOfSize:20]];
        [favSweetLabel setText:[NSString stringWithFormat:@"Favourite sweet is %@",ribot.favSweet]];
        [emailLabel setText:[NSString stringWithFormat:@"Contact: %@",ribot.email]];
        [locationLabel setText:[NSString stringWithFormat:@"Lives in %@",ribot.location]];
        [descriptionTitleText setText:[NSString stringWithFormat:@"Who is %@?", ribot.firstName]];
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

- (IBAction)getInTouch:(id)sender
{
    MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
    composer.mailComposeDelegate = self;
    [composer setSubject:@"Hi Ribot!"];
    [composer setToRecipients:@[ribot.email]];
    
    [self presentViewController:composer animated:YES completion:NULL];
}

#pragma mark - MFMailComposeViewControllerDelegate methods
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
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
    [cell setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             tableView.frame.size.width,
                                                              100)];
    if (ribot.hexColor && ![ribot.hexColor isEqualToString:@""])
    {
        [header setBackgroundColor:[UIColor colorWithHexString:ribot.hexColor]];
    } else {
        [header setBackgroundColor:[UIColor lightGrayColor]];
    }
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    tableView.frame.size.width,
                                                                    20)];
    [titleLabel setText:ribot.twitter];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:25]];
    
    UIImage *seasonImage = [UIImage imageNamed:ribot.favSeason];
    UIImageView *leftSeasonImage = [[UIImageView alloc] initWithFrame:CGRectMake(20,
                                                                                 30,
                                                                                 40,
                                                                                 40)];
    [leftSeasonImage setImage:seasonImage];
    [leftSeasonImage setContentMode:UIViewContentModeScaleAspectFit];
    UIImageView *rightSeasonImage = [[UIImageView alloc] initWithFrame:CGRectMake(header.frame.size.width-70,
                                                                                  30,
                                                                                  40,
                                                                                  40)];
    [rightSeasonImage setImage:seasonImage];
    [rightSeasonImage setContentMode:UIViewContentModeScaleAspectFit];
    [header addSubview:titleLabel];
    [titleLabel setCenter:header.center];
    [header addSubview:leftSeasonImage];
    [header addSubview:rightSeasonImage];
    
    return header;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

@end
