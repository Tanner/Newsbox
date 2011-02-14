//
//  GitHubServiceSettings.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 11/2/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GitHubServiceSettings : NSObject {
}

+(void)hidePrivateRepositories:(BOOL)hidePrivateRepositories;

+(void)setCredential:(NSURLCredential *)credential;
+(NSURLCredential *)credential;

+(void)setSecureConnection:(BOOL)secureConnection;
+(BOOL)secureConnection;

+(void)setServerAddress:(NSString *)serverAddress;
+(NSString *)serverAddress;

+(void)setSecureServerAddress:(NSString *)secureServerAddress;
+(NSString *)secureServerAddress;

@end
