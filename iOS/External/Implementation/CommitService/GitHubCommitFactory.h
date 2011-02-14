//
//  GitHubCommitFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"
#import "GitHubCommitImp.h"

@protocol GitHubServiceGotCommitDelegate;

@interface GitHubCommitFactory : GitHubBaseFactory {
  GitHubCommitImp *commit;
  BOOL author;
  BOOL committer;
  NSMutableArray *parents;
  NSMutableArray *removed;
  NSMutableArray *added;
  NSMutableArray *modified;
  NSMutableArray *modifiedDiff;
  BOOL inAdded;
  BOOL inModified;
  BOOL inRemoved;
}

@property (retain) GitHubCommitImp *commit;
@property (assign) BOOL author;
@property (assign) BOOL committer;
@property (retain) NSMutableArray *parents;
@property (retain) NSMutableArray *removed;
@property (retain) NSMutableArray *added;
@property (retain) NSMutableArray *modified;
@property (retain) NSMutableArray *modifiedDiff;
@property (assign) BOOL inAdded;
@property (assign) BOOL inModified;
@property (assign) BOOL inRemoved;

-(void)requestCommitsOnBranch:(NSString *)branch
                   repository:(NSString *)repository
                         user:(NSString *)user;

-(void)requestCommitsOnBranch:(NSString *)branch
                         path:(NSString *)path
                   repository:(NSString *)repository
                         user:(NSString *)user;

-(void)requestCommitBySha:(NSString *)sha
               repository:(NSString *)repository
                     user:(NSString *)user;

+(GitHubCommitFactory *)commitFactoryWithDelegate:
(id<GitHubServiceGotCommitDelegate>)delegate;

@end
