//
//  RBTServiceCoordinator.h
//  RibotChallenge
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBTRibot;
@class RBTStudio;

@interface RBTServiceCoordinator : NSObject

+ (id)sharedCoordinator;

- (void)getTeam:(void(^) (NSArray * response, NSError *error))completionHandler;
- (void)getMember:(NSString *)memberID
completionHandler:(void(^) (RBTRibot * response, NSError *error))completionHandler;
- (void)getRibotar:(NSString *)memberID
 completionHandler:(void(^) (UIImage * response, NSError *error))completionHandler;
- (void)getStudio:(void(^) (RBTStudio * response, NSError *error))completionHandler;

@end
