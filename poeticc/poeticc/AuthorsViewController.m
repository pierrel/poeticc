//
//  FirstViewController.m
//  poeticc
//
//  Created by pierre larochelle on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthorsViewController.h"


@implementation AuthorsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    navController = [[UINavigationController alloc] initWithRootViewController:self];
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
    [navController release];
    navController = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [navController release];
    [super dealloc];
}

@end
