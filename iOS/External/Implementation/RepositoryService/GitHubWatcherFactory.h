//
//  GitHubWatcherFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"
#import "GitHubServiceGotNameDelegate.h"

@interface GitHubWatcherFactory : GitHubBaseFactory {
}

-(void)requestWatchersByName:(NSString *)name user:(NSString *)user;

+(GitHubWatcherFactory *)watcherFactoryWithDelegate:
(id<GitHubServiceGotNameDelegate>)delegate;

@end
