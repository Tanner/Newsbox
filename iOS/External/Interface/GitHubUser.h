//
//  GitHubUser.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 9/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Protocol for a GitHub user in GitHub.
 * See GitHub api documentation for details.
 */
@protocol GitHubUser <NSObject>

@property (readonly, copy) NSString *location;
@property (readonly, copy) NSString *name;
@property (readonly, copy) NSString *login;
@property (readonly, copy) NSString *email;
@property (readonly, retain) NSURL *blog;
@property (readonly, copy) NSString *company;
@property (readonly, copy) NSString *gravatarId;
@property (readonly, assign) int publicRepoCount;
@property (readonly, assign) int publicGistCount;
@property (readonly, assign) int followersCount;
@property (readonly, assign) int followingCount;
@property (readonly, retain) NSDate *creationDate;
@property (readonly, copy) NSString *ID;
@property (readonly, copy) NSString *type;

-(NSComparisonResult)compare:(id<GitHubUser>)otherUser;

@end
