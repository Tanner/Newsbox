//
//  FeedsTableViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "Feed.h"


@protocol FeedTableViewControllerDelegate;

@interface FeedsTableViewController_iPhone : UITableViewController <EGORefreshTableHeaderDelegate> {
	id<FeedTableViewControllerDelegate> delegate;
	
	NSMutableArray *feeds;
	FeedType currentFeedType;
	EGORefreshTableHeaderView *_refreshHeaderView;
	
	BOOL _reloading;
}

- (void)setFeeds:(NSArray *)aFeeds withType:(FeedType)type;
- (void)reloadTableViewDataSource;
- (void)didLoadTableViewData;

@property (nonatomic, assign) id<FeedTableViewControllerDelegate> delegate;
@property (nonatomic, retain) EGORefreshTableHeaderView *_refreshHeaderView;

@end


@protocol FeedTableViewControllerDelegate
- (void)refreshWithFeedType:(FeedType)type;
- (void)showItem:(Feed *)anItem;
@end