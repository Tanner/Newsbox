//
//  FeedsTableViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshInfoView.h"
#import "MWFeedItem.h"

@protocol ItemsTableViewControllerDelegate
- (void)loginAndDownloadItems;
- (void)showItem:(MWFeedItem *)anItem withArray:(NSMutableArray *)anArray;
@end

@interface ItemsTableViewController_iPhone : UITableViewController {
	id<ItemsTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;
    
    NSMutableArray *items;
}

- (void)setItems:(NSMutableArray *)someItems withType:(ItemType)type;
- (void)reloadData;
- (void)reformatCellLabelsWithOrientation:(UIInterfaceOrientation)orientation;

@property (nonatomic, assign) id<ItemsTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;

@end