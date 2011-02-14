//
//  GitHubCollaboratorFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"
#import "GitHubServiceGotNameDelegate.h"

@interface GitHubCollaboratorFactory : GitHubBaseFactory {
}

-(void)requestCollaboratorsByName:(NSString *)name
                             user:(NSString *)user;

+(GitHubCollaboratorFactory *)collaboratorFactoryWithDelegate:
(id<GitHubServiceGotNameDelegate>)delegate;

@end
