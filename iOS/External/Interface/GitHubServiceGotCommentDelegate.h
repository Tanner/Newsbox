//
//  GitHubServiceGotCommentDelegate.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceDelegate.h"
#import "GitHubComment.h"

/**
 * Service delegate protocol used GitHub service requests returning a
 * GitHubComment.
 */
@protocol GitHubServiceGotCommentDelegate <GitHubServiceDelegate>

/**
 * Called when the GitHub service found a GitHubComment.
 * Will not be called if the service is cancelled using cancelRequest.
 * Will not be called after gitHubServiceDone or gitHubService:didFailWithError:
 * has been called.
 * @param gitHubService The service returning the error.
 * @param comment The GitHubComment found by the GitHub service. 
 */
-(void)gitHubService:(id<GitHubService>)gitHubService
          gotComment:(id<GitHubComment>)comment;

@end
