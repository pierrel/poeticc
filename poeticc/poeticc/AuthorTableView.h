//
//  AuthorTableView.h
//  poeticc
//
//  Created by pierre larochelle on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Couch;

@interface AuthorTableView : UITableViewController {
    NSMutableArray *authors;
    Couch *couch;
}
@end
