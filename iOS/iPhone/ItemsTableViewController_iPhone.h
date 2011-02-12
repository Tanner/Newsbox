//
//  FeedsTableViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MWFeedItem.h"


@protocol ItemsTableViewControllerDelegate;

@interface ItemsTableViewController_iPhone : UITableViewController <EGORefreshTableHeaderDelegate> {
	id<ItemsTableViewControllerDelegate> delegate;
	
	NSMutableArray *items;
	ItemType currentItemType;
	EGORefreshTableHeaderView *_refreshHeaderView;
	
	UIView *modalView;
	UIActivityIndicatorView *activityIndicator;
	
	BOOL _reloading;
}

- (void)setItems:(NSArray *)someItems withType:(ItemType)type;
- (void)reloadTableViewDataSource;
- (void)didLoadTableViewData;
- (void)reformatCellLabelsWithOrientation:(UIInterfaceOrientation)orientation;

@property (nonatomic, assign) id<ItemsTableViewControllerDelegate> delegate;

@end


@protocol ItemsTableViewControllerDelegate
- (void)refreshWithItemType:(ItemType)type;
- (void)showItem:(MWFeedItem *)anItem;
@end