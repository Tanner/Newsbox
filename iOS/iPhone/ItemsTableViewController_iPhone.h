//
//  FeedsTableViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"
#import "RefreshInfoView.h"


@protocol ItemsTableViewControllerDelegate;

@interface ItemsTableViewController_iPhone : UITableViewController <RefreshInfoViewDelegate> {
	id<ItemsTableViewControllerDelegate> delegate;
	
	NSMutableArray *items;
	ItemType currentItemType;
//	EGORefreshTableHeaderView *_refreshHeaderView;
	
	UIView *modalView;
	
    RefreshInfoView *refreshInfoView;
    
	BOOL reloading;
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
- (void)showSettingsView;
@end