//
//  RBTRibot.m
//  RibotChallenge
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import "RBTRibot.h"
#import "RBTServiceCoordinator.h"
#import <objc/runtime.h>

@implementation RBTRibot
@synthesize firstName, lastName, nickname, identifier, role, hexColor, url, details, email, favSeason, favSweet, location, twitter, completeRibot;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if(self)
    {
        completeRibot = NO;
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

-(void)getAllInfo:(void (^)())completion
{
    RBTServiceCoordinator *sharedCoordinator = [RBTServiceCoordinator sharedCoordinator];
    [sharedCoordinator getMember:identifier
               completionHandler:^(RBTRibot *response, NSError *error) {
                   if(error)
                   {
                       NSLog(@"%@", [error localizedDescription]);
                       
                   } else {
                       [self mergeSelfWithRibot:response];
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          completion();
                                      });
                   }
               }];
}

-(void)getRibotar:(void (^)(UIImage *ribotar))completion
{
    RBTServiceCoordinator *sharedCoordinator = [RBTServiceCoordinator sharedCoordinator];
    [sharedCoordinator getRibotar:identifier
                completionHandler:^(UIImage *response, NSError *error) {
                    
                    if (error || !response)
                    {
                        UIImage *placeholder = [UIImage imageNamed:@"ribotPlaceholder"];//I was looking on your website for a good logo to use as placeholder and found this, I feel it fits
                        dispatch_async(dispatch_get_main_queue(),
                                       ^{
                                           completion(placeholder);
                                       });
                    } else {
                        dispatch_async(dispatch_get_main_queue(),
                                       ^{
                                           completion(response);
                                       });
                    }
                }];
}

-(void)mergeSelfWithRibot:(RBTRibot *)ribot
{
    //We're going to fill in the blanks with the new data, any property that is currently empty will be set if the new ribot contains a value for that property
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *key = [[NSString alloc] initWithUTF8String:property_getName(property)];
        if (![key isEqualToString:@"completeRibot"])
        {
            if ([[self valueForKey:key] isEqualToString:@""] || ![self valueForKey:key])
            {
                if ([[ribot valueForKey:key] isEqualToString:@""] || ![ribot valueForKey:key])
                {
                    if ([key isEqualToString:@"role"])
                    {
                        [self setValue:@"Probably a spy"
                                forKey:key];
                    } else if (![key isEqualToString:@"hexColor"] && ![key isEqualToString:@"nickname"] && ![key isEqualToString:@"identifier"])
                    {
                        if ([key isEqualToString:@"favSweet"])
                        {
                            [self setValue:@"a mystery"
                                    forKey:key];
                        }
                        [self setValue:@"It's a mystery"
                                forKey:key];
                    }
                } else {
                    [self setValue:[ribot valueForKey:key]
                            forKey:key];
                }
            }
        }
    }
    free(propertyArray);
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; FirstName = %@; LastName = %@; Nickname = %@; Location = %@; id = %@;  Role = %@; Twitter = %@; HexColour = %@; Email = %@; FavSweet = %@; FavSeason = %@;>", [self class], self, firstName, lastName, nickname, location, identifier, role, twitter, hexColor, email, favSweet, favSeason];
}

@end
