//
//  GitHubBlobFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubBlobFactory.h"

@implementation GitHubBlobFactory

#pragma mark -
#pragma mark Internal implementation declaration

static NSDictionary *localEndElement;

static NSDictionary *localStartElement;

#pragma mark -
#pragma mark Memory and member management

//Retain
@synthesize blob;

-(void)cleanUp {
  
  self.blob = nil;
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

-(void)startElementBlob {
  
  self.blob = [GitHubBlobImp blob];
}

-(void)endElementBlob {
  
  [(id<GitHubServiceGotBlobDelegate>)self.delegate
   gitHubService:self
   gotBlob:self.blob];
}

-(void)endElementName {
 
  self.blob.name = self.currentStringValue;
}

-(void)endElementSha {
  
  self.blob.sha = self.currentStringValue;
}

-(void)endElementMode {
  
  self.blob.mode = self.currentStringValue;
}

-(void)endElementMimeType {
  
  self.blob.mime = self.currentStringValue;
}


-(void)endElementData {
  
  self.blob.data = self.currentStringValue;
}

-(void)endElementSize {
  
  self.blob.size = [self.currentStringValue intValue];
}

#pragma mark -
#pragma mark Super override implementation

+(void)initialize {
  
  localStartElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (startElementBlob)], @"blob",
    nil] retain];
  
  localEndElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (endElementBlob)], @"blob",
    [NSValue valueWithPointer:@selector
     (endElementName)], @"name",
    [NSValue valueWithPointer:@selector
     (endElementSha)], @"sha",
    [NSValue valueWithPointer:@selector
     (endElementMode)], @"mode",
    [NSValue valueWithPointer:@selector
     (endElementMimeType)], @"mime-type",
    [NSValue valueWithPointer:@selector
     (endElementData)], @"data",
    [NSValue valueWithPointer:@selector
     (endElementSize)], @"size",
    [NSValue valueWithPointer:@selector
     (endElementError)], @"error",
    nil] retain];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubBlobFactory *)blobFactoryWithDelegate:
(id<GitHubServiceGotBlobDelegate>)delegate {
  
  return [[[GitHubBlobFactory alloc] initWithDelegate:delegate] autorelease]; 
}

#pragma mark - Instance

-(void)requestBlobByTreeSha:(NSString *)sha
                       user:(NSString *)user
                 repository:(NSString *)repository
                       path:(NSString *)path {
  
  [self makeRequest:[NSString
                     stringWithFormat:
                     @"/api/v2/xml/blob/show/%@/%@/%@/%@?meta=1",
                     user, repository, sha, path]];
}

-(void)requestBlobWithDataByTreeSha:(NSString *)sha
                               user:(NSString *)user
                         repository:(NSString *)repository
                               path:(NSString *)path {
  
  [self makeRequest:[NSString
                     stringWithFormat:@"/api/v2/xml/blob/show/%@/%@/%@/%@",
                     user, repository, sha, path]];
}

@end
