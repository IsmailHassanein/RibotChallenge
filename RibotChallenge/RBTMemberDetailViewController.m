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

@interface RBTMemberDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ribotarView;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *favSweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favSeasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

@end

@implementation RBTMemberDetailViewController
@synthesize ribot, ribotarView, roleLabel, favSeasonLabel, favSweetLabel, twitterLabel, descriptionText;

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
    }];
    [ribot getRibotar:^(UIImage *ribotar) {
        [ribotarView setImage:ribotar];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
