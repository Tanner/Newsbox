//
//  SettingsTableViewController_iPhone.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/12/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "SettingsTableViewController_iPhone.h"
#import "SFHFKeychainUtils.h"
#import "SFHFEditableCell.h"
#import "GitHubCommitServiceFactory.h"
#import "GitHubService.h"
#import "GitHubServiceSettings.h"

@implementation SettingsTableViewController_iPhone

@synthesize delegate, latestGitSHA;


- (void)cancelButtonPushed:(id)sender {
    [delegate returnFromSettingsTableViewController];
}


- (void)doneButtonPushed:(id)sender {
    [delegate returnFromSettingsTableViewController];
    NSString *username = [[(SFHFEditableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textField] text];
    NSString *password = [[(SFHFEditableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] textField] text];
    [delegate changedUsername:username andPassword:password];
}


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationItem setTitle:@"Settings"];
    [self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPushed:)] autorelease]];
    [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPushed:)] autorelease]];
        
    [self.tableView reloadData];
    
    latestGitSHA = [[NSString alloc] init];
    [GitHubServiceSettings setCredential:[NSURLCredential credentialWithUser:@"Tanner"
                                                                    password:@"pack12"
                                                                 persistence:NSURLCredentialPersistenceNone]]; 
    [GitHubServiceSettings setSecureServerAddress:@"https://github.com"];
    [GitHubCommitServiceFactory requestCommitsOnBranch:@"iOS" repository:@"Newsbox" user:@"Tanner" delegate:self];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
 
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 1;
        default:
            return 0;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        switch (indexPath.section) {
            case 0: {
                cell = [[[SFHFEditableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
                break;
            }
            case 1: {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
                break;
            }
            default : {
                break;
            }
        }
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *username = [prefs objectForKey:@"GoogleUsername"];
        
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    [(SFHFEditableCell *)cell setLabelText:@"Username" andPlaceholderText:@""];
                    if (username) {
                        [[(SFHFEditableCell *)cell textField] setText:username];
                    }
                    break;
                }
                case 1: {
                    [(SFHFEditableCell *)cell setTextFieldAsPassword];
                    NSError *error = nil;
                    NSString *pass = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:@"Google" error:&error];
                    [(SFHFEditableCell *)cell setLabelText:@"Password" andPlaceholderText:nil];
                    if (pass) {
                        [[(SFHFEditableCell *)cell textField] setText:pass];
                    }
                    break;
                }
                default: {
                    break;
                }
            }
            break;
        }
        case 1: {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
            [[cell textLabel] setText:@"Build"];
            [[cell detailTextLabel] setText:build];
            break;
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView headerForFooterInSection:(NSInteger)section {
    return @"Settings";
}


-(void)gitHubService:(id<GitHubService>)gitHubService gotCommit:(id<GitHubCommit>)commit {
    if ([latestGitSHA isEqualToString:@""]) {
        latestGitSHA = commit.sha;
    }
}


-(void)gitHubServiceDone:(id <GitHubService>)gitHubService {
    //NSLog(@"Git Hub Service done!");
}


-(void)gitHubService:(id <GitHubService>)gitHubService didFailWithError:error {
    //NSLog(@"Git Hub Service failed!");
    //NSLog(@"%@", error);
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [latestGitSHA release];
    
    [super dealloc];
}


@end

