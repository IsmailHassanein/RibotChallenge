//
//  RibotChallengeTests.m
//  RibotChallengeTests
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RBTRibot.h"

@interface RibotChallengeTests : XCTestCase

@end

@implementation RibotChallengeTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRibotMerge
{
    RBTRibot *ribotOne = [[RBTRibot alloc] initWithDictionary:@{@"firstName": @"nameOne"}];
    RBTRibot *ribotTwo = [[RBTRibot alloc] initWithDictionary:@{@"firstName": @"nameTwo", @"lastName": @"lastTwo"}];
    
    [ribotOne mergeSelfWithRibot:ribotTwo];
    XCTAssertTrue([ribotOne.firstName isEqualToString:@"nameOne"], @"Existing properties overwritten");
    XCTAssertTrue([ribotOne.lastName isEqualToString:@"lastTwo"], @"New properties not added");
}

@end
