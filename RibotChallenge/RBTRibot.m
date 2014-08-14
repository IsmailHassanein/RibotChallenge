//
//  RBTRibot.m
//  RibotChallenge
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import "RBTRibot.h"

@implementation RBTRibot
@synthesize firstName, lastName, nickname, identifier, role, hexColor, url, description, email, favSeason, favSweet, location, twitter;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if(self)
    {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; FirstName = %@; LastName = %@; Nickname = %@; Location = %@; id = %@;  Role = %@; Twitter = %@; HexColour = %@; URL = %@; FavSweet = %@; FavSeason = %@;>", [self class], self, firstName, lastName, nickname, location, identifier, role, twitter, hexColor, url, favSweet, favSeason];
}

@end
