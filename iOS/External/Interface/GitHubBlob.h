//
//  GitHubBlob.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Protocol for a git blob in GitHub
 * See GitHub api documentation for details.
 */
@protocol GitHubBlob <NSObject>

@property (readonly, copy) NSString *name;
@property (readonly, copy) NSString *sha;
@property (readonly, copy) NSString *mode;
@property (readonly, copy) NSString *mime;
@property (readonly, copy) NSString *data;
@property (readonly, assign) NSUInteger size;

@end
