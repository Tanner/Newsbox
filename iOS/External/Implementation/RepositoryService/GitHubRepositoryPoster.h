//
//  GitHubRepositoryPoster.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 11/6/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"

@interface GitHubRepositoryPoster : GitHubBaseFactory {
}

-(void)watchRepository:(NSString *)name;
-(void)unwatchRepository:(NSString *)name;

+(GitHubRepositoryPoster *)repositoryPosterWithDelegate:
(id<GitHubServiceDelegate>)delegate;

@end
