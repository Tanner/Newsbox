//
//  GitCommitsTableViewController_iPhone.m
//  NewsBox
//
//  Created by Tanner Smith on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GitCommitsTableViewController_iPhone.h"
#import "GitHubCommitServiceFactory.h"
#import "GitHubService.h"
#import "GitHubServiceSettings.h"

@implementation GitCommitsTableViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        commits = [[NSMutableArray alloc] init];
        foundBuild = NO;
    }
    
    return self;
}

- (void)dealloc
{
    [commits release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [commits removeAllObjects];
    foundBuild = NO;
    
    [GitHubServiceSettings setCredential:[NSURLCredential credentialWithUser:@"Tanner"
                                                                    password:@"pack12"
                                                                 persistence:NSURLCredentialPersistenceNone]]; 
    [GitHubServiceSettings setSecureServerAddress:@"https://github.com"];
    [GitHubCommitServiceFactory requestCommitsOnBranch:@"iOS" repository:@"Newsbox" user:@"Tanner" delegate:self];
    
    [self.tableView reloadData];
    
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
    if ([commits count] > 1) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: {
            return 2;
            break;
        }
        case 1: {
            return [commits count];
            break;
        }
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return @"Build Information";
        }
        case 1: {
            return @"Missing Commits";
        }
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    switch (indexPath.section) {
        case 0: {
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
            }
            
            switch (indexPath.row) {
                case 0: {
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
                    [[cell textLabel] setText:@"Build"];
                    [[cell detailTextLabel] setText:build];
                    break;
                }
                case 1: {
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
                    
                    [[cell textLabel] setText:@"Up-to-Date"];
                    
                    if (commits && [commits count] > 0) {
                        NSString *latestShortGitSHA = [[[commits objectAtIndex:0] sha] substringToIndex:7];
                        if ([latestShortGitSHA isEqualToString:build]) {
                            [[cell detailTextLabel] setText:@"Yes"];
                        } else {
                            [[cell detailTextLabel] setText:@"No"];
                        }
                    } else {
                        [[cell detailTextLabel] setText:@""];
                    }
                    break;
                }
            }
            break;
        }
        case 1: {
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            }
            
            [[cell textLabel] setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
            [[cell textLabel] setNumberOfLines:0];
            
            if (commits && [commits count] > 1) {
                [[cell textLabel] setText:[[commits objectAtIndex:indexPath.row] message]];
            } else {
                [[cell textLabel] setText:@"No Missing Commits"];
            }
            break;
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark -
#pragma mark GitHubServiceDelegate Methods

-(void)gitHubService:(id<GitHubService>)gitHubService gotCommit:(id<GitHubCommit>)commit {
    if (!foundBuild) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
        
        [commits addObject:commit];
        
        if ([[commit.sha substringToIndex:7] isEqualToString:build]) {
            foundBuild = YES;
        }
        
        [self.tableView reloadData];
    }
}


-(void)gitHubServiceDone:(id <GitHubService>)gitHubService {
    //NSLog(@"Git Hub Service done!");
}


-(void)gitHubService:(id <GitHubService>)gitHubService didFailWithError:error {
    //NSLog(@"Git Hub Service failed!");
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([commits count] > 1 && indexPath.section == 1) {
        NSString *cellText = [[commits objectAtIndex:indexPath.row] message];
        UIFont *cellFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        
        CGSize constraintSize = CGSizeMake(self.view.bounds.size.width, 95.0f);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        return labelSize.height + 20;   
    }
    
    return 44.0f;
}

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

@end
