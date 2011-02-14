//
//  GitHubLabelFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"
#import "GitHubServiceGotNameDelegate.h"

@interface GitHubLabelFactory : GitHubBaseFactory {

}

-(void)requestLabelsForUser:(NSString *)user
                 repository:(NSString *)repository;

+(GitHubLabelFactory *)labelFactoryWithDelegate:
(id<GitHubServiceGotNameDelegate>)delegate;

@end
