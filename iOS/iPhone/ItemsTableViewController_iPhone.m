//
//  FeedsTableViewController_iPhone.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "ItemsTableViewController_iPhone.h"
#import "MWFeedItem.h"
#import "ItemsTableViewCell.h"
#import "RefreshInfoView.h"

#define CELL_HEIGHT 95.0f

@interface ItemsTableViewController_iPhone (private)
	- (CGFloat)suggestedHeightForItem:(MWFeedItem *)anItem;
@end

@implementation ItemsTableViewController_iPhone

@synthesize delegate, items;

- (void)setItems:(NSMutableArray *)someItems withType:(ItemType)type {	
	self.items = someItems;
	
	if (modalView) {
		[modalView removeFromSuperview];
		[modalView release];
		modalView = nil;
		
		[self.tableView setScrollEnabled:YES];
	}
	
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)refresh {
    [delegate loginAndDownloadItems];
}

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
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

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
    
	if (!items && !modalView) {
		modalView = [[UIView alloc] initWithFrame:self.view.bounds];
		[modalView setBackgroundColor:[UIColor whiteColor]];
		[modalView setOpaque:YES];
        [modalView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		[self.view addSubview:modalView];
		
		[self.tableView scrollRectToVisible:modalView.frame animated:NO];
		[self.tableView setScrollEnabled:NO];
	}
}


- (void)viewWillAppear:(BOOL)animated {
    [self reformatCellLabelsWithOrientation:[self interfaceOrientation]];

    [super viewWillAppear:animated];
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
    
    [(ItemsTableViewCell *)cell setSourceLabelText:[[(MWFeedItem *)[items objectAtIndex:indexPath.row] source] title]
                                  andDateLabelText:[(MWFeedItem *)[items objectAtIndex:indexPath.row] shortDateString]
									andTitleLabelText:[(MWFeedItem *)[items objectAtIndex:indexPath.row] title]
								  andContentLabelText:[(MWFeedItem *)[items objectAtIndex:indexPath.row] contentSample]
										  andCellSize:CGSizeMake(self.view.bounds.size.width, CELL_HEIGHT)
	 ];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[delegate showItem:[items objectAtIndex:indexPath.row]];
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

