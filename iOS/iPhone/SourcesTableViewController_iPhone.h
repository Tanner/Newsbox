//
//  SourcesTableViewController_iPhone.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/17/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshInfoView.h"
#import "Source.h"
#import "ItemSupport.h"

@protocol SourcesTableViewControllerDelegate
- (void)showItemsTableViewWithSourceLink:(NSString *)sourceLink;
@end

@interface SourcesTableViewController_iPhone : UITableViewController {
    id<SourcesTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;
    
    NSMutableArray *sources;
}

- (void)reloadData;

@property (nonatomic, assign) id<SourcesTableViewControllerDelegate, RefreshInfoViewDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *sources;

@end
