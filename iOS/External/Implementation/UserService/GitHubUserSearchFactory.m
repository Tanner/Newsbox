//
//  GitHubUserSearchFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubUserSearchFactory.h"

@implementation GitHubUserSearchFactory

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

-(void)endElementName {
  
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
     (endElementName)], @"name",
    [NSValue valueWithPointer:@selector
     (endElementError)], @"error",
    nil] retain];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubUserSearchFactory *)userSearchFactoryWithDelegate:
(id<GitHubServiceGotNameDelegate>)delegate {
  
  return [[[GitHubUserSearchFactory alloc]
           initWithDelegate:delegate] autorelease]; 
}

#pragma mark - Instance

-(void)searchUsersByName:(NSString *)name {
  
  [self makeRequest:[NSString
                     stringWithFormat:@"/api/v2/xml/user/search/%@", name]];
}

@end
