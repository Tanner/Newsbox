//
//  AppDelegate_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"
#import "ItemsTableViewController_iPhone.h"
#import "ItemViewController_iPhone.h"
#import "SettingsTableViewController_iPhone.h"

@interface AppDelegate_iPhone : AppDelegate_Shared <ItemLoaderDelegate,
ItemsTableViewControllerDelegate,
ItemViewControllerDelegate,
SettingsTableViewControllerDelegate> {
	UINavigationController *navController;
	ItemsTableViewController_iPhone *itvc;
	ItemViewController_iPhone *ivc;
    
    UINavigationController *settingsNavController;
	SettingsTableViewController_iPhone *stvc;
}


@end

