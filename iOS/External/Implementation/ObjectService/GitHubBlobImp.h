//
//  GitHubBlobImp.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubBlob.h"

@interface GitHubBlobImp : NSObject <GitHubBlob> {
  NSString *name;
  NSString *sha;
  NSString *mode;
  NSString *mime;
  NSString *data;
  NSUInteger size;
}

@property (copy) NSString *name;
@property (copy) NSString *sha;
@property (copy) NSString *mode;
@property (copy) NSString *mime;
@property (copy) NSString *data;
@property (assign) NSUInteger size;

+(id<GitHubBlob>)blob;

@end
