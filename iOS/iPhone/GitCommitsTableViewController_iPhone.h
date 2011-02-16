//
//  GitCommitsTableViewController_iPhone.h
//  NewsBox
//
//  Created by Tanner Smith on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GitHubServiceGotCommitDelegate.h"

@interface GitCommitsTableViewController_iPhone : UITableViewController <GitHubServiceGotCommitDelegate> {
    NSMutableArray *commits;
    BOOL foundBuild;
}

@end
