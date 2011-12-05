//
//  Couch.m
//  poeticc
//
//  Created by pierre larochelle on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Couch.h"
#include "NSDictionary_JSONExtensions.h"


@implementation Couch

-(id)initWithBaseURL:(NSURL*)url {
    self = [super init];
    if (self) {
        baseURL = [url retain];
    }
    
    return self;
}

-(void)getView:(NSString*)view withParams:(NSDictionary*)params withBlock:(void (^)(LRRestyResponse *))block{
    NSString *formatedString = [NSString stringWithFormat:@"%@%@/%@", [baseURL absoluteString], @"_design/couch/_view", view];
    [[LRResty client] get:formatedString
               parameters:params 
                withBlock:block];
}
-(void)getView:(NSString *)view withParams:(NSDictionary *)params withSuccessBlock:(void (^)(NSDictionary *))block withErrorBlock:(void (^)(NSString *, NSString *))errorBlock {
    NSString *formatedString = [NSString stringWithFormat:@"%@%@/%@", [baseURL absoluteString], @"_design/couch/_view", view];
    [[LRResty client] get:formatedString
               parameters:params 
                withBlock:^(LRRestyResponse *r) {
                    NSError *theError = nil;
                    NSDictionary *returned = [NSDictionary dictionaryWithJSONData:[r responseData] error:&theError];
                    if ([returned objectForKey:@"error"]) {
                        errorBlock([returned objectForKey:@"error"], [returned objectForKey:@"reason"]);
                    } else {
                        block(returned);
                    }
               }
     ];
}

@end
