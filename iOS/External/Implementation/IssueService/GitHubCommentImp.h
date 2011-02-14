//
//  GitHubCommentImp.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubComment.h"

@interface GitHubCommentImp : NSObject <GitHubComment> {
  NSString *gravatar;
  NSDate *created;
  NSString *body;
  NSDate *updated;
  NSUInteger commentId;
  NSString *user;
}

@property (copy) NSString *gravatar;
@property (retain) NSDate *created;
@property (copy) NSString *body;
@property (retain) NSDate *updated;
@property (assign) NSUInteger commentId;
@property (copy) NSString *user;

+(GitHubCommentImp *)comment;

@end
