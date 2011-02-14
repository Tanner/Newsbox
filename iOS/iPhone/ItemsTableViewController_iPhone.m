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


@synthesize delegate;


- (void)setItems:(NSArray *)someItems withType:(ItemType)type {
	if (items) {
		[items release];
		items = nil;
	}
	
	currentItemType = type;
	items = [[NSMutableArray alloc] initWithArray:[someItems copy]];
	
	if (modalView) {
        /*
		[activityIndicator removeFromSuperview];
		[activityIndicator stopAnimating];
		[activityIndicator release];
		activityIndicator = nil;
         */
		
		[modalView removeFromSuperview];
		[modalView release];
		modalView = nil;
		
		[self.tableView setScrollEnabled:YES];
	}
	
	[self.tableView reloadData];
	[self didLoadTableViewData];
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
		[(ItemsTableViewCell *)cell setTimeStampLabelText:[[items objectAtIndex:index] dateString]
										andTitleLabelText:[[items objectAtIndex:index] title]
									  andContentLabelText:[[items objectAtIndex:index] contentSample]
											  andCellSize:CGSizeMake(width, CELL_HEIGHT)
		 ];
	}
}


- (void)didLoadTableViewData {
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"Unread"];

    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
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
    	
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0]];
    [self.navigationController.toolbar setTintColor:[UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0]];
    
	if (!items && !modalView) {
		modalView = [[UIView alloc] initWithFrame:self.view.bounds];
		[modalView setBackgroundColor:[UIColor whiteColor]];
		[modalView setOpaque:YES];
        [modalView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		[self.view addSubview:modalView];
		
		[self.tableView scrollRectToVisible:modalView.frame animated:NO];
		[self.tableView setScrollEnabled:NO];
		
        /*
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[activityIndicator setFrame:CGRectMake((self.view.bounds.size.width - 20.0f)/2, (self.view.bounds.size.height - 20.0f)/2 - 10.0f  , 20.0f, 20.0f)];
        [activityIndicator setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
		[activityIndicator startAnimating];
		[modalView addSubview:activityIndicator];
         */
	}
}


- (void)viewWillAppear:(BOOL)animated {
    [self reformatCellLabelsWithOrientation:[self interfaceOrientation]];

    [super viewWillAppear:animated];
}


- (void)settingsButtonPressed:(id)sender {
    [delegate showSettingsView];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self reformatCellLabelsWithOrientation:toInterfaceOrientation];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ItemsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
//	NSLog(@"%d", indexPath.row);
    [(ItemsTableViewCell *)cell setTimeStampLabelText:[(MWFeedItem *)[items objectAtIndex:indexPath.row] dateString]
									andTitleLabelText:[(MWFeedItem *)[items objectAtIndex:indexPath.row] title]
								  andContentLabelText:[(MWFeedItem *)[items objectAtIndex:indexPath.row] contentSample]
										  andCellSize:CGSizeMake(self.view.bounds.size.width, CELL_HEIGHT)
	 ];
    
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
	[delegate showItem:[items objectAtIndex:indexPath.row]];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

/*
- (CGFloat)suggestedHeightForItem:(Item *)anItem {
	float const PADDING = 2.0f;
	float const MAX_HEIGHT = 100.0f;
	float const DISCLOSURE_ACCESSORY_WIDTH = 12.0f;
	
	NSString *timeStampText = [anItem dateString];
	NSString *titleText = [anItem title];
	NSString *contentText = [anItem contentSample];
	
	CGSize constSize = { self.tableView.bounds.size.width - PADDING*2 - DISCLOSURE_ACCESSORY_WIDTH - PADDING, MAX_HEIGHT };
	CGSize timeStampTextSize = [timeStampText sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:constSize lineBreakMode:UILineBreakModeTailTruncation];	
	
	CGSize titleLabelConstSize = { self.tableView.bounds.size.width - PADDING*2 - DISCLOSURE_ACCESSORY_WIDTH - PADDING, MAX_HEIGHT };
	CGSize titleTextSize = [titleText sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:titleLabelConstSize lineBreakMode:UILineBreakModeTailTruncation];
	
	CGSize contentLabelConstSize = { self.tableView.bounds.size.width - PADDING*2 - DISCLOSURE_ACCESSORY_WIDTH - PADDING, MAX_HEIGHT };
	CGSize contentTextSize = [contentText sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:contentLabelConstSize lineBreakMode:UILineBreakModeTailTruncation];
	
	return timeStampTextSize.height + titleTextSize.height + contentTextSize.height + PADDING*2;
}
 */


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
	[items release];
	
    [super dealloc];
}


@end

