//
//  ApiController.m
//  poeticc
//
//  Created by pierre larochelle on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ApiController.h"


@implementation ApiController

-(id)init {
    self = [super init];
    if (self) {
        NSPropertyListFormat format;
        NSString *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          @"config" ofType:@"plist"];
        
        // Build the array from the plist  
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *plist = (NSDictionary*)[NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
        if (!plist) {  
            NSLog(@"Error reading plist from file '%s', error = '%s'", [path UTF8String], [error UTF8String]);  
            [error release];  
        }  
        NSLog(@"%@", plist);
        NSDictionary *db = (NSDictionary*)[plist objectForKey:@"db"];

        baseUrl = [NSString stringWithFormat:@"https://%@:%@@%@.%@/%@/",
                   [db objectForKey:@"username"],
                   [db objectForKey:@"password"],
                   [db objectForKey:@"username"],
                   [db objectForKey:@"domain"],
                   [db objectForKey:@"name"]];
        NSLog(@"%@", baseUrl);
        
        // now make a request
        [[LRResty client] get:[NSString stringWithFormat:@"%@%@", baseUrl, @"_design/couch/_view/poets"] withBlock:^(LRRestyResponse *r) {
            NSLog(@"%@", [r asString]);
        }];
    }
    
    return self;
}

@end
