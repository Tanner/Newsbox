//
//  GitHubIssueFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"
#import "GitHubIssueImp.h"
#import "GitHubServiceGotIssueDelegate.h"

@interface GitHubIssueFactory : GitHubBaseFactory {
  GitHubIssueImp *issue;
  NSMutableArray *labels;
  BOOL inLabel;
}

@property (retain) GitHubIssueImp *issue;
@property (retain) NSMutableArray *labels;
@property (assign) BOOL inLabel;

-(void)searchIssuesForTerm:(NSString *)term
                     state:(GitHubIssueState)state
                      user:(NSString *)user
                repository:(NSString *)repository;

-(void)requestIssuesForState:(GitHubIssueState)state
                        user:(NSString *)user
                  repository:(NSString *)repository;

-(void)requestIssuesForLabel:(NSString *)label
                        user:(NSString *)user
                  repository:(NSString *)repository;

-(void)requestIssueForNumber:(NSUInteger)number
                        user:(NSString *)user
                  repository:(NSString *)repository;


+(GitHubIssueFactory *)issueFactoryWithDelegate:
(id<GitHubServiceGotIssueDelegate>)delegate;

@end
