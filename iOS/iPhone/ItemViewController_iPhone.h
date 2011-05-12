//
//  ItemViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@protocol ItemViewControllerDelegate;

@interface ItemViewController_iPhone : UIViewController <UIWebViewDelegate> {
	id<ItemViewControllerDelegate> delegate;
    
    NSMutableArray *array;
    Item *currentItem;
    
	UIWebView *wv;
    UISegmentedControl *prevNextControl;
}

- (void)displayCurrentItem;
- (void)setItem:(Item *)anItem withArray:(NSMutableArray *)anArray;
- (void)setIsPrevItemAvailable:(BOOL)prevItemAvailable andIsNextItemAvailable:(BOOL)nextItemAvailable;

@property (nonatomic, assign) id<ItemViewControllerDelegate> delegate;

@end

@protocol ItemViewControllerDelegate
- (void)didChangeCurrentItemTo:(Item *)item;
@end
