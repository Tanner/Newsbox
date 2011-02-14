//
//  GitHubTagFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"
#import "GitHubServiceGotTagDelegate.h"

@interface GitHubTagFactory : GitHubBaseFactory {
  NSString *user;
  NSString *repository;
}

@property (retain) NSString *user;
@property (retain) NSString *repository;

-(void)requestTagsByName:(NSString *)name user:(NSString *)user;

+(GitHubTagFactory *)tagFactoryWithDelegate:
(id<GitHubServiceGotTagDelegate>)delegate;

@end
