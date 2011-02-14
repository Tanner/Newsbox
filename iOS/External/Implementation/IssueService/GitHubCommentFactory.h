//
//  GitHubCommentFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"
#import "GitHubCommentImp.h"
#import "GitHubServiceGotCommentDelegate.h"

@interface GitHubCommentFactory : GitHubBaseFactory {
  GitHubCommentImp *comment;
}

@property (retain) GitHubCommentImp *comment;

-(void)requestCommentsForNumber:(NSUInteger)number
                           user:(NSString *)user
                     repository:(NSString *)repository;

+(GitHubCommentFactory *)commentFactoryWithDelegate:
(id<GitHubServiceGotCommentDelegate>)delegate;

@end
