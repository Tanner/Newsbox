//
//  GitHubService.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright (c) 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Service protocol implemented by all GitHub services returned by the GitHub
 * service factories.
 */
@protocol GitHubService <NSObject>

/**
 * Cancelles the request to the service. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 */
-(void)cancelRequest;

@end

/**
 * Error domain string used when gitHubService:didFailWithError: is called.
 */
extern NSString * const GitHubServerErrorDomain;

/**
 * Error id used when gitHubService:didFailWithError: is called.
 */
typedef enum {
  GitHubServerServerError = 1, /**< Error recieved from the server */
  GitHubServerParserError = 2, /**< Error in parsing data from server */
  GitHubServerConnectionError = 3, /**< Error connecting to server */
} GitHubServerError;