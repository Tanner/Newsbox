//
//  AppDelegate_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"
#import "RootTableViewController_iPhone.h"
#import "ItemsTableViewController_iPhone.h"
#import "ItemViewController_iPhone.h"
#import "SettingsTableViewController_iPhone.h"
#import "RefreshInfoView.h"

@interface AppDelegate_iPhone : AppDelegate_Shared <ItemLoaderDelegate,
RootTableViewControllerDelegate,
ItemsTableViewControllerDelegate,
ItemViewControllerDelegate,
SettingsTableViewControllerDelegate,
RefreshInfoViewDelegate> {
	UINavigationController *navController;
    RootTableViewController_iPhone *rtvc;
	ItemsTableViewController_iPhone *itvc;
	ItemViewController_iPhone *ivc;
    
    UINavigationController *settingsNavController;
	SettingsTableViewController_iPhone *stvc;
    
    RefreshInfoView *refreshInfoView;
    BOOL refreshing;
    UIBarButtonItem *refreshInfoViewButtonItem;
    
    NSDate *lastUpdatedDate;
}

@end

