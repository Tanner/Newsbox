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
#import "SettingsTableViewController_iPhone.h"
#import "SFHFKeychainUtils.h"

#define MIN_TIME_TO_REFRESH_ON_BECOME_ACTIVE 1

@interface AppDelegate_iPhone (private)
- (void)loginAndDownloadItems;
@end

@implementation AppDelegate_iPhone

#pragma mark -
#pragma mark RefreshInfoViewDelegate Methods

- (NSDate *)dataSourceLastUpdated:(id)sender {
    return lastUpdatedDate;
}

- (BOOL)isRefreshing {
    return refreshing;
}

- (RefreshInfoView *)refreshInfoView {
    return refreshInfoView;
}

- (UIBarButtonItem *)refreshInfoViewButtonItem {
    return refreshInfoViewButtonItem;
}

- (void)showItemsTableViewWithType:(ItemType)type {
    [navController pushViewController:itvc animated:YES];
}

// NSString *const TEST_GOOGLE_USER = @"newsbox.test@gmail.com";
// NSString *const TEST_PASSWORD = @"FA1w0wxjRTHRyj";

#pragma mark -
#pragma mark FeedLoaderDelegate Methods

- (void)didLogin:(BOOL)login {
	if (login) {
        [refreshInfoView animateDownload];
        
        [feedLoader getItemsOfType:[feedLoader currentItemType]];
            
        [refreshInfoView animateDownload];
        refreshing = YES;
	} else {
        [refreshInfoView stopAnimating];
        
        refreshing = NO;
    }
}

- (void)didGetItems:(NSArray *)items ofType:(ItemType)type {
	[itvc setItems:items withType:type];
    
    lastUpdatedDate = [[NSDate date] retain];
    [[NSUserDefaults standardUserDefaults] setObject:lastUpdatedDate forKey:@"LastRefresh"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [refreshInfoView stopAnimating];
    
    refreshing = NO;
}

- (void)showError:(NSString *)errorTitle withMessage:(NSString *)errorMessage withSettingsButton:(BOOL)settingsButton {
    if (settingsButton) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Settings", nil] autorelease];
        [alertView show];
    } else {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        return;
    }
    
    else if (buttonIndex == 1) {
        [self showSettingsView];
    }
}

#pragma mark -
#pragma mark FeedTableViewControllerDelegate Methods

- (void)showItem:(MWFeedItem *)anItem {
	[ivc setItem:anItem];
	[navController pushViewController:ivc animated:YES];
}

- (void)showSettingsView {
    [navController presentModalViewController:settingsNavController animated:YES];
}


#pragma mark -
#pragma mark SettingsTableViewControllerDelegate Methods

- (void)returnFromSettingsTableViewController {
    [navController dismissModalViewControllerAnimated:YES];
}

- (void)changedUsername:(NSString *)username andPassword:(NSString *)password {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:username forKey:@"GoogleUsername"];
    [prefs synchronize];
    
    NSError *error = nil;
    [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:@"Google" updateExisting:YES error:&error];
    
    [self loginAndDownloadItems];
}

#pragma mark -
#pragma mark Application lifecycle

- (void)loginAndDownloadItems {
    if (refreshing) {
        return;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *username = [prefs objectForKey:@"GoogleUsername"];
    
    if (username == nil || [username isEqualToString:@""]) {
        [self showSettingsView];
        return;
    }
    
    NSError *error = nil;
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:@"Google" error:&error];
    
    [feedLoader authenticateWithGoogleUser:username andPassword:password];
    
    [refreshInfoView animateLogin];
    refreshing = YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	feedLoader = [[ItemLoader alloc] initWithDelegate:self];
    
    rtvc = [[RootTableViewController_iPhone alloc] initWithNibName:@"RootTableViewController_iPhone" bundle:nil];
    [rtvc setDelegate:self];
    
	itvc = [[ItemsTableViewController_iPhone alloc] initWithNibName:@"ItemsTableViewController_iPhone" bundle:nil];
	[itvc setDelegate:self];
	
	ivc = [[ItemViewController_iPhone alloc] initWithNibName:@"ItemViewController_iPhone" bundle:nil];
	[ivc setDelegate:self];
	
	stvc = [[SettingsTableViewController_iPhone alloc] initWithNibName:@"SettingsTableViewController_iPhone" bundle:nil];
	[stvc setDelegate:self];
	
	navController = [[UINavigationController alloc] initWithRootViewController:rtvc];
    [rtvc.navigationItem setTitle:@"Newsbox"];
    [navController setToolbarHidden:NO];
    [navController pushViewController:itvc animated:NO];
    
    settingsNavController = [[UINavigationController alloc] initWithRootViewController:stvc];
    
    refreshInfoView = [[RefreshInfoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 44.0f)];
    [refreshInfoView setDelegate:self];
    
    refreshInfoViewButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshInfoView];
    
    lastUpdatedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastRefresh"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
	[self.window addSubview:navController.view];
    [self.window makeKeyAndVisible];
    
    [self loginAndDownloadItems];
    
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
	    
    if (abs(floor([lastUpdatedDate timeIntervalSinceNow]/60)) > MIN_TIME_TO_REFRESH_ON_BECOME_ACTIVE) {
        [self loginAndDownloadItems];
    }
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