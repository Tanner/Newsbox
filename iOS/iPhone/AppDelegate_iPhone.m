//
//  AppDelegate_iPhone.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "ItemLoader.h"
#import "ItemSupport.h"
#import "ItemsTableViewController_iPhone.h"
#import "SettingsTableViewController_iPhone.h"
#import "SFHFKeychainUtils.h"
#import "Algorithm.h"

#define MIN_TIME_TO_REFRESH_ON_BECOME_ACTIVE 1

@interface AppDelegate_iPhone (private)
- (void)reloadViewControllers;
- (void)loginAndDownloadItems;
- (void)purgeAllSourcesAndItems;
- (void)purgeReadSourcesAndItems;
@end

@implementation AppDelegate_iPhone

@synthesize needsPurge;

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

- (UIBarButtonItem *)refreshButtonItem {
    return refreshButtonItem;
}

- (UIBarButtonItem *)refreshInfoViewButtonItem {
    return refreshInfoViewButtonItem;
}

#pragma mark - 
#pragma mark Purging

- (void)purgeAllSourcesAndItems {
    // Remove all sources that have no items
    NSFetchRequest *fetchRequest = [[self managedObjectModel]
                    fetchRequestTemplateForName:@"allSources"];
    NSArray *executedRequest = [[self loadingManagedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    if (executedRequest) {
        for (Source *source in executedRequest) {
            [[self loadingManagedObjectContext] deleteObject:source];
        }
    }
    
    // Save context!
    [self saveLoadingContext];
    [self saveContext];
    
    // Update GUI
    [self reloadViewControllers];
}

- (void)purgeReadSourcesAndItems {
    // Git rid of items that are not to be kept
    NSFetchRequest *fetchRequest = [[self managedObjectModel]
                                    fetchRequestTemplateForName:@"itemsToNotKeep"];
    NSArray *executedRequest = [[self loadingManagedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    if (executedRequest) {
        for (Item *item in executedRequest) {
            [[self loadingManagedObjectContext] deleteObject:item];
        }
    }
    
    // Remove all sources that have no items
    fetchRequest = [[self managedObjectModel]
                                    fetchRequestTemplateForName:@"allSources"];
    executedRequest = [[self loadingManagedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    if (executedRequest) {
        for (Source *source in executedRequest) {
            if ([source.items count] == 0) {
                [[self loadingManagedObjectContext] deleteObject:source];
            }
        }
    }
    
    // Set all items to not be kept for next refresh
    fetchRequest = [[self managedObjectModel]
                    fetchRequestTemplateForName:@"allItems"];
    executedRequest = [[self loadingManagedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    if (executedRequest) {
        for (Item *item in executedRequest) {
            [item setKeep:[NSNumber numberWithBool:NO]];
        }
    }
    
    // Save context!
    [self saveLoadingContext];
    [self saveContext];
    
    // Update GUI
    [self reloadViewControllers];
}

#pragma mark -
#pragma mark RootTableViewControllerDelegate Methods

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
    
    [itemLoader authenticateWithGoogleUser:username andPassword:password];
    
    [refreshInfoView animateLogin];
    refreshing = YES;
}

- (void)showSourcesTableViewWithType:(ItemType)type {    
    [navController pushViewController:stvc animated:YES];
}

- (void)showSettingsView {    
    [navController presentModalViewController:settingsNavController animated:YES];
}

- (void)rootViewDidAppear {
    if (needsPurge) {
        [self purgeReadSourcesAndItems];
        needsPurge = NO;
    }
}

#pragma mark -
#pragma mark SourcesTableViewControllerDelegate Methods

- (void)showItemsTableViewWithSourceLink:(NSString *)sourceLink {
    [itvc setSourceLink:sourceLink];
    
    [navController pushViewController:itvc animated:YES];
}

#pragma mark -
#pragma mark FeedLoaderDelegate Methods

- (void)didLogin:(BOOL)login {
	if (login) {
        [refreshInfoView animateDownload];
        
        [itemLoader getItemsOfType:[itemLoader currentItemType]];
        
        refreshing = YES;
	} else {
        [refreshInfoView stopAnimating];
        
        refreshing = NO;
    }
}

- (void)didLoadSourcesAndItems {
    // last updated date
    if (lastUpdatedDate) {
        [lastUpdatedDate release];
    }
    lastUpdatedDate = [[NSDate date] retain];
    [[NSUserDefaults standardUserDefaults] setObject:lastUpdatedDate forKey:@"LastRefresh"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // refresh info view
    [refreshInfoView stopAnimating];
    refreshing = NO;
        
    if ([navController visibleViewController] == rtvc) {
        [self purgeReadSourcesAndItems];
    } else {
        needsPurge = YES;
    }
    
	// create topics
	[Algorithm clusterItems];

    [self saveLoadingContext];
    [self saveContext];
    
    [self reloadViewControllers];
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

- (void)showParsing  {
    [refreshInfoView animateParse];
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
#pragma mark ViewController Methods

- (void)reloadViewControllers {
    if ([[navController viewControllers] containsObject:stvc]) {
        [stvc reloadData];
    }
    if ([[navController viewControllers] containsObject:itvc]) {
        [itvc reloadData];
    }
    if ([[navController viewControllers] containsObject:ivc]) {
        [ivc reloadData];
    }
}

#pragma mark -
#pragma mark ItemsTableViewControllerDelegate Methods

- (void)showItemWithIdentifier:(NSString *)itemIdentifier fromSource:(NSString *)sourceLink {
	[ivc setItemIdentifier:itemIdentifier];
    [ivc setSourceLink:sourceLink];
    
	[navController pushViewController:ivc animated:YES];
}

#pragma mark -
#pragma mark ItemViewControllerDelegate Methods

- (void)didChangeCurrentItemTo:(Item *)item {
    [itvc setCurrentItem:item];
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
    
    [self purgeAllSourcesAndItems];
    
    [self loginAndDownloadItems];
}

- (void)showGitCommits {
    [settingsNavController pushViewController:gitTableViewController animated:YES];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	itemLoader = [[ItemLoader alloc] initWithDelegate:self];
    
    // Refresh
    refreshInfoView = [[RefreshInfoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 44.0f)];
    [refreshInfoView setDelegate:self];
    
    refreshButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loginAndDownloadItems)];
    refreshInfoViewButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshInfoView];
    
    lastUpdatedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastRefresh"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // View Controllers
    rtvc = [[RootTableViewController_iPhone alloc] initWithNibName:@"RootTableViewController_iPhone" bundle:nil];
    [rtvc setDelegate:self];
    
	itvc = [[ItemsTableViewController_iPhone alloc] initWithNibName:@"ItemsTableViewController_iPhone" bundle:nil];
	[itvc setDelegate:self];
	
	ivc = [[ItemViewController_iPhone alloc] initWithNibName:@"ItemViewController_iPhone" bundle:nil];
	[ivc setDelegate:self];
    
    stvc = [[SourcesTableViewController_iPhone alloc] initWithNibName:@"SourcesTableViewController_iPhone" bundle:nil];
    [stvc setDelegate:self];
	
	navController = [[UINavigationController alloc] initWithRootViewController:rtvc];
    [rtvc.navigationItem setTitle:@"Newsbox"];
    [navController setToolbarHidden:NO];
    [navController.navigationBar setTintColor:[UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0]];
    [navController.toolbar setTintColor:[UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0]];
    
    // settings
    settingsTableViewController = [[SettingsTableViewController_iPhone alloc] initWithNibName:@"SettingsTableViewController_iPhone" bundle:nil];
	[settingsTableViewController setDelegate:self];

    gitTableViewController = [[GitCommitsTableViewController_iPhone alloc] initWithNibName:@"GitCommitsTableViewController_iPhone" bundle:nil];
    
    settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsTableViewController];
    
    // window
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