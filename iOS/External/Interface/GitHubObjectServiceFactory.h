//
//  GitHubObjectServiceFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubService.h"
#import "GitHubServiceGotTreeItemDelegate.h"
#import "GitHubServiceGotBlobDelegate.h"
#import "GitHubServiceGotDataDelegate.h"

/**
 * Service factory class for GitHub object services.
 */
@interface GitHubObjectServiceFactory : NSObject {
}

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotTreeItem: for each item in the specified tree.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param sha The sha for the tree to list.
 * @param user The login name of the repository owner.
 * @param repository The name of the repository.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)
requestTreeItemsByTreeSha:(NSString *)sha
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotTreeItemDelegate>)delegate;


/**
 * Creates and returns an initialized GitHubService that will send a
 * gitHubService:gotBlob: without data for the specified path, tree and
 * repository.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param sha The sha for the tree to list.
 * @param user The login name of the repository owner.
 * @param repository The name of the repository.
 * @param path The path to the file to get the data for.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)
requestBlobByTreeSha:(NSString *)sha
user:(NSString *)user
repository:(NSString *)repository
path:(NSString *)path
delegate:(id<GitHubServiceGotBlobDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send a
 * gitHubService:gotBlob: with data for the specified path, tree and repository.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param sha The sha for the tree to list.
 * @param user The login name of the repository owner.
 * @param repository The name of the repository.
 * @param path The path to the file to get the data for.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)
requestBlobWithDataByTreeSha:(NSString *)sha
user:(NSString *)user
repository:(NSString *)repository
path:(NSString *)path
delegate:(id<GitHubServiceGotBlobDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send a
 * gitHubService:gotData: with raw git data for the specified sha and
 * repository.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param sha The sha for the tree to list.
 * @param user The login name of the repository owner.
 * @param repository The name of the repository.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)
requestDataBySha:(NSString *)sha
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotDataDelegate>)delegate;

@end
