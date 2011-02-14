//
//  GitHubContributorFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubContributorFactory.h"

@implementation GitHubContributorFactory

#pragma mark -
#pragma mark Internal implementation declaration

static NSDictionary *localEndElement;

static NSDictionary *localStartElement;

//Retain
@synthesize contributor;

-(void)cleanUp {
  
  self.contributor = nil;
  [super cleanUp];
}

-(void)dealloc {
  
  [self cleanUp];
  [super dealloc];
}

-(NSDictionary *)startElement {
  
  return localStartElement;
}

-(NSDictionary *)endElement {
  
  return localEndElement;
}

#pragma mark -
#pragma mark Internal implementation declaration

-(void)startElementContributor {
  
  self.contributor = [GitHubContributorImp contributor];
}

-(void)endElementContributor {
  
  [(id<GitHubServiceGotContributorDelegate>)self.delegate
   gitHubService:self
   gotContributor:self.contributor];
}

-(void)endElementLogin {
  
  self.contributor.name = self.currentStringValue;
}

-(void)endElementContributions {
  
  self.contributor.contributions = [self.currentStringValue intValue];
}

#pragma mark -
#pragma mark Super override implementation

+(void)initialize {
  
  localStartElement = 
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (startElementContributor)], @"contributor",
    nil] retain];
  
  localEndElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (endElementContributor)], @"contributor",
    [NSValue valueWithPointer:@selector
     (endElementLogin)], @"login",
    [NSValue valueWithPointer:@selector
     (endElementContributions)], @"contributions",
    [NSValue valueWithPointer:@selector
     (endElementError)], @"error",
    nil] retain];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubContributorFactory *)contributorFactoryWithDelegate:
(id<GitHubServiceGotContributorDelegate>)delegate {
  
  return [[[GitHubContributorFactory alloc]
           initWithDelegate:delegate] autorelease]; 
}

#pragma mark - Instance

-(void)requestContributorsByName:(NSString *)name user:(NSString *)user {
  
  [self makeRequest:
   [NSString stringWithFormat:@"/api/v2/xml/repos/show/%@/%@/contributors",
    user, name]];
}

@end
