//
//  Couch.h
//  poeticc
//
//  Created by pierre larochelle on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LRResty/LRResty.h>

typedef void (^resty_block_t)(LRRestyResponse *);

@interface Couch : NSObject {
    NSURL *baseURL;
}

+(id)initWithBaseURL:(NSURL*)url;

-(void)getView:(NSString*)view withParams:(NSDictionary*)params withBlock:(void (^)(LRRestyResponse *))block;
-(void)getView:(NSString*)view withParams:(NSDictionary*)params withSuccessBlock:(void (^)(NSDictionary *))block withErrorBlock:(void (^)(NSString *error, NSString *reason))errorBlock;

@end
