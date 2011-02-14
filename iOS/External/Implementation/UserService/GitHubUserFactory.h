//
//  GitHubUserFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/3/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"
#import "GitHubUserImp.h"
#import "GitHubServiceGotUserDelegate.h"

@interface GitHubUserFactory : GitHubBaseFactory {
  GitHubUserImp* user;
}

@property (retain) GitHubUserImp* user;

-(void)requestUserByName:(NSString *)name;

-(void)requestUserByEmail:(NSString *)email;

-(void)requestUser;

+(GitHubUserFactory *)userFactoryWithDelegate:
(id<GitHubServiceGotUserDelegate>)delegate;

@end
