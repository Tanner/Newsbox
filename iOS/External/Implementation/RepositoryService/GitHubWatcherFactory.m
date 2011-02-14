//
//  GitHubWatcherFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubWatcherFactory.h"

@implementation GitHubWatcherFactory

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

-(void)endElementWatcher {
  
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
     (endElementWatcher)], @"watcher",
    [NSValue valueWithPointer:@selector
     (endElementError)], @"error",
    nil] retain];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubWatcherFactory *)watcherFactoryWithDelegate:
(id<GitHubServiceGotNameDelegate>)delegate {
  
  return [[[GitHubWatcherFactory alloc] initWithDelegate:delegate] autorelease];   
}

#pragma mark - Instance

-(void)requestWatchersByName:(NSString *)name
                        user:(NSString *)user {
  
  [self makeRequest:
   [NSString stringWithFormat:@"/api/v2/xml/repos/show/%@/%@/watchers",
    user, name]];
}

@end
