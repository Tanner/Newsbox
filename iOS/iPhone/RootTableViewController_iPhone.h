//
//  RootTableViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/13/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"
#import "RefreshInfoView.h"

@protocol RootTableViewControllerDelegate
- (void)refresh;
- (void)showItemsTableViewWithType:(ItemType)type;
- (void)showSettingsView;
- (RefreshInfoView *)refreshInfoView;
@end


@interface RootTableViewController_iPhone : UITableViewController {
    id <RootTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;
}

@property (nonatomic, assign) id<RootTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;

@end