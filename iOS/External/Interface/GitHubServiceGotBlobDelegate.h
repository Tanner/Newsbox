//
//  GitHubServiceGotBlobDelegate.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceDelegate.h"
#import "GitHubBlob.h"

/**
 * Service delegate protocol used GitHub service requests returning a
 * GitHubBlob.
 */
@protocol GitHubServiceGotBlobDelegate <GitHubServiceDelegate>

/**
 * Called when the GitHub service found a GitHubBlob.
 * Will not be called if the service is cancelled using cancelRequest.
 * Will not be called after gitHubServiceDone or gitHubService:didFailWithError:
 * has been called.
 * @param gitHubService The service returning the error.
 * @param blob The GitHubBlob found by the GitHub service. 
 */
-(void)gitHubService:(id<GitHubService>)gitHubService
             gotBlob:(id<GitHubBlob>)blob;
@end
