//
//  FeedsTableViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshInfoView.h"
#import "ItemSupport.h"

@protocol ItemsTableViewControllerDelegate
- (void)showItemAtIndex:(int)index fromArray:(NSArray *)anArray;
@end

@interface ItemsTableViewController_iPhone : UITableViewController {
	id<ItemsTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;
    
    NSString *sourceLink;
    
    Item *currentItem;
    
    @private
    NSMutableArray *items;
}

- (void)reloadData;
- (void)reformatCellLabelsWithOrientation:(UIInterfaceOrientation)orientation;

@property (nonatomic, assign) id<ItemsTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;
@property (nonatomic, copy) NSString *sourceLink;
@property (nonatomic, assign) Item *currentItem;

@end