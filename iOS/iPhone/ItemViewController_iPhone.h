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
	UIWebView *wv;
}


- (void)setItem:(Item *)anItem;


@property (nonatomic, assign) id<ItemViewControllerDelegate> delegate;


@end


@protocol ItemViewControllerDelegate

@end
