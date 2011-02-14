//
//  GitHubServiceGotRepositoryDelegate.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceDelegate.h"
#import "GitHubRepository.h"

/**
 * Service delegate protocol used GitHub service requests returning a
 * GitHubRepository.
 */
@protocol GitHubServiceGotRepositoryDelegate <GitHubServiceDelegate>

/**
 * Called when the GitHub service found a GitHubRepository.
 * Will not be called if the service is cancelled using cancelRequest.
 * Will not be called after gitHubServiceDone or gitHubService:didFailWithError:
 * has been called.
 * @param gitHubService The service returning the error.
 * @param repository The GitHubRepository found by the GitHub service. 
 */
-(void)gitHubService:(id<GitHubService>)gitHubService
       gotRepository:(id<GitHubRepository>)repository;

@end
