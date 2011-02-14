//
//  GitHubRepositoryPoster.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 11/6/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubRepositoryPoster.h"

@implementation GitHubRepositoryPoster

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

+(GitHubRepositoryPoster *)repositoryPosterWithDelegate:
(id<GitHubServiceDelegate>)delegate {
  
  return [[[GitHubRepositoryPoster alloc]
           initWithDelegate:delegate] autorelease]; 
}

#pragma mark - Instance

-(void)watchRepository:(NSString *)name {
  
  [self makePostRequest:[NSString
                         stringWithFormat:@"/api/v2/xml/repos/watch/%@", name]
                   body:@""];
}

-(void)unwatchRepository:(NSString *)name {
  
  [self makePostRequest:[NSString
                         stringWithFormat:@"/api/v2/xml/repos/unwatch/%@", name]
                   body:@""];
}
@end
