//
//  GitHubBlobFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBaseFactory.h"
#import "GitHubServiceGotBlobDelegate.h"
#import "GitHubBlobImp.h"

@interface GitHubBlobFactory : GitHubBaseFactory {
  GitHubBlobImp *blob;
}

@property (retain) GitHubBlobImp *blob;

+(GitHubBlobFactory *)blobFactoryWithDelegate:
(id<GitHubServiceGotBlobDelegate>)delegate;

-(void)requestBlobByTreeSha:(NSString *)sha
                       user:(NSString *)user
                 repository:(NSString *)repository
                       path:(NSString *)path;

-(void)requestBlobWithDataByTreeSha:(NSString *)sha
                               user:(NSString *)user
                         repository:(NSString *)repository
                               path:(NSString *)path;
@end
