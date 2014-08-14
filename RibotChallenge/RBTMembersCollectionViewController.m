//
//  RBTMembersCollectionViewController.m
//  RibotChallenge
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import "RBTMembersCollectionViewController.h"
#import "RBTMemberDetailViewController.h"
#import "RBTServiceCoordinator.h"
#import "RBTRibotCell.h"
#import "RBTRibot.h"
#import "RBTStudio.h"

@interface RBTMembersCollectionViewController ()

@property (nonatomic, strong) NSArray *allRibots;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RBTMembersCollectionViewController
@synthesize allRibots, collectionView;

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
    [collectionView registerClass:[RBTRibotCell class]
       forCellWithReuseIdentifier:@"RibotCell"];
    [collectionView registerNib:[UINib nibWithNibName:@"RBTRibotCell"
                                               bundle:[NSBundle mainBundle]]
     forCellWithReuseIdentifier:@"RibotCell"];
    RBTServiceCoordinator *sharedCoordinator = [RBTServiceCoordinator sharedCoordinator];
    [sharedCoordinator getTeam:^(NSArray *response, NSError *error) {
        if(error)
        {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            allRibots = response;
            NSLog(@"team: %@", response);
        }
    }];
    [sharedCoordinator getMember:@"antony"
completionHandler:^(RBTRibot *response, NSError *error) {
    NSLog(@"Member: %@", response);
}];
    [sharedCoordinator getStudio:^(RBTStudio *response, NSError *error) {
        NSLog(@"studio: %@", response);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     RBTMemberDetailViewController *destination = [segue destinationViewController];
     //////////TO BE INCLUDED ONCE DATA IS LIVE
     /*
      RBTRibot *tempRibot = [allRibots objectAtIndex:indexPath.row];
      [destination setRibot:tempRibot];
      */
 }

#pragma mark - Collection View Delegate/Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return [allRibots count];
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RBTRibotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RibotCell"
                                                                   forIndexPath:indexPath];
//////////TO BE INCLUDED ONCE DATA IS LIVE
    /*
    RBTRibot *tempRibot = [allRibots objectAtIndex:indexPath.row];
    [cell setRibot:tempRibot];
     */
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
#warning TODO
    return CGSizeMake(100,
                      100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
#warning TODO
    return UIEdgeInsetsMake(50,
                            20,
                            50,
                            20);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"pushDetails"
                              sender:self];
}

@end
