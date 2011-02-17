//
//  SourcesTableViewController_iPhone.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/17/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "SourcesTableViewController_iPhone.h"
#import "OBGradientView.h"

@implementation SourcesTableViewController_iPhone

@synthesize delegate, sources;

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)setSources:(NSMutableArray *)someSources withType:(ItemType)type {
    sources = someSources;
    
    [self.tableView reloadData];
}

- (void)refresh {
    [delegate loginAndDownloadItems];
}

- (void)reformatCellLabelsWithOrientation:(UIInterfaceOrientation)orientation {
	
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Unread"];
    
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *refreshItem = [delegate refreshButtonItem];
    [refreshItem setTarget:self];
    [refreshItem setAction:@selector(refresh)];
    [toolbarItems addObject:refreshItem];
    [refreshItem release];
    
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbarItems addObject:flexibleSpaceItem];
    [flexibleSpaceItem release];
    
    UIBarButtonItem *refreshInfoItem = [delegate refreshInfoViewButtonItem];
    [toolbarItems addObject:refreshInfoItem];
    //[refreshInfoItem release];
    
    UIBarButtonItem *flexibleSpaceItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbarItems addObject:flexibleSpaceItem2];
    [flexibleSpaceItem2 release];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [fixedSpace setWidth:24.0f];
    [toolbarItems addObject:fixedSpace];
    [fixedSpace release];    
    
    [self setToolbarItems:toolbarItems animated:NO];
    
    [toolbarItems release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
 
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [sources count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0) {
        [[cell textLabel] setText:@"All Unread Items"];
    } else {
        [[cell textLabel] setText:[[sources objectAtIndex:indexPath.row] title]];
    }
    
    OBGradientView *gradientView = [[[OBGradientView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)] autorelease];
    [gradientView setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:241.0/255.0 green:22.0/255.0 blue:22.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:207.0/255.0 green:14.0/255.0 blue:14.0/255.0 alpha:1.0] CGColor], nil]];
    [gradientView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [cell setSelectedBackgroundView:gradientView];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Sources";
    }
    
    return @"";
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            [delegate showItemsTableViewWithSource:nil];
            
            break;
        }
        case 1: {
            [delegate showItemsTableViewWithSource:[sources objectAtIndex:indexPath.row]];
            
            break;
        }
    }
}

@end
