//
//  GitHubIssueServiceFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#include "GitHubIssueServiceFactory.h"
#include "GitHubIssueFactory.h"
#include "GitHubCommentFactory.h"
#include "GitHubLabelFactory.h"

@implementation GitHubIssueServiceFactory

+(id<GitHubService>)
searchIssuesForTerm:(NSString *)term
state:(GitHubIssueState)state
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotIssueDelegate>)delegate {
  
  GitHubIssueFactory *service = [GitHubIssueFactory
                                 issueFactoryWithDelegate:delegate];
  
	[service searchIssuesForTerm:term
                         state:state
                          user:user
                    repository:repository];
  
	return service;
}

+(id<GitHubService>)
requestIssuesForState:(GitHubIssueState)state
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotIssueDelegate>)delegate {
  
  GitHubIssueFactory *service = [GitHubIssueFactory
                                 issueFactoryWithDelegate:delegate];
  
	[service requestIssuesForState:state user:user repository:repository];
	return service;
}

+(id<GitHubService>)
requestIssuesForLabel:(NSString *)label
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotIssueDelegate>)delegate {

  GitHubIssueFactory *service = [GitHubIssueFactory
                                   issueFactoryWithDelegate:delegate];
  
	[service requestIssuesForLabel:label user:user repository:repository];
	return service;
}

+(id<GitHubService>)
requestIssueForNumber:(NSUInteger)number
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotIssueDelegate>)delegate {
  
	GitHubIssueFactory *service = [GitHubIssueFactory
                                 issueFactoryWithDelegate:delegate];
  
	[service requestIssueForNumber:number user:user repository:repository];
	return service;
}

+(id<GitHubService>)
requestCommentsForNumber:(NSUInteger)number
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotCommentDelegate>)delegate {
  
	GitHubCommentFactory *service = [GitHubCommentFactory
                                 commentFactoryWithDelegate:delegate];
  
	[service requestCommentsForNumber:number user:user repository:repository];
	return service;
}

+(id<GitHubService>)
requestLabelsForUser:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotNameDelegate>)delegate {
  
	GitHubLabelFactory *service = [GitHubLabelFactory
                                 labelFactoryWithDelegate:delegate];
  
	[service requestLabelsForUser:user repository:repository];
	return service;
}

@end
