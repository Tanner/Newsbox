//
//  GitHubIssueServiceFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubService.h"
#import "GitHubServiceGotCommentDelegate.h"
#import "GitHubServiceGotIssueDelegate.h"
#import "GitHubServiceGotNameDelegate.h"

/**
 * Service factory class for GitHub issue services.
 */
@interface GitHubIssueServiceFactory : NSObject {
}

/**
 * Creates and returns an initialized GitHubService will send
 * gitHubService:gotIssue: for each issue matching the search.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param term The search term to get data from.
 * @param state The state of the issues to match, open or closed.
 * @param user The login name of the repository owner.
 * @param repository The name of the repository.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)
searchIssuesForTerm:(NSString *)term
state:(GitHubIssueState)state
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotIssueDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService will send
 * gitHubService:gotIssue: for each issue matching the state, open or closed.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param state The state of the issues to match, open or closed.
 * @param user The login name of the repository owner.
 * @param repository The name of the repository.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)
requestIssuesForState:(GitHubIssueState)state
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotIssueDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService will send
 * gitHubService:gotIssue: for each issue labeled with the specified label.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param label The label to match against.
 * @param user The login name of the repository owner.
 * @param repository The name of the repository.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)
requestIssuesForLabel:(NSString *)label
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotIssueDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotIssue: for the issue with the specified number.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param number The issue number
 * @param user The login name of the repository owner.
 * @param repository The name of the repository.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)
requestIssueForNumber:(NSUInteger)number
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotIssueDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotComment: for each comment for the issue with the specified
 * number.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param number The issue number
 * @param user The login name of the repository owner.
 * @param repository The name of the repository.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)
requestCommentsForNumber:(NSUInteger)number
user:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotCommentDelegate>)delegate;

/**
 * Creates and returns an initialized GitHubService that will send
 * gitHubService:gotName: for each label on the repository specified.
 * The service will end with sending gitHubServiceDone if service went well, or
 * gitHubService:didFailWithError: if service failed during execution.
 * Can be cancelled using cancelRequest. If cancelled, no more message will be
 * sent to the delegate, including gitHubServiceDone
 * gitHubService:didFailWithError:.
 * @param user The login name of the repository owner.
 * @param repository The name of the repository.
 * @param delegate The delegate object for the service.
 * @return The service for the request.
 */
+(id<GitHubService>)
requestLabelsForUser:(NSString *)user
repository:(NSString *)repository
delegate:(id<GitHubServiceGotNameDelegate>)delegate;


@end
