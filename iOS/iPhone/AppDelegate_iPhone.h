//
//  AppDelegate_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"
#import "FeedsTableViewController_iPhone.h"
#import "ItemViewController_iPhone.h"

@interface AppDelegate_iPhone : AppDelegate_Shared <FeedLoaderDelegate, FeedTableViewControllerDelegate, ItemViewControllerDelegate> {
	UINavigationController *navController;
	FeedsTableViewController_iPhone *ftvc;
	ItemViewController_iPhone *ivc;
}


@end

