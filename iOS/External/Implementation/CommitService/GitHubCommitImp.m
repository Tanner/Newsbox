//
//  GitHubCommitImp.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/16/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubCommitImp.h"

@implementation GitHubCommitImp

#pragma mark -
#pragma mark Memory and member management

//Retain
@synthesize parents, url, authoredDate, committedDate, added, modified, removed,
modifiedDiff; 

//Copy
@synthesize authorName, authorEmail, authorLogin, committerName, committerEmail,
committerLogin, sha, tree, message;

-(void)dealloc {
  
  self.parents = nil;
  self.authorName = nil;
  self.authorEmail = nil;
  self.authorLogin = nil;
  self.url = nil;
  self.sha = nil;
  self.committedDate = nil;
  self.authoredDate = nil;
  self.tree = nil;
  self.committerName = nil;
  self.committerLogin = nil;
  self.committerEmail = nil;
  self.message = nil;
  self.added = nil;
  self.modified = nil;
  self.modifiedDiff = nil;
  self.removed = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark Super override implementation

-(NSString *)description {
  
  NSMutableString *parentsString = [NSMutableString string];
  
  for (NSString *parent in self.parents) {
    
    [parentsString appendFormat:@"%@, ", parent];
  }
  return [NSString
          stringWithFormat:@"\nSTART - GitHubCommit\n"
          "Parents:%@\n"
          "AuthorName:%@\n"
          "AuthorEmail:%@\n"
          "AuthorLogin:%@\n"
          "URL:%@\n"
          "Sha:%@\n"
          "CommitedDate:%@\n"
          "AuthoredDate:%@\n"
          "Tree:%@\n"
          "CommitterName:%@\n"
          "CommitterEmail:%@\n"
          "CommitterLogin:%@\n"
          "Message:%@\n"
          "END - GitHubCommit\n",
          parentsString,
          self.authorName,
          self.authorEmail,
          self.authorLogin,
          self.url,
          self.sha,
          self.committedDate,
          self.authoredDate,
          self.tree,
          self.committerName,
          self.committerEmail,
          self.committerLogin,
          self.message];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(id<GitHubCommit>)commit {
  
  return [[[GitHubCommitImp alloc] init] autorelease];
}

@end
