//
//  PoemTableViewController.h
//  poeticc
//
//  Created by pierre larochelle on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Couch;

@interface PoemTableViewController : UITableViewController {
    NSMutableDictionary *poems;
    Couch *couch;
    
    NSString *poetName;
}

-(id)initWithPoetNamed:(NSString*)poet;

@property (nonatomic, retain)Couch *couch;

@end

