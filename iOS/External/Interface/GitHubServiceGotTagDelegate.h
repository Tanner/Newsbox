//
//  GitHubServiceGotTagDelegate.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceDelegate.h"
#import "GitHubTag.h"

/**
 * Service delegate protocol used GitHub service requests returning a
 * GitHubTag.
 */
@protocol GitHubServiceGotTagDelegate <GitHubServiceDelegate>

/**
 * Called when the GitHub service found a GitHubTag.
 * Will not be called if the service is cancelled using cancelRequest.
 * Will not be called after gitHubServiceDone or gitHubService:didFailWithError:
 * has been called.
 * @param gitHubService The service returning the error.
 * @param tag The GitHubTag found by the GitHub service. 
 */
-(void)gitHubService:(id<GitHubService>)gitHubService
              gotTag:(id<GitHubTag>)tag;

@end
