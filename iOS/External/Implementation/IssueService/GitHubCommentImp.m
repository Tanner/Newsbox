//
//  GitHubCommentImp.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubCommentImp.h"

@implementation GitHubCommentImp

#pragma mark -
#pragma mark Memory and member management

//Copy
@synthesize gravatar, body, user;

//Retain
@synthesize created, updated;

//Assign
@synthesize commentId;

-(void)dealloc {
  
  self.gravatar = nil;
  self.body = nil;
  self.user = nil;
  self.created = nil;
  self.updated = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubCommentImp *)comment {
  
  return [[[GitHubCommentImp alloc] init] autorelease];
}

@end
