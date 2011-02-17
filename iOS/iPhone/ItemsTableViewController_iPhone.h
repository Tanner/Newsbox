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


@protocol ItemsTableViewControllerDelegate
- (void)loginAndDownloadItems;
- (void)showItem:(MWFeedItem *)anItem;
- (void)showSettingsView;
- (UIBarButtonItem *)refreshButtonItem;
- (UIBarButtonItem *)refreshInfoViewButtonItem;
@end

@interface ItemsTableViewController_iPhone : UITableViewController {
	id<ItemsTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;
	
	NSMutableArray *items;
	ItemType currentItemType;
//	EGORefreshTableHeaderView *_refreshHeaderView;
	
	UIView *modalView;
	    
	BOOL reloading;
}

- (void)setItems:(NSArray *)someItems withType:(ItemType)type;
- (void)refresh;
- (void)didLoadTableViewData;
- (void)reformatCellLabelsWithOrientation:(UIInterfaceOrientation)orientation;

@property (nonatomic, assign) id<ItemsTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *items;

@end