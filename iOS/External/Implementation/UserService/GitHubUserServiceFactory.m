//
//  GitHubUserServiceFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright (c) 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubUserServiceFactory.h"
#import "GitHubUserFactory.h"
#import "GitHubUserPoster.h"
#import "GitHubUserNameFactory.h"
#import "GitHubUserSearchFactory.h"

@implementation GitHubUserServiceFactory

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(id<GitHubService>)requestUserByName:(NSString *)name
delegate:(id<GitHubServiceGotUserDelegate>)delegate {
  
	GitHubUserFactory *service = [GitHubUserFactory
                                userFactoryWithDelegate:delegate];
  
	[service requestUserByName:name];
	return service;
}

+(id<GitHubService>)requestUserByEmail:(NSString *)email
delegate:(id<GitHubServiceGotUserDelegate>)delegate {
  
	GitHubUserFactory *service = [GitHubUserFactory
                                userFactoryWithDelegate:delegate];
  
	[service requestUserByEmail:email];
	return service;
}

+(id<GitHubService>)requestFollowersOfUser:(NSString *)name
delegate:(id<GitHubServiceGotNameDelegate>)delegate {
  
	GitHubUserNameFactory *service = [GitHubUserNameFactory
                                    userNameFactoryWithDelegate:delegate];
  
	[service requestFollowersOfUser:name];
	return service;
}

+(id<GitHubService>)requestLeadersByUser:(NSString *)name
delegate:(id<GitHubServiceGotNameDelegate>)delegate {
  
	GitHubUserNameFactory *service = [GitHubUserNameFactory
                                  userNameFactoryWithDelegate:delegate];
  
	[service requestLeadersOfUser:name];
	return service;
}

+(id<GitHubService>)searchUsersByName:(NSString *)name
delegate:(id<GitHubServiceGotNameDelegate>)delegate {
  
	GitHubUserSearchFactory *service = [GitHubUserSearchFactory
                                      userSearchFactoryWithDelegate:delegate];
  
	[service searchUsersByName:name];
	return service;
}

+(id<GitHubService>)requestUserWithDelegate:
(id<GitHubServiceGotUserDelegate>)delegate {
  
	GitHubUserFactory *service = [GitHubUserFactory
                                userFactoryWithDelegate:delegate];
  
	[service requestUser];
	return service;
}

+(id<GitHubService>)followUser:(NSString *)name
                      delegate:(id<GitHubServiceDelegate>)delegate {
  
  
	GitHubUserPoster *service = [GitHubUserPoster
                                userPosterWithDelegate:delegate];
  
	[service followUser:name];
	return service;
}


+(id<GitHubService>)unfollowUser:(NSString *)name
                        delegate:(id<GitHubServiceDelegate>)delegate {
  
	GitHubUserPoster *service = [GitHubUserPoster
                               userPosterWithDelegate:delegate];
  
	[service unfollowUser:name];
	return service;
}

@end
