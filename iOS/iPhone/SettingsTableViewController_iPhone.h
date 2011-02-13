//
//  SettingsTableViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/12/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>


//@protocol SettingsTableViewControllerDelegate;

@protocol SettingsTableViewControllerDelegate
- (void)returnFromSettingsTableViewController;
- (void)changedUsername:(NSString *)username andPassword:(NSString *)password;
@end



@interface SettingsTableViewController_iPhone : UITableViewController {
	id<SettingsTableViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id<SettingsTableViewControllerDelegate> delegate;

@end
