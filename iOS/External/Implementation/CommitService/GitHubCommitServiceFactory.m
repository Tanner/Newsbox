//
//  GitHubCommitServiceFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright (c) 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubCommitServiceFactory.h"
#import "GitHubCommitFactory.h"

@implementation GitHubCommitServiceFactory

+(id<GitHubService>)requestCommitsOnBranch:(NSString *)branch
                                repository:(NSString *)repository
                                      user:(NSString *)user
delegate:(id<GitHubServiceGotCommitDelegate>)delegate {
  
	GitHubCommitFactory *service = [GitHubCommitFactory
                                  commitFactoryWithDelegate:delegate];
  
	[service requestCommitsOnBranch:branch repository:repository user:user];
	return service;
}

+(id<GitHubService>)requestCommitsOnBranch:(NSString *)branch
                                      path:(NSString *)path
                                repository:(NSString *)repository
                                      user:(NSString *)user
delegate:(id<GitHubServiceGotCommitDelegate>)delegate {
  
	GitHubCommitFactory *service = [GitHubCommitFactory
                                  commitFactoryWithDelegate:delegate];
  
	[service requestCommitsOnBranch:branch
                             path:path
                       repository:repository
                             user:user];
	return service;
}

+(id<GitHubService>)requestCommitBySha:(NSString *)sha
                       repository:(NSString *)repository
                             user:(NSString *)user
delegate:(id<GitHubServiceGotCommitDelegate>)delegate {
  
	GitHubCommitFactory *service = [GitHubCommitFactory
                                  commitFactoryWithDelegate:delegate];
  
	[service requestCommitBySha:sha repository:repository user:user];
	return service;
}

@end
