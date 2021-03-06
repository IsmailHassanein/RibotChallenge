//
//  RBTRibot.h
//  RibotChallenge
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBTRibot : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *hexColor;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *favSeason;
@property (nonatomic, strong) NSString *favSweet;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *twitter;
@property (nonatomic, assign, getter = isCompleteRibot) BOOL completeRibot;//Indicates if this member's details have been fetched individually (inidvidual fetch gets more data for a ribot than team fetch)

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(void)getAllInfo:(void(^) ())completion;

-(void)getRibotar:(void(^) (UIImage *))completion;

-(void)mergeSelfWithRibot:(RBTRibot *)ribot;

@end
