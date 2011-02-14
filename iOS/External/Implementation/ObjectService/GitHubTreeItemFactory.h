//
//  GitHubTreeItemFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"
#import "GitHubTreeItemImp.h"
#import "GitHubServiceGotTreeItemDelegate.h"

@interface GitHubTreeItemFactory : GitHubBaseFactory {
  GitHubTreeItemImp *treeItem;
}

@property (retain) GitHubTreeItemImp *treeItem;

+(GitHubTreeItemFactory *)treeItemFactoryWithDelegate:
(id<GitHubServiceGotTreeItemDelegate>)delegate;

-(void)requestTreeItemsByTreeSha:(NSString *)sha
                            user:(NSString *)user
                      repository:(NSString *)repository;

@end
