//
//  GitHubIssue.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Enum representing the state of an issue for a repository in GitHub.
 */
typedef enum {
  GitHubIssueOpen, /**< Issue is open */
  GitHubIssueClosed /**< Issue is closed */
} GitHubIssueState;

/**
 * Protocol for a GitHub issue for a repository in GitHub.
 * See GitHub api documentation for details.
 */
@protocol GitHubIssue <NSObject>

@property (readonly, copy) NSString *gravatar;
@property (readonly, assign) float position;
@property (readonly, assign) NSUInteger number;
@property (readonly, assign) NSUInteger votes;
@property (readonly, retain) NSDate *created;
@property (readonly, assign) NSUInteger comments;
@property (readonly, copy) NSString *body;
@property (readonly, copy) NSString *title;
@property (readonly, retain) NSDate *updated;
@property (readonly, retain) NSDate *closed;
@property (readonly, copy) NSString *user;
@property (readonly, retain) NSArray *labels;
@property (readonly, assign) GitHubIssueState state;

@end
