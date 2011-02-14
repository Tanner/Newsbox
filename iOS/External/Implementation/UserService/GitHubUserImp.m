//
//  GitHubUserImp.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/1/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubUserImp.h"

@implementation GitHubUserImp

#pragma mark -
#pragma mark Memory and member management

//Copy
@synthesize gravatarId, company, email, name, login, location, ID, type;

//Retain
@synthesize blog, creationDate;

//Assign
@synthesize publicGistCount, publicRepoCount, followersCount, followingCount;

-(void)dealloc {
  self.location = nil;
  self.name = nil;
  self.login = nil;
  self.email = nil;
  self.blog = nil;
  self.company = nil;
  self.gravatarId = nil;
  self.creationDate = nil;
  self.ID = nil;
  self.type = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark Super override implementation

-(NSString *)description {
  return [NSString
          stringWithFormat:@"\nSTART - GitHubUser\n"
          "Name:%@\n"
          "Company:%@\n"
          "Location:%@\n"
          "Login:%@\n"
          "eMail:%@\n"
          "Blog:%@\n"
          "GravatarId:%@\n"
          "PublicGistCount:%i\n"
          "PublicRepoCount:%i\n"
          "FollowersCount:%i\n"
          "FollowingCount:%i\n"
          "CreationDate:%@\n"
          "ID:%@\n"
          "Type:%@\n"
          "END - GitHubUser\n",
          self.name,
          self.company,
          self.location,
          self.login,
          self.email,
          self.blog,
          self.gravatarId,
          self.publicGistCount,
          self.publicRepoCount,
          self.followersCount,
          self.followingCount,
          self.creationDate,
          self.ID,
          self.type];
}

-(NSComparisonResult)compare:(id<GitHubUser>)otherUser {
  return [self.login compare:otherUser.login];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(id<GitHubUser>)user {
  return [[[GitHubUserImp alloc] init] autorelease]; 
}

@end
