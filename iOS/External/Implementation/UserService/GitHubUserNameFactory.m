//
//  GitHubUserNameFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubUserNameFactory.h"

@implementation GitHubUserNameFactory

#pragma mark -
#pragma mark Internal implementation declaration

static NSDictionary *localEndElement;

static NSDictionary *localStartElement;

#pragma mark -
#pragma mark Memory and member management

-(NSDictionary *)startElement {
  
  return localStartElement;
}

-(NSDictionary *)endElement {
  
  return localEndElement;
}

#pragma mark -
#pragma mark Internal implementation declaration

-(void)endElementUser {
  
  [(id<GitHubServiceGotNameDelegate>)self.delegate
   gitHubService:self
   gotName:self.currentStringValue];
}

#pragma mark -
#pragma mark Super override implementation

+(void)initialize {
  
  localStartElement = nil;
  
  localEndElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (endElementUser)], @"user",
    [NSValue valueWithPointer:@selector
     (endElementError)], @"error",
    nil] retain];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubUserNameFactory *)userNameFactoryWithDelegate:
(id<GitHubServiceGotNameDelegate>)delegate {
  
  return [[[GitHubUserNameFactory alloc] initWithDelegate:delegate] autorelease]; 
}

#pragma mark - Instance

-(void)requestLeadersOfUser:(NSString *)name {
  
  [self makeRequest:[NSString
                     stringWithFormat:@"/api/v2/xml/user/show/%@/following",
                     name]];
}

-(void)requestFollowersOfUser:(NSString *)name {
  
  [self makeRequest:[NSString 
                     stringWithFormat:@"/api/v2/xml/user/show/%@/followers",
                     name]];
}

@end
