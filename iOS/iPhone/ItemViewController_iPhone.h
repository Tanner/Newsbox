//
//  ItemViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemSupport.h"

@protocol ItemViewControllerDelegate;

@interface ItemViewController_iPhone : UIViewController <UIWebViewDelegate> {
	@private
    id<ItemViewControllerDelegate> delegate;
    
    Item *currentItem;
    NSString *itemIdentifier;
    NSString *sourceLink;
    NSMutableArray *items;
    
	UIWebView *wv;
    UISegmentedControl *prevNextControl;
}

- (void)reloadData;
- (void)displayCurrentItem;
- (void)setIsPrevItemAvailable:(BOOL)prevItemAvailable andIsNextItemAvailable:(BOOL)nextItemAvailable;

@property (nonatomic, assign) id<ItemViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *itemIdentifier;
@property (nonatomic, copy) NSString *sourceLink;

@end

@protocol ItemViewControllerDelegate
- (void)didChangeCurrentItemTo:(Item *)item;
@end
