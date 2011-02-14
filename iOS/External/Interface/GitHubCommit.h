//
//  GitHubCommit.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/16/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Protocol for a git commit in GitHub.
 * See GitHub api documentation for details.
 */
@protocol GitHubCommit <NSObject>

@property (readonly, retain) NSArray *parents;
@property (readonly, copy) NSString *authorName;
@property (readonly, copy) NSString *authorEmail;
@property (readonly, copy) NSString *authorLogin;
@property (readonly, retain) NSURL *url;
@property (readonly, copy) NSString *sha;
@property (readonly, retain) NSDate *committedDate;
@property (readonly, retain) NSDate *authoredDate;
@property (readonly, copy) NSString *tree;
@property (readonly, copy) NSString *committerName;
@property (readonly, copy) NSString *committerLogin;
@property (readonly, copy) NSString *committerEmail;
@property (readonly, copy) NSString *message;
@property (readonly, retain) NSArray *added;
@property (readonly, retain) NSArray *modified;
@property (readonly, retain) NSArray *modifiedDiff;
@property (readonly, retain) NSArray *removed;

@end
