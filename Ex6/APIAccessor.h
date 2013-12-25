//
//  APIAccessor.h
//  Ex6
//
//  Created by Xurxo Méndez Pérez on 25/12/13.
//  Copyright (c) 2013 SmartGalApps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

#define API_URL @"http://localhost:3000"

#define API_GET_USERS "users.json"
#define API_GET_USER "users/%@.json"

@interface APIAccessor : NSObject

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

+ (id)sharedInstance;

- (void)getAllUsersWithDelegate:(id)delegate;

- (void)getUserWithId:(NSNumber*)userId delegate:(id)delegate;

@end
