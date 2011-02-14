//
//  GitHubComment.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Protocol for a comment on an issue for a repository in GitHub.
 * See GitHub api documentation for details.
 */
@protocol GitHubComment <NSObject>

@property (readonly, copy) NSString *gravatar;
@property (readonly, retain) NSDate *created;
@property (readonly, copy) NSString *body;
@property (readonly, retain) NSDate *updated;
@property (readonly, assign) NSUInteger commentId;
@property (readonly, copy) NSString *user;

@end
