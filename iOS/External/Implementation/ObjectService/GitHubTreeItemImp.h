//
//  GitHubTreeItemImp.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubTreeItem.h"

@interface GitHubTreeItemImp : NSObject <GitHubTreeItem> {
  NSString *name;
  NSString *sha;
  NSString *type;
  NSString *mode;
  NSString *mime;
  NSUInteger size;
}

@property (copy) NSString *name;
@property (copy) NSString *sha;
@property (copy) NSString *type;
@property (copy) NSString *mode;
@property (copy) NSString *mime;
@property (assign) NSUInteger size;

+(id<GitHubTreeItem>)treeItem;

@end
