//
//  GitHubLabelFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubLabelFactory.h"

@implementation GitHubLabelFactory

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

-(void)endElementLabel {
  
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
     (endElementLabel)], @"label",
    [NSValue valueWithPointer:@selector
     (endElementError)], @"error",
    nil] retain];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubLabelFactory *)labelFactoryWithDelegate:
(id<GitHubServiceGotNameDelegate>)delegate {

    return [[[GitHubLabelFactory alloc] initWithDelegate:delegate] autorelease];
}

#pragma mark - Instance

-(void)requestLabelsForUser:(NSString *)user
                 repository:(NSString *)repository {

  [self makeRequest:[NSString
                     stringWithFormat:
                     @"/api/v2/xml/issues/labels/%@/%@",
                     user, repository]];
}

@end
