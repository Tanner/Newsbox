//
//  GitHubServiceSettings.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 11/2/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubServiceSettings.h"
#import "GitHubBaseFactory.h"
#import "GitHubRepositoryFactory.h"

@implementation GitHubServiceSettings

+(void)hidePrivateRepositories:(BOOL)hidePrivateRepositories {
  
  [GitHubRepositoryFactory hidePrivateRepositories:hidePrivateRepositories];
}

+(void)setCredential:(NSURLCredential *)credential {
  
  [GitHubBaseFactory setCredential:credential];
}
+(NSURLCredential *)credential {
  
  return [GitHubBaseFactory credential];
}

+(void)setSecureConnection:(BOOL)secureConnection {

  [GitHubBaseFactory setSecureConnection:secureConnection];
}

+(BOOL)secureConnection {
  
  return [GitHubBaseFactory secureConnection];
}

+(void)setServerAddress:(NSString *)serverAddress {
  
  [GitHubBaseFactory setServerAddress:serverAddress];
}

+(NSString *)serverAddress {
  
  return [GitHubBaseFactory serverAddress];
}

+(void)setSecureServerAddress:(NSString *)secureServerAddress {
  
  [GitHubBaseFactory setSecureServerAddress:secureServerAddress];
}

+(NSString *)secureServerAddress {
  
  return [GitHubBaseFactory secureServerAddress];
}

@end
