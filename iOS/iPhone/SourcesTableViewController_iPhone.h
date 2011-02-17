//
//  SourcesTableViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/17/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshInfoView.h"
#import "MWFeedInfo.h"
#import "MWFeedItem.h"

@protocol SourcesTableViewControllerDelegate
- (void)showItemsTableViewWithSource:(MWFeedInfo *)source;
@end

@interface SourcesTableViewController_iPhone : UITableViewController {
    id<SourcesTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;
    
    NSMutableArray *sources;
}

- (void)reloadData;
- (void)setSources:(NSMutableArray *)someSources withType:(ItemType)type;

@property (nonatomic, assign) id<SourcesTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;
@property (nonatomic, assign) NSMutableArray *sources;

@end
