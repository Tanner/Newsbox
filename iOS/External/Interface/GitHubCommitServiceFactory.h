//
//  GitHubCommitServiceFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright (c) 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubService.h"
#import "GitHubServiceGotCommitDelegate.h"

/**
 * Service factory class for GitHub commit services.
 */
@interface GitHubCommitServiceFactory : NSObject {
}

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotCommit: for each commit on a branch. The service will return
 * a limited amount of commit (server is currently configured to 35). More
 * commits are available if the last commit has a parent. To get more commits,
 * call this service again on the parent commit id. The service
 * will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param branch The branch on the repository to list.
 * @param repository The name of the repository.
 * @param user The login name of the repository owner.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestCommitsOnBranch:(NSString *)branch 
                                repository:(NSString *)repository
                                      user:(NSString *)user
delegate:(id<GitHubServiceGotCommitDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotCommit: for each commit for a specific file on a branch.
 * The service will return a limited amount of commit (server is currently
 * configured to 35). More commits are available if the last commit has a
 * parent. To get more commits, call this service again on the parent commit id.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param branch The branch on the repository to list.
 * @param path The path of the file to list.
 * @param repository The name of the repository.
 * @param user The login name of the repository owner.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestCommitsOnBranch:(NSString *)branch
                                      path:(NSString *)path
                                repository:(NSString *)repository
                                      user:(NSString *)user
delegate:(id<GitHubServiceGotCommitDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotCommit: for the commit id specified.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param sha The commit sha to get data from.
 * @param repository The name of the repository.
 * @param user The login name of the repository owner.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)requestCommitBySha:(NSString *)sha
                            repository:(NSString *)repository
                                  user:(NSString *)user
                              delegate:
(id<GitHubServiceGotCommitDelegate>)delegate;

@end
