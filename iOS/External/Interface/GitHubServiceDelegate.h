//
//  GitHubServiceDelegate.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright (c) 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubService.h"

/**
 * Service delegate protocol used by all GitHub services to return data
 * asyncronosly.
 */
@protocol GitHubServiceDelegate <NSObject>

/**
 * Called if an error occurs in the GitHub services.
 * Will not be called if the service is cancelled using cancelRequest.
 * Will not be called after gitHubServiceDone has been called.
 * @param gitHubService The service returning the error.
 * @param error The error that occured, according to GitHubServerError. 
 */
-(void)gitHubService:(id<GitHubService>)gitHubService
    didFailWithError:(NSError *)error;

/**
 * Called when a GitHub service is completed
 * Will not be called if the service is cancelled using cancelRequest.
 * Will not be called after gitHubService:didFailWithError: has been called.
 * @param gitHubService The completed GitHub service.
 */
-(void)gitHubServiceDone:(id<GitHubService>)gitHubService;

@end
