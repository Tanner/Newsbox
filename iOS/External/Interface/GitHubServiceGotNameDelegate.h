//
//  GitHubServiceGotNameDelegate.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceDelegate.h"

/**
 * Service delegate protocol used GitHub service requests returning a
 * name in the form of an NSString.
 */
@protocol GitHubServiceGotNameDelegate <GitHubServiceDelegate>

/**
 * Called when the GitHub service found a name.
 * Will not be called if the service is cancelled using cancelRequest.
 * Will not be called after gitHubServiceDone or gitHubService:didFailWithError:
 * has been called.
 * @param gitHubService The service returning the error.
 * @param name The NSString name found by the GitHub service. 
 */
-(void)gitHubService:(id<GitHubService>)gitHubService
             gotName:(NSString *)name;

@end
