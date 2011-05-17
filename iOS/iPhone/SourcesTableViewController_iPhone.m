//
//  SourcesTableViewController_iPhone.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/17/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "SourcesTableViewController_iPhone.h"
#import "OBGradientView.h"
#import "AppDelegate_Shared.h"
#import "SourceTableViewCell.h"

@implementation SourcesTableViewController_iPhone

@synthesize delegate;
@dynamic sources;

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)setSources:(NSMutableArray *)array {
    if (sources != array) {
        [sources release];
        sources = [array retain];
        [sources sortUsingSelector:@selector(compareByName:)];
    }
    
    [self.tableView reloadData];
}

- (void)reloadData {
    [sources removeAllObjects];
    
    NSFetchRequest *fetchRequest = [[(AppDelegate_Shared *)delegate managedObjectModel]
                                    fetchRequestTemplateForName:@"allSources"];
    NSArray *executedRequest = [[(AppDelegate_Shared *)delegate managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    if (executedRequest) {
        [sources addObjectsFromArray:executedRequest];
    }
    
    [sources sortUsingSelector:@selector(compareByName:)];

    [self.tableView reloadData];
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
    
    sources = [[NSMutableArray alloc] init];
    
    [self.navigationItem setTitle:@"Unread"];
    
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *refreshItem = [delegate refreshButtonItem];
    [toolbarItems addObject:refreshItem];
    
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
    [self reloadData];
    
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
        cell = [[[SourceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0) {
        NSFetchRequest *fetchRequest = [[(AppDelegate_Shared *)delegate managedObjectModel] fetchRequestTemplateForName:@"unreadItems"];
        NSUInteger count = [[(AppDelegate_Shared *)delegate managedObjectContext] countForFetchRequest:fetchRequest error:nil];
        if (count > 0)
            [(SourceTableViewCell *)cell setBadgeString:[NSString stringWithFormat:@"%d", count]];
        else
            [(SourceTableViewCell *)cell setBadgeString:nil];
        
        [[cell textLabel] setText:@"All Sources"];
    } else {
        NSFetchRequest *fetchRequest = [[(AppDelegate_Shared *)delegate managedObjectModel]
                                        fetchRequestFromTemplateWithName:@"unreadItemsFromSourceWithLink"
                                        substitutionVariables:[NSDictionary dictionaryWithObject:[[sources objectAtIndex:indexPath.row] link] forKey:@"sourceLink"]];
        NSUInteger count = [[(AppDelegate_Shared *)delegate managedObjectContext] countForFetchRequest:fetchRequest error:nil];
        if (count > 0)
            [(SourceTableViewCell *)cell setBadgeString:[NSString stringWithFormat:@"%d", count]];
        else
            [(SourceTableViewCell *)cell setBadgeString:nil];
        
        [[cell textLabel] setText:[[sources objectAtIndex:indexPath.row] title]];
    }
    

    
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
            [delegate showItemsTableViewWithSourceLink:nil];
            
            break;
        }
        case 1: {
            [delegate showItemsTableViewWithSourceLink:[[sources objectAtIndex:indexPath.row] link]];
            
            break;
        }
    }
}

@end
