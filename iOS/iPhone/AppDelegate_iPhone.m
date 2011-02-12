//
//  AppDelegate_iPhone.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "ItemLoader.h"
#import "MWFeedItem.h"
#import "ItemsTableViewController_iPhone.h"


@implementation AppDelegate_iPhone


NSString *const TEST_GOOGLE_USER = @"newsbox.test@gmail.com";
NSString *const TEST_PASSWORD = @"FA1w0wxjRTHRyj";


- (void)didLogin:(BOOL)login {
	if (login) {
		[feedLoader getItemsOfType:ItemTypeUnread];
	}
}


- (void)didGetItems:(NSArray *)items ofType:(ItemType)type {
	[itvc setItems:items withType:type];
}


- (void)showItem:(MWFeedItem *)anItem {
	[ivc setItem:anItem];
	[navController pushViewController:ivc animated:YES];
}


#pragma mark -
#pragma mark FeedTableViewControllerDelegate Methods


- (void)refreshWithItemType:(ItemType)type {
	[feedLoader getItemsOfType:type];
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	feedLoader = [[ItemLoader alloc] initWithDelegate:self];
		
	itvc = [[ItemsTableViewController_iPhone alloc] initWithNibName:@"ItemsTableViewController_iPhone" bundle:nil];
	[itvc setDelegate:self];
	
	ivc = [[ItemViewController_iPhone alloc] initWithNibName:@"ItemViewController_iPhone" bundle:nil];
	[ivc setDelegate:self];
	
	navController = [[UINavigationController alloc] initWithRootViewController:itvc];
		
	[self.window addSubview:navController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.

     Superclass implementation saves changes in the application's managed object context before the application terminates.
     */
		
	[super applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	
	if (![feedLoader authenticated]) {
		[feedLoader authenticateWithGoogleUser:TEST_GOOGLE_USER andPassword:TEST_PASSWORD];
	} else {
		[feedLoader getItemsOfType:[feedLoader currentItemType]];
	}
	
	[itvc reformatCellLabelsWithOrientation:[[UIDevice currentDevice] orientation]];
}


/**
 Superclass implementation saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[super applicationWillTerminate:application];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    [super applicationDidReceiveMemoryWarning:application];
}


- (void)dealloc {
	
	[super dealloc];
}


@end

