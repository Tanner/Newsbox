//
//  GitHubDataFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"
#import "GitHubServiceGotDataDelegate.h"

@interface GitHubDataFactory : GitHubBaseFactory {
}

+(GitHubDataFactory *)dataFactoryWithDelegate:
(id<GitHubServiceGotDataDelegate>)delegate;


-(void)requestDataBySha:(NSString *)sha
                   user:(NSString *)user
             repository:(NSString *)repository;

@end
