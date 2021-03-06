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
#import "UIImage+Tiling.h"

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

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [collectionView registerClass:[RBTRibotCell class]
       forCellWithReuseIdentifier:@"RibotCell"];
    [collectionView registerNib:[UINib nibWithNibName:@"RBTRibotCell"
                                               bundle:[NSBundle mainBundle]]
     forCellWithReuseIdentifier:@"RibotCell"];
    [self setTitle:@"The Ribots"];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"Wallpaper"];
    collectionView.backgroundView = [[UIImageView alloc] initWithImage:[backgroundImage imageResizingModeTile]];
    
    RBTServiceCoordinator *sharedCoordinator = [RBTServiceCoordinator sharedCoordinator];
    [sharedCoordinator getTeam:^(NSArray *response, NSError *error) {
        if(error)
        {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            allRibots = response;
            
            [collectionView performSelectorOnMainThread:@selector(reloadData)
                                             withObject:nil
                                          waitUntilDone:NO];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RBTMemberDetailViewController *destination = [segue destinationViewController];
    
    NSUInteger index = ((NSIndexPath *)[[collectionView indexPathsForSelectedItems] lastObject]).row;
    RBTRibot *tempRibot = [allRibots objectAtIndex:index];
    [destination setUpFromRibot:tempRibot];
}

#pragma mark - Collection View Delegate/Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [allRibots count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RBTRibotCell *cell = ((RBTRibotCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"RibotCell"
                                                                                         forIndexPath:indexPath]);
    
    RBTRibot *tempRibot = [allRibots objectAtIndex:indexPath.row];
    [cell setUpFromRibot:tempRibot];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(230,
                      230);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
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
