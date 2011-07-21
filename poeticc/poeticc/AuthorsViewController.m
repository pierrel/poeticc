//
//  FirstViewController.m
//  poeticc
//
//  Created by pierre larochelle on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthorsViewController.h"
#import "ApiController.h"


@implementation AuthorsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    NSString *baseUrl = [NSString stringWithFormat:@"https://%@:%@@%@.%@/%@/",
                         [db objectForKey:@"username"],
                         [db objectForKey:@"password"],
                         [db objectForKey:@"username"],
                         [db objectForKey:@"domain"],
                         [db objectForKey:@"name"]];
    NSLog(@"%@", baseUrl);
    couch = [[Couch alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    NSDictionary *params = [NSDictionary dictionaryWithObject:@"true"
                                                       forKey:@"group"];
    
    [couch getView:@"poets" withParams:params withBlock:^(LRRestyResponse *r) {
        NSLog(@"%@", [r asString]);
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [couch dealloc];
    [super dealloc];
}

@end
