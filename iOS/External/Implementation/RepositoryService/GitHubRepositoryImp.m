//
//  GitHubRepositoryImp.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/4/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubRepositoryImp.h"

@implementation GitHubRepositoryImp

#pragma mark -
#pragma mark Memory and member management

//Retain
@synthesize homepage, url, creationDate, pushDate;

//Copy
@synthesize desc, name, owner;

//Assign
@synthesize watchers, hasDownloads, fork, hasWiki, hasIssues, openIssues,
private, forks;

-(void)dealloc {
  
  self.desc = nil;
  self.name = nil;
  self.url = nil;
  self.owner = nil;
  self.homepage = nil;
  self.pushDate = nil;
  self.creationDate = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark Super override implementation

-(NSString *)description {
  
  return [NSString
          stringWithFormat:@"\nSTART - GitHubRepository\n"
          "Watchers:%i\n"
          "HasDownloads:%i\n"
          "Description:%@\n"
          "Name:%@\n"
          "Fork:%i\n"
          "HasWiki:%i\n"
          "HasIssues:%i\n"
          "URL:%@\n"
          "Owner:%@\n"
          "Homepage:%@\n"
          "OpenIssues:%i\n"
          "Private:%i\n"
          "CreationDate:%@\n"
          "PushDate:%@\n"
          "Forks:%i\n"
          "END - GitHubRepository\n"
          ,
          self.watchers,
          self.hasDownloads,
          self.desc,
          self.name,
          self.fork,
          self.hasWiki,
          self.hasIssues,
          self.url,
          self.owner,
          self.homepage,
          self.openIssues,
          self.private,
          self.creationDate,
          self.pushDate,
          self.forks
          ];
}

-(NSComparisonResult)compare:(id<GitHubRepository>)otherRepository {
  
  return [self.name compare:otherRepository.name];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(id<GitHubRepository>)repository {
  
  return [[[GitHubRepositoryImp alloc] init] autorelease]; 
}

@end
