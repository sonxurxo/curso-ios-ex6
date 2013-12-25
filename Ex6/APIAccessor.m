//
//  APIAccessor.m
//  Ex6
//
//  Created by Xurxo Méndez Pérez on 25/12/13.
//  Copyright (c) 2013 SmartGalApps. All rights reserved.
//

#import "APIAccessor.h"

#import "User.h"

@implementation APIAccessor

static APIAccessor *sharedInstance = nil;

+ (APIAccessor *)sharedInstance {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[APIAccessor alloc] init];
        sharedInstance.manager = [AFHTTPRequestOperationManager manager];
    });
    
    return sharedInstance;
}


- (void)getAllUsersWithDelegate:(id)delegate
{
    SEL succededSelector = NSSelectorFromString(@"getAllUsersSucceded:");
    SEL failedSelector = NSSelectorFromString(@"getAllUsersFailed:");
    
    NSString* url = [NSString stringWithFormat:@"%@/%s", API_URL, API_GET_USERS];
    
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self isException:responseObject])
        {
            NSLog(@"Exception: %@", @"There was an exception");
            NSDictionary* errorDictionary = @{@"error" : [self parseException:responseObject]};
            
            if ([delegate respondsToSelector:failedSelector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [delegate performSelector:failedSelector withObject:errorDictionary];
#pragma clang diagnostic pop
            }
        }
        else
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            [delegate performSelector:succededSelector withObject:[self parseUsers:responseObject]];
#pragma clang diagnostic pop
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSDictionary* errorDictionary = @{@"error" : error};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [delegate performSelector:failedSelector withObject:errorDictionary];
#pragma clang diagnostic pop
    }];
}

- (void)getUserWithId:(NSNumber*)userId delegate:(id)delegate
{
    SEL succededSelector = NSSelectorFromString(@"getUserSucceded:");
    SEL failedSelector = NSSelectorFromString(@"getUserFailed:");
    
    NSString* url = [NSString stringWithFormat:@"%@/%s", API_URL, API_GET_USER];
    
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self isException:responseObject])
        {
            NSLog(@"Exception: %@", @"There was an exception");
            NSDictionary* errorDictionary = @{@"error" : [self parseException:responseObject]};
            
            if ([delegate respondsToSelector:failedSelector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [delegate performSelector:failedSelector withObject:errorDictionary];
#pragma clang diagnostic pop
            }
        }
        else
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            [delegate performSelector:succededSelector withObject:[self parseUser:responseObject]];
#pragma clang diagnostic pop
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSDictionary* errorDictionary = @{@"error" : error};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [delegate performSelector:failedSelector withObject:errorDictionary];
#pragma clang diagnostic pop
    }];
}

- (NSArray*)parseUsers:(id)responseObject
{
    NSArray* users = (NSArray*)responseObject;
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:users.count];
    for (NSDictionary* user in users)
    {
        [result addObject:[self parseUser:user]];
    }
    return result;
}

- (User*)parseUser:(id)responseObject
{
    NSDictionary* user = (NSDictionary*)responseObject;
    User* result = [[User alloc] init];
    
    result.name = [user objectForKey:@"name"];
    result.surname = [user objectForKey:@"surname"];
    result.id = [user objectForKey:@"id"];
    
    return result;
}

- (BOOL)isException:(id) responseObject
{
    NSDictionary* result = responseObject;
    return [result respondsToSelector:NSSelectorFromString(@"objectForKey:")] && [result objectForKey:@"exception"] != nil;
}

- (NSError*)parseException:(id)responseObject
{
    NSDictionary* exceptionDictionary = [((NSDictionary*)responseObject) objectForKey:@"exception"];
    NSUInteger exceptionCode = [[[exceptionDictionary keyEnumerator] nextObject] intValue];
    return [NSError errorWithDomain:@"API" code:exceptionCode userInfo:nil];
}

@end
