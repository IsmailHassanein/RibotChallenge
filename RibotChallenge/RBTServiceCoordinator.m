//
//  RBTServiceCoordinator.m
//  RibotChallenge
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import "RBTServiceCoordinator.h"

static RBTServiceCoordinator *sharedCoordinator = nil;

@interface RBTServiceCoordinator ()
{
    NSOperationQueue *_queue;
}

@end

@implementation RBTServiceCoordinator

+ (id)sharedCoordinator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCoordinator = [[RBTServiceCoordinator alloc] init];
    });
    return sharedCoordinator;
}

- (id)init {
    self = [super init];
    if(self)
    {
        _queue = [NSOperationQueue new];
    }
    return self;
}

@end
