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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            if ([commits count] > 0) {
                return 2;
            } else {
                return 1;
            }
            break;
        }
        case 1: {
            return [commits count] - 1;
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
            return @"Latest GitHub Commits";
        }
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BuildInfoCellIdentifier = @"BuildInfoCell";
    static NSString *CommitCellIdentifier = @"CommitCell";
        
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BuildInfoCellIdentifier];

        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BuildInfoCellIdentifier] autorelease];
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
                if (!commits || [commits count] == 0) {
                    break;
                }
                
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *buildDate = [infoDictionary objectForKey:@"BuildDate"];
                                    
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss ZZZ"];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
                NSDate *localBuildDate = [dateFormatter dateFromString:buildDate];
                [dateFormatter release];
                NSDate *latestCommitDate = [[commits objectAtIndex:0] committedDate];
                                    
                [[cell textLabel] setText:@"Status"];
                                    
                if (commits && [commits count] > 0) {
                    if ([localBuildDate compare:latestCommitDate] == NSOrderedSame) {
                        [[cell detailTextLabel] setText:@"Up-to-Date"];
                    } else if ([localBuildDate compare:latestCommitDate] == NSOrderedDescending) {
                        [[cell detailTextLabel] setText:@"Not Pushed"];
                    } else if ([localBuildDate compare:latestCommitDate] == NSOrderedAscending) {
                        [[cell detailTextLabel] setText:@"Out-of-Date"];
                    }
                } else {
                    [[cell detailTextLabel] setText:@""];
                }
                break;
            }
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommitCellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CommitCellIdentifier] autorelease];
        }
        
        [[cell detailTextLabel] setNumberOfLines:10];
        
        if (commits && [commits count] > 1) {
            [[cell textLabel] setText:[NSString stringWithFormat:@"%d. %@", indexPath.row+1, [[[commits objectAtIndex:indexPath.row] sha] substringToIndex:7]]];
            [[cell detailTextLabel] setText:[[commits objectAtIndex:indexPath.row] message]];
        }
        
        [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:14.0f]];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
        
        NSString *latestShortGitSHA = [[[commits objectAtIndex:indexPath.row] sha] substringToIndex:7];
        if ([latestShortGitSHA isEqualToString:build]) {
            [cell setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        } else {
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
}

#pragma mark -
#pragma mark GitHubServiceDelegate Methods

-(void)gitHubService:(id<GitHubService>)gitHubService gotCommit:(id<GitHubCommit>)commit {
    if ([commits count] <= 10) {
        [commits addObject:commit];
    
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
        NSString *commitText = [[[commits objectAtIndex:indexPath.row] sha] substringToIndex:7];
        UIFont *commitFont = [UIFont boldSystemFontOfSize:16.0f];
        
        CGSize commitLabelConstraintSize = CGSizeMake(self.view.bounds.size.width - 40.0f, 95.0f);
        CGSize commitLabelSize = [commitText sizeWithFont:commitFont constrainedToSize:commitLabelConstraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        NSString *messageText = [[commits objectAtIndex:indexPath.row] message];
        UIFont *messageFont = [UIFont systemFontOfSize:14.0f];
        
        CGSize messageLabelConstraintSize = CGSizeMake(self.view.bounds.size.width - 40.0f, 320.0f);
        CGSize messageLabelSize = [messageText sizeWithFont:messageFont constrainedToSize:messageLabelConstraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        return commitLabelSize.height + 5 + messageLabelSize.height + 20;   
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
