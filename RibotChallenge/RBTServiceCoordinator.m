//
//  RBTServiceCoordinator.m
//  RibotChallenge
//
//  Created by IsHass on 14/08/2014.
//  Copyright (c) 2014 IsHass. All rights reserved.
//

#import "RBTServiceCoordinator.h"
#import "RBTRibot.h"
#import "RBTStudio.h"

static RBTServiceCoordinator *sharedCoordinator = nil;
static NSString *basicURLString = @"http://devchallenge.ribot.io/api";

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

#pragma Generic fetch

- (void)downloadDataWithURLString:(NSString *)urlString
            completionHandler:(void (^)(NSData *, NSError *))completionHandler {
    NSParameterAssert(urlString);
    NSParameterAssert(completionHandler);
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: _queue
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         completionHandler(data,connectionError);
     }];
}

- (void)downloadJSONWithURLString:(NSString *)urlString
            completionHandler:(void (^)(NSDictionary *, NSError *))completionHandler {
    [self downloadDataWithURLString:urlString
                  completionHandler:^(NSData *data, NSError *connectionError) {
    if (connectionError)//if an error has occured during connection
    {
        //dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(nil,connectionError);
        //});
    } else {
        NSError *serializeError;
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions
                                                                  error:&serializeError];
        if(serializeError)
        {
            completionHandler(nil,serializeError);
        } else {
            completionHandler(results,nil);
        }
    }
                  }];
};

#pragma Specific fetches

- (void)getTeam:(void (^)(NSArray *, NSError *))completionHandler
{
    [self downloadJSONWithURLString:[basicURLString stringByAppendingString:@"/team"]
              completionHandler:^(NSDictionary *results, NSError *error) {

                  NSMutableArray *allRibots = [[NSMutableArray alloc] init];
                  
                  for(NSDictionary *dictionary in results)
                  {
                      NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
                      [mutableDictionary setObject:[dictionary objectForKey:@"id"]
                                        forKey:@"identifier"];
                      [mutableDictionary removeObjectForKey:@"id"];
                      [allRibots addObject:[[RBTRibot alloc] initWithDictionary:mutableDictionary]];
                  }
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      completionHandler(allRibots, error);
                  });
              }];
}

-(void)getMember:(NSString *)memberID completionHandler:(void (^)(RBTRibot *, NSError *))completionHandler
{
    [self downloadJSONWithURLString:[basicURLString stringByAppendingString:[NSString stringWithFormat:@"/team/%@", memberID]]
              completionHandler:^(NSDictionary *results, NSError *error) {
                  
                  RBTRibot *resultRibot;
                  
                  if(results)
                  {
                     NSMutableDictionary *mutableResult = [results mutableCopy];
                      [mutableResult setObject:[results objectForKey:@"id"]
                                        forKey:@"identifier"];
                      [mutableResult removeObjectForKey:@"id"];
                     resultRibot = [[RBTRibot alloc] initWithDictionary:mutableResult];
                  }
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                  completionHandler(resultRibot, error);
                  });
              }];
}

-(void)getRibotar:(NSString *)memberID completionHandler:(void (^)(UIImage *, NSError *))completionHandler
{
    [self downloadDataWithURLString:[basicURLString stringByAppendingString:[NSString stringWithFormat:@"/team/%@/ribotar", memberID]]
              completionHandler:^(NSData *data, NSError *error) {
                  
                  if(error)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          completionHandler(nil, error);
                      });
                  } else {
                  NSError *serializeError;
                  NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                            error:&serializeError];
#warning TODO: NEEDS TO BE MORE ROBUST
                  if(serializeError)//If it wasn't JSON, it should be our image
                  {
                      UIImage *resultRibotar = [UIImage imageWithData:data];
                      dispatch_async(dispatch_get_main_queue(), ^{
                          completionHandler(resultRibotar, nil);
                      });
                  } else {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          completionHandler(nil, error);
                      });
                  }
                  }
              }];
}

-(void)getStudio:(void (^)(RBTStudio *, NSError *))completionHandler
{
    [self downloadJSONWithURLString:[basicURLString stringByAppendingString:@"/studio"]
              completionHandler:^(NSDictionary *results, NSError *error) {
                  //PARSE
                  RBTStudio *resultStudio = [[RBTStudio alloc] initWithDictionary:results];
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      completionHandler(resultStudio, error);
                  });
              }];
}

@end
