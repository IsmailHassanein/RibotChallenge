//
//  RBTStudio.m
//  RibotChallenge
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import "RBTStudio.h"

@implementation RBTStudio
@synthesize addressNumber, postcode, country, county, city, street, photos;

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
    return [NSString stringWithFormat:@"<%@: %p; AddressNumber = %@; Street = %@; City = %@; County = %@; Country = %@;  PostCode = %@;>", [self class], self, addressNumber, street, city, county, country, postcode];
}

@end
