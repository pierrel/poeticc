//
//  Couch.m
//  poeticc
//
//  Created by pierre larochelle on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Couch.h"


@implementation Couch

-(id)initWithBaseURL:(NSURL*)url {
    self = [super init];
    if (self) {
        baseURL = [url retain];
    }
    
    return self;
}

-(void)getView:(NSString*)view withParams:(NSDictionary*)params withBlock:(void (^)(LRRestyResponse *))block{
    
    [[LRResty client] get:[NSString stringWithFormat:@"%@%@/%@", [baseURL absoluteString], @"_design/couch/_view/", view]
               parameters:params 
                withBlock:block];
}

@end
