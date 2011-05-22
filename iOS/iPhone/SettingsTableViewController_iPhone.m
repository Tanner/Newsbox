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

@implementation SettingsTableViewController_iPhone

NSString *testUsername = @"newsbox.test@gmail.com";
NSString *testPassword = @"FA1w0wxjRTHRyj";

@synthesize delegate;

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
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 1;
        case 2:
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
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                [[cell textLabel] setTextAlignment:UITextAlignmentCenter];
                break;
            }
            case 2: {
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
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
            [[cell textLabel] setText:@"Log In With Test Account"];
            break;
        }
        case 2: {
            [[cell textLabel] setText:@"Git Information"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        }
    }
    
    return cell;
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
    switch(indexPath.section) {
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    [delegate returnFromSettingsTableViewController];
                    [delegate changedUsername:testUsername andPassword:testPassword];
                    break;
                }
            }
            break;
        }
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    [delegate showGitCommits];
                    break;
                }
            }
            break;
        }
    }
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
    [super dealloc];
}


@end

