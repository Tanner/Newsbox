//
//  ItemViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"

@protocol ItemViewControllerDelegate;

@interface ItemViewController_iPhone : UIViewController <UIWebViewDelegate> {
	id<ItemViewControllerDelegate> delegate;
	UIWebView *wv;
    UISegmentedControl *prevNextControl;
        
    int feedItemIndex;
}

- (void)setItem:(MWFeedItem *)anItem withIndex:(int)index;
- (void)setIsPrevItemAvailable:(BOOL)prevItemAvailable andIsNextItemAvailable:(BOOL)nextItemAvailable;

@property (nonatomic, assign) id<ItemViewControllerDelegate> delegate;

@end

@protocol ItemViewControllerDelegate
- (void)showNextItemAfter:(int)index;
- (void)showPrevItemBefore:(int)index;
@end
