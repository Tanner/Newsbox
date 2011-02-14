//
//  GitHubRepository.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/4/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Protocol for a git repository in GitHub.
 * See GitHub api documentation for details.
 */
@protocol GitHubRepository <NSObject>

@property (readonly, assign) int watchers;
@property (readonly, assign) BOOL hasDownloads;
@property (readonly, copy) NSString *desc;
@property (readonly, copy) NSString *name;
@property (readonly, assign) BOOL fork;
@property (readonly, assign) BOOL hasWiki;
@property (readonly, assign) BOOL hasIssues;
@property (readonly, retain) NSURL *url;
@property (readonly, copy) NSString *owner;
@property (readonly, retain) NSURL *homepage;
@property (readonly, assign) int openIssues;
@property (readonly, assign) BOOL private;
@property (readonly, retain) NSDate *creationDate;
@property (readonly, retain) NSDate *pushDate;
@property (readonly, assign) int forks;

@end
