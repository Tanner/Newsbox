//
//  GitHubGotServiceIssueDelegate.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceDelegate.h"
#import "GitHubIssue.h"

/**
 * Service delegate protocol used GitHub service requests returning a
 * GitHubIssue.
 */
@protocol GitHubServiceGotIssueDelegate <GitHubServiceDelegate>

/**
 * Called when the GitHub service found a GitHubIssue.
 * Will not be called if the service is cancelled using cancelRequest.
 * Will not be called after gitHubServiceDone or gitHubService:didFailWithError:
 * has been called.
 * @param gitHubService The service returning the error.
 * @param issue The GitHubIssue found by the GitHub service. 
 */
-(void)gitHubService:(id<GitHubService>)gitHubService
            gotIssue:(id<GitHubIssue>)issue;

@end
