//
//  GitHubObjectServiceFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubObjectServiceFactory.h"
#import "GitHubTreeItemFactory.h"
#import "GitHubBlobFactory.h"
#import "GitHubDataFactory.h"

@implementation GitHubObjectServiceFactory

+(id<GitHubService>)
requestTreeItemsByTreeSha:(NSString *)sha
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotTreeItemDelegate>)delegate {

  GitHubTreeItemFactory *service = [GitHubTreeItemFactory
                                  treeItemFactoryWithDelegate:delegate];
  
	[service requestTreeItemsByTreeSha:sha user:user repository:repository];
	return service;
}

+(id<GitHubService>)
requestBlobByTreeSha:(NSString *)sha
user:(NSString *)user
repository:(NSString *)repository
path:(NSString *)path
delegate:(id<GitHubServiceGotBlobDelegate>)delegate {
  
  GitHubBlobFactory *service = [GitHubBlobFactory
                                blobFactoryWithDelegate:delegate];
  
	[service requestBlobByTreeSha:sha user:user repository:repository path:path];
	return service;
}

+(id<GitHubService>)
requestBlobWithDataByTreeSha:(NSString *)sha
user:(NSString *)user
repository:(NSString *)repository
path:(NSString *)path
delegate:(id<GitHubServiceGotBlobDelegate>)delegate {
  
  GitHubBlobFactory *service = [GitHubBlobFactory
                                blobFactoryWithDelegate:delegate];
  
	[service requestBlobWithDataByTreeSha:sha
                                   user:user
                             repository:repository
                                   path:path];
  
	return service;
}

+(id<GitHubService>)
requestDataBySha:(NSString *)sha
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotDataDelegate>)delegate {

  GitHubDataFactory *service = [GitHubDataFactory
                                dataFactoryWithDelegate:delegate];
  
	[service requestDataBySha:sha user:user repository:repository];
	return service;
}

@end
