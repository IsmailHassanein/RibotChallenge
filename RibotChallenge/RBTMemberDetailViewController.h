//
//  RBTMemberDetailViewController.h
//  RibotChallenge
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class RBTRibot;

@interface RBTMemberDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) RBTRibot *ribot;

-(void)setUpFromRibot:(RBTRibot *)ribot;
@end
