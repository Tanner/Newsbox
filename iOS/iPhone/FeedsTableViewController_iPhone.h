//
//  FeedsTableViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeedsTableViewController_iPhone : UITableViewController {
	NSMutableArray *feeds;
}

- (void)setFeeds:(NSArray *)aFeeds;

@end
