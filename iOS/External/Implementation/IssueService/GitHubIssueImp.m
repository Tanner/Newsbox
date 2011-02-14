//
//  GitHubIssueImp.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubIssueImp.h"

@implementation GitHubIssueImp

#pragma mark -
#pragma mark Memory and member management

//Copy
@synthesize gravatar, body, title, user;

//Retain
@synthesize created, updated, closed, labels;

//Assign
@synthesize position, number, votes, comments, state;

-(void)dealloc {
  
  self.gravatar = nil;
  self.body = nil;
  self.title = nil;
  self.user = nil;
  self.created = nil;
  self.updated = nil;
  self.closed = nil;
  self.labels = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubIssueImp *)issue {

  return [[[GitHubIssueImp alloc] init] autorelease];
}

@end
