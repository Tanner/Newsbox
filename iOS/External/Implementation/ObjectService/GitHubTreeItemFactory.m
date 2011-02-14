//
//  GitHubTreeItemFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubTreeItemFactory.h"

@implementation GitHubTreeItemFactory

#pragma mark -
#pragma mark Internal implementation declaration

static NSDictionary *localEndElement;

static NSDictionary *localStartElement;

#pragma mark -
#pragma mark Memory and member management

//Retain
@synthesize treeItem;

-(void)cleanUp {
  
  self.treeItem = nil;
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

-(void)startElementTree {
  
  self.treeItem = [GitHubTreeItemImp treeItem];
}

-(void)endElementTree {
  
  if (self.treeItem) {
    
    [(id<GitHubServiceGotTreeItemDelegate>)self.delegate
     gitHubService:self
     gotTreeItem:self.treeItem];
  }
  self.treeItem = nil;
}

-(void)endElementName {
  
  self.treeItem.name = self.currentStringValue;
}

-(void)endElementSha {
 
  self.treeItem.sha = self.currentStringValue;
}

-(void)endElementMode {
  
  self.treeItem.mode = self.currentStringValue;
}

-(void)endElementMimeType {
  
  self.treeItem.mime = self.currentStringValue;
}

-(void)endElementType {
  
  self.treeItem.type = self.currentStringValue;
}

-(void)endElementSize {
  
  self.treeItem.size = [self.currentStringValue intValue];
}

#pragma mark -
#pragma mark Super override implementation

+(void)initialize {
  
  localStartElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (startElementTree)], @"tree",
    nil] retain];
  
  localEndElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (endElementTree)], @"tree",
    [NSValue valueWithPointer:@selector
     (endElementName)], @"name",
    [NSValue valueWithPointer:@selector
     (endElementSha)], @"sha",
    [NSValue valueWithPointer:@selector
     (endElementMode)], @"mode",
    [NSValue valueWithPointer:@selector
     (endElementMimeType)], @"mime-type",
    [NSValue valueWithPointer:@selector
     (endElementType)], @"type",
    [NSValue valueWithPointer:@selector
     (endElementSize)], @"size",
    [NSValue valueWithPointer:@selector
     (endElementError)], @"error",
    nil] retain];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubTreeItemFactory *)treeItemFactoryWithDelegate:
(id<GitHubServiceGotTreeItemDelegate>)delegate {
  
  return [[[GitHubTreeItemFactory alloc] initWithDelegate:delegate] autorelease]; 
}

#pragma mark - Instance

-(void)requestTreeItemsByTreeSha:(NSString *)sha
                            user:(NSString *)user
                      repository:(NSString *)repository {
  
  [self makeRequest:[NSString
                     stringWithFormat:@"/api/v2/xml/tree/show/%@/%@/%@",
                     user, repository, sha]];
}

@end
