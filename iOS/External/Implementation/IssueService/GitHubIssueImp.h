//
//  GitHubIssueImp.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubIssue.h"

@interface GitHubIssueImp : NSObject <GitHubIssue> {
  NSString *gravatar;
  float position;
  NSUInteger number;
  NSUInteger votes;
  NSDate *created;
  NSUInteger comments;
  NSString *body;
  NSString *title;
  NSDate *updated;
  NSDate *closed;
  NSString *user;
  NSArray *labels;
  GitHubIssueState state;
}

@property (copy) NSString *gravatar;
@property (assign) float position;
@property (assign) NSUInteger number;
@property (assign) NSUInteger votes;
@property (retain) NSDate *created;
@property (assign) NSUInteger comments;
@property (copy) NSString *body;
@property (copy) NSString *title;
@property (retain) NSDate *updated;
@property (retain) NSDate *closed;
@property (copy) NSString *user;
@property (retain) NSArray *labels;
@property (assign) GitHubIssueState state;

+(GitHubIssueImp *)issue;

@end
