//
//  GitHubServiceFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright (c) 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubService.h"
#import "GitHubServiceGotNameDelegate.h"
#import "GitHubServiceGotUserDelegate.h"

/**
 * Service factory class for GitHub user services.
 */
@interface GitHubUserServiceFactory : NSObject {
}

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotUser: with the resulting GitHubUser. The service will end
 * with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The user name of the user to get data from.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestUserByName:(NSString *)name
delegate:(id<GitHubServiceGotUserDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotUser: with the resulting GitHubUser. The service will end
 * with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param email The email address of the user to get data from.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestUserByEmail:(NSString *)email
delegate:(id<GitHubServiceGotUserDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotName: for each follower of the named user. The service will
 * end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The user name of the user to get followers from.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestFollowersOfUser:(NSString *)name
delegate:(id<GitHubServiceGotNameDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotName: for each user named user follows. The service will
 * end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The user name of the user to get leaders from.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestLeadersByUser:(NSString *)name
delegate:(id<GitHubServiceGotNameDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotName: for each user that matches the search. The service
 * will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The name to search for.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)searchUsersByName:(NSString *)name
delegate:(id<GitHubServiceGotNameDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotUser: for the default credential GitHubUser.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestUserWithDelegate:
(id<GitHubServiceGotUserDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will add the specified
 * user to the follow list for the default credential GitHubUser.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The name of the user to follow
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)followUser:(NSString *)name
                      delegate:(id<GitHubServiceDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will remove the
 * specified user to the follow list for the default credential GitHubUser.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The name of the user to follow
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)unfollowUser:(NSString *)name
                        delegate:(id<GitHubServiceDelegate>)delegate;

@end
