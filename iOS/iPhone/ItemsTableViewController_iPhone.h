//
//  FeedsTableViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshInfoView.h"
#import "Item.h"

@protocol ItemsTableViewControllerDelegate
- (void)showItem:(Item *)anItem withArray:(NSArray *)anArray;
@end

@interface ItemsTableViewController_iPhone : UITableViewController {
	id<ItemsTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;
    
    NSArray *items;
    
    Item *currentItem;
}

- (void)setItems:(NSArray *)someItems withType:(ItemType)type;
- (void)reloadData;
- (void)reformatCellLabelsWithOrientation:(UIInterfaceOrientation)orientation;

@property (nonatomic, assign) id<ItemsTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;
@property (nonatomic, assign) Item *currentItem;

@end