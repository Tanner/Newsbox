//
//  GitHubContributorImp.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/15/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubContributor.h"

@interface GitHubContributorImp : NSObject <GitHubContributor> {
  NSString *name;
  NSInteger contributions;
}

@property (copy) NSString *name;
@property (assign) NSInteger contributions;

+(id<GitHubContributor>)contributor;

@end
