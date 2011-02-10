//
//  FeedsTableViewController_iPhone.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "ItemsTableViewController_iPhone.h"
#import "Item.h"
#import "ItemsTableViewCell.h"


@interface ItemsTableViewController_iPhone (private)
	- (CGFloat)suggestedHeightForItem:(Item *)anItem;
@end



@implementation ItemsTableViewController_iPhone


@synthesize delegate;


- (void)setItems:(NSArray *)someItems withType:(ItemType)type {
	if (items) {
		[items release];
		items = nil;
	}
	
	currentItemType = type;
	items = [[NSMutableArray alloc] initWithArray:someItems];
	
	if (modalView) {
		[activityIndicator removeFromSuperview];
		[activityIndicator stopAnimating];
		[activityIndicator release];
		activityIndicator = nil;
		
		[modalView removeFromSuperview];
		[modalView release];
		modalView = nil;
		
		[self.tableView setScrollEnabled:YES];
	}
	
	[self.tableView reloadData];
	[self performSelector:@selector(didLoadTableViewData) withObject:nil afterDelay:3.0];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
	[delegate refreshWithItemType:currentItemType];
	
	_reloading = YES;
	
}

- (void)didLoadTableViewData {
	_reloading = NO;
	
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderView delegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed	
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {	
	if (_refreshHeaderView == nil) {
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		_refreshHeaderView.delegate = self;
	}
	
	[self.tableView addSubview:_refreshHeaderView];
	[_refreshHeaderView refreshLastUpdatedDate];
		
	if (!items && !modalView) {
		modalView = [[UIView alloc] initWithFrame:self.view.bounds];
		[modalView setBackgroundColor:[UIColor whiteColor]];
		[modalView setOpaque:YES];
		[self.view addSubview:modalView];
		
		[self.tableView scrollRectToVisible:modalView.frame animated:NO];
		[self.tableView setScrollEnabled:NO];
		
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[activityIndicator setFrame:CGRectMake((self.view.bounds.size.width - 20.0f)/2, (self.view.bounds.size.height - 20.0f)/2 - 20.0f, 20.0f, 20.0f)];
		[activityIndicator startAnimating];
		[modalView addSubview:activityIndicator];
	}
	
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[self.navigationItem setTitle:@"Newsbox"];
	[self.navigationController setToolbarHidden:NO];
	
    [super viewWillAppear:animated];
}



- (void)viewDidAppear:(BOOL)animated {
    
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
    [(ItemsTableViewCell *)cell setTimeStampLabelText:[(Item *)[items objectAtIndex:indexPath.row] dateString]
									andTitleLabelText:[(Item *)[items objectAtIndex:indexPath.row] title]
								  andContentLabelText:[(Item *)[items objectAtIndex:indexPath.row] contentSample]
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
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95.0f;
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

