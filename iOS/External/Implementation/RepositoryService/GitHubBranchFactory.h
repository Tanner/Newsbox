//
//  GitHubBranchFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"
#import "GitHubServiceGotBranchDelegate.h";

@interface GitHubBranchFactory : GitHubBaseFactory {
  NSString *user;
  NSString *repository;
}

@property (retain) NSString *user;
@property (retain) NSString *repository;

-(void)requestBranchesByName:(NSString *)name user:(NSString *)user;

+(GitHubBranchFactory *)branchFactoryWithDelegate:
(id<GitHubServiceGotBranchDelegate>)delegate;

@end
