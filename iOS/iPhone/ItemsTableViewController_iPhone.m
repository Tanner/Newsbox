//
//  FeedsTableViewController_iPhone.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "ItemsTableViewController_iPhone.h"
#import "SourceSupport.h"
#import "ItemSupport.h"
#import "ItemsTableViewCell.h"
#import "RefreshInfoView.h"
#import "AppDelegate_Shared.h"

#define CELL_HEIGHT 95.0f

@interface ItemsTableViewController_iPhone (private)
	- (CGFloat)suggestedHeightForItem:(Item *)anItem;
@end

@implementation ItemsTableViewController_iPhone

@synthesize delegate;
@synthesize sourceLink;
@synthesize currentItem;

- (void)setCurrentItem:(Item *)aCurrentItem {
    if ([items count] > 0) {
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[items indexOfObject:currentItem] inSection:0]] setSelected:NO animated:NO];

        currentItem = aCurrentItem;
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[items indexOfObject:currentItem] inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[items indexOfObject:currentItem] inSection:0]] setSelected:YES animated:NO];
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        if (path) {
            NSLog(@"%d", path.row);
        }
    }
}

- (void)reloadData {
    [items removeAllObjects];
    
    NSArray *executedRequest;
    if (sourceLink) {
        NSFetchRequest *fetchRequest = [[(AppDelegate_Shared *)delegate managedObjectModel]
                                        fetchRequestFromTemplateWithName:@"itemsFromSourceWithLink"
                                        substitutionVariables:[NSDictionary dictionaryWithObject:sourceLink forKey:@"sourceLink"]];
        executedRequest = [[(AppDelegate_Shared *)delegate managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    } else {
        NSFetchRequest *fetchRequest = [[(AppDelegate_Shared *)delegate managedObjectModel]
                                        fetchRequestTemplateForName:@"allItems"];
        executedRequest = [[(AppDelegate_Shared *)delegate managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    }
    
    if (executedRequest) {
        [items addObjectsFromArray:executedRequest];
    }
 
    [items sortUsingSelector:@selector(compareByDate:)];
    
    [self.tableView reloadData];
}

- (void)setSourceLink:(NSString *)sl {
    sourceLink = sl;
    
    [self reloadData];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reformatCellLabelsWithOrientation:(UIInterfaceOrientation)orientation {
	float width;
	if (UIInterfaceOrientationIsPortrait(orientation)) {
		width = 320.0f;
	} else {
		width = 480.0f;
	}
	
	// don't reload everything, just visible
	for (UITableViewCell *cell in [self.tableView visibleCells]) {
		int index = [self.tableView indexPathForCell:cell].row;
		[(ItemsTableViewCell *)cell setSourceLabelText:[[[items objectAtIndex:index] source] title]
                                      andDateLabelText:[[items objectAtIndex:index] shortDateString]
										andTitleLabelText:[[items objectAtIndex:index] title]
									  andContentLabelText:[[items objectAtIndex:index] contentSample]
											  andCellSize:CGSizeMake(width, CELL_HEIGHT)
		 ];
	}
}

#pragma mark -
#pragma mark Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    [self setToolbarItems:toolbarItems animated:NO];
    [toolbarItems release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    if ([items count] > 0) {    
        [self reformatCellLabelsWithOrientation:[self interfaceOrientation]];
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[items indexOfObject:currentItem] inSection:0]] setSelected:NO animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    currentItem = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([items count] > 0) {    
        self.currentItem = [items objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self reformatCellLabelsWithOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ItemsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [(ItemsTableViewCell *)cell setSourceLabelText:[[(Item *)[items objectAtIndex:indexPath.row] source] title]
                                  andDateLabelText:[(Item *)[items objectAtIndex:indexPath.row] shortDateString]
									andTitleLabelText:[(Item *)[items objectAtIndex:indexPath.row] title]
								  andContentLabelText:[(Item *)[items objectAtIndex:indexPath.row] contentSample]
										  andCellSize:CGSizeMake(self.view.bounds.size.width, CELL_HEIGHT)
	 ];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    currentItem = [items objectAtIndex:indexPath.row];
    
	[delegate showItemAtIndex:[items indexOfObject:currentItem] fromArray:items];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    
}

- (void)dealloc {
	[items release];
	
    [super dealloc];
}

@end

