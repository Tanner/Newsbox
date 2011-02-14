//
//  GitHubRepositoryServiceFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright (c) 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubService.h"
#import "GitHubServiceGotRepositoryDelegate.h"
#import "GitHubServiceGotContributorDelegate.h"
#import "GitHubServiceGotNameDelegate.h"
#import "GitHubServiceGotTagDelegate.h"
#import "GitHubServiceGotBranchDelegate.h"

/**
 * Service factory class for GitHub repository services.
 */
@interface GitHubRepositoryServiceFactory : NSObject {
}

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotRepository: for each repository in the repository network.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The name of the repository.
 * @param user The login name of the repository owner.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestRepositoriesInNetworkByName:(NSString *)name
                                                  user:(NSString *)user
delegate:(id<GitHubServiceGotRepositoryDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send a
 * gitHubService:gotRepository: for the requested repository.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The name of the repository.
 * @param user The login name of the repository owner.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestRepositoryByName:(NSString *)name
                                       user:(NSString *)user
delegate:(id<GitHubServiceGotRepositoryDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotRepository: for each repository watched by the specified
 * user.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param user The name of the user to get watched repositories from.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestRepositoriesWatchedByUser:(NSString *)user
delegate:(id<GitHubServiceGotRepositoryDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotRepository: for each repository owned by the specified user.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param user The name of the user to get owned repositories from.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestRepositoriesOwnedByUser:(NSString *)user
delegate:(id<GitHubServiceGotRepositoryDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotRepository: for each repository matching the search term.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The repository name to search for.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)searchRepositoriesByName:(NSString *)name 
delegate:(id<GitHubServiceGotRepositoryDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotName: with a user login name for each collaborator on the
 * specified repository.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The name of the repository.
 * @param user The login name of the repository owner.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestCollaboratorsByName:(NSString *)name
                                          user:(NSString *)user
delegate:(id<GitHubServiceGotNameDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotContributor: for each contributor on the specified
 * repository.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The name of the repository.
 * @param user The login name of the repository owner.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestContributorsByName:(NSString *)name
                                         user:(NSString *)user
delegate:(id<GitHubServiceGotContributorDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotName: with a user login name for each watcher of the
 * specified repository.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The name of the repository.
 * @param user The login name of the repository owner.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestWatchersByName:(NSString *)name
                                     user:(NSString *)user
delegate:(id<GitHubServiceGotNameDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotTag: with a for each tag of the specified repository.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The name of the repository.
 * @param user The login name of the repository owner.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestTagsByName:(NSString *)name
                                 user:(NSString *)user
delegate:(id<GitHubServiceGotTagDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotBranch: with a for each branch of the specified repository.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The name of the repository.
 * @param user The login name of the repository owner.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestBranchesByName:(NSString *)name
                                     user:(NSString *)user
delegate:(id<GitHubServiceGotBranchDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will add the specified
 * repository to the watch list for the default credential GitHubUser.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The name of the repository to watch
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)watchRepository:(NSString *)name
                           delegate:(id<GitHubServiceDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will remove the
 * specified repository from the watch list for the default credential
 * GitHubUser.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param name The name of the repositoroy to unwatch
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)unwatchRepository:(NSString *)name
                             delegate:(id<GitHubServiceDelegate>)delegate;

@end
