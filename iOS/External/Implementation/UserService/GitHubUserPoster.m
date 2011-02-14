//
//  GitHubUserPoster.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 11/6/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubUserPoster.h"

@implementation GitHubUserPoster

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
#pragma mark Super override implementation

+(void)initialize {
  
  localStartElement = nil;
  
  localEndElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (endElementError)], @"error",
    nil] retain];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubUserPoster *)userPosterWithDelegate:
(id<GitHubServiceDelegate>)delegate {
  
  return [[[GitHubUserPoster alloc]
           initWithDelegate:delegate] autorelease]; 
}

#pragma mark - Instance

-(void)followUser:(NSString *)name {
  
  [self makePostRequest:[NSString
                         stringWithFormat:@"/api/v2/xml/user/follow/%@", name]
                   body:@""];
}

-(void)unfollowUser:(NSString *)name {
  
  [self makePostRequest:[NSString
                     stringWithFormat:@"/api/v2/xml/user/unfollow/%@", name]
                   body:@""];
}

@end
