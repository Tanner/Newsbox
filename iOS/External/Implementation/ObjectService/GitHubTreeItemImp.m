//
//  GitHubTreeItemImp.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubTreeItemImp.h"

@implementation GitHubTreeItemImp

#pragma mark -
#pragma mark Memory and member management
 
//Copy
@synthesize name, sha, type, mode, mime;

//Assign
@synthesize size;

-(void)dealloc {
  
  self.name = nil;
  self.sha = nil;
  self.type = nil;
  self.mode = nil;
  self.mime = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(id<GitHubTreeItem>)treeItem {
  
  return [[[GitHubTreeItemImp alloc] init] autorelease]; 
}


@end
