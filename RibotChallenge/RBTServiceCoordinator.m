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
                          completionHandler(nil,connectionError);
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
                          //We're going to replace id with identifier for safety's sake
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
                          [mutableResult setObject:[results objectForKey:@"description"]
                                            forKey:@"details"];
                          [mutableResult removeObjectForKey:@"description"];
                          resultRibot = [[RBTRibot alloc] initWithDictionary:mutableResult];
                      }
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          completionHandler(resultRibot, error);
                      });
                  }];
}

-(void)getRibotar:(NSString *)memberID completionHandler:(void (^)(UIImage *, NSError *))completionHandler
{
    NSString *hash = [NSString stringWithFormat: @"%016lx", (unsigned long)[memberID hash]];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: hash];
    
    //If we have this image cached, we can return it, otherwise we will download it
    __block UIImage *resultRibotar = nil;
    NSData *data = [NSData dataWithContentsOfFile: path options: NSDataReadingMappedIfSafe error: NULL];
    if(data && (resultRibotar = [UIImage imageWithData: data])) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(resultRibotar,nil);
        });
        return;
    }
    
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
#pragma unused (results)
                          if(serializeError)//If it wasn't JSON, it should be our image
                          {
                              resultRibotar = [UIImage imageWithData:data];
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
                      RBTStudio *resultStudio = [[RBTStudio alloc] initWithDictionary:results];
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          completionHandler(resultStudio, error);
                      });
                  }];
}

@end
