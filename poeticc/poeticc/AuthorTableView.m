//
//  AuthorTableView.m
//  poeticc
//
//  Created by pierre larochelle on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthorTableView.h"
#import "Couch.h"
#include "NSDictionary_JSONExtensions.h"

@implementation AuthorTableView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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
    Couch *couch = [[Couch alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    NSDictionary *params = [NSDictionary dictionaryWithObject:@"true"
                                                       forKey:@"group"];
    
    [couch getView:@"poets" withParams:params withBlock:^(LRRestyResponse *r) {
        NSLog(@"%@", [r asString]);
        NSError *theError = nil;
        NSDictionary *authorStuff = [NSDictionary dictionaryWithJSONData:[r responseData] error:&theError];
        if (authorStuff) {
            authors = [[authorStuff objectForKey:@"rows"] retain];
            [self.tableView reloadData];
        } else {
            NSLog(@"failed parsing with error: %@", theError);
        }
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return [authors count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSDictionary *authorInfo = [authors objectAtIndex:indexPath.row];
    [cell setText:[authorInfo objectForKey:@"key"]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - memory mgmt
-(void) dealloc {
    [authors release];
    [super dealloc];
}

@end
