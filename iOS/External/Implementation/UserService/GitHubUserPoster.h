//
//  GitHubUserPoster.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 11/6/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"

@interface GitHubUserPoster : GitHubBaseFactory {
}

-(void)followUser:(NSString *)name;
-(void)unfollowUser:(NSString *)name;

+(GitHubUserPoster *)userPosterWithDelegate:
(id<GitHubServiceDelegate>)delegate;

@end
