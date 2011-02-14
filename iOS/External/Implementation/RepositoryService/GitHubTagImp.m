//
//  GitHubTagImp.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/16/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubTagImp.h"

@implementation GitHubTagImp

#pragma mark -
#pragma mark Memory and member management

//Copy
@synthesize name, sha, userName, repositoryName;

-(void)dealloc {
  
  self.name = nil;
  self.sha = nil;
  self.userName = nil;
  self.repositoryName = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark Super override implementation

-(NSString *)description {
  
  return [NSString
          stringWithFormat:@"\nSTART - GitHubTag\n"
          "Name:%@\n"
          "sha:%@\n"
          "UserName:%@\n"
          "RepositoryName:%@\n"
          "END - GitHubTag\n"
          ,
          self.name,
          self.sha,
          self.userName,
          self.repositoryName
          ];
}

-(NSComparisonResult)compare:(id<GitHubTag>)otherTag {
  
  return [self.name compare:otherTag.name];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(id<GitHubTag>)tag {
  
  return [[[GitHubTagImp alloc] init] autorelease]; 
}

@end
