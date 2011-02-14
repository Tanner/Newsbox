//
//  GitHubContributorFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"
#import "GitHubContributorImp.h"
#import "GitHubServiceGotContributorDelegate.h"

@interface GitHubContributorFactory : GitHubBaseFactory {
  GitHubContributorImp *contributor;
}

@property (retain) GitHubContributorImp *contributor;

-(void)requestContributorsByName:(NSString *)name user:(NSString *)user;

+(GitHubContributorFactory *)contributorFactoryWithDelegate:
(id<GitHubServiceGotContributorDelegate>)delegate;

@end
