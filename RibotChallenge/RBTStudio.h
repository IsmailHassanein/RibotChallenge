//
//  RBTStudio.h
//  RibotChallenge
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBTStudio : NSObject

@property(nonatomic, strong) NSString *addressNumber;
@property(nonatomic, strong) NSString *street;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *county;
@property(nonatomic, strong) NSString *postcode;
@property(nonatomic, strong) NSString *country;
@property(nonatomic, strong) NSArray *photos;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
