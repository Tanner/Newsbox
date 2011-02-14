//
//  GitHubCommentFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/30/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubCommentFactory.h"

@implementation GitHubCommentFactory

#pragma mark -
#pragma mark Internal implementation declaration

static NSDictionary *localEndElement;

static NSDictionary *localStartElement;

#pragma mark -
#pragma mark Memory and member management

//Retain
@synthesize comment;

-(void)cleanUp {
  
  self.comment = nil;
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

-(void)startElementComment {
  
  self.comment = [GitHubCommentImp comment];
}

-(void)endElementComment {
  
  [(id<GitHubServiceGotCommentDelegate>)self.delegate
   gitHubService:self
   gotComment:self.comment];
}

-(void)endElementGravatarId {
  
  self.comment.gravatar = self.currentStringValue;
}

-(void)endElementCreatedAt {
  
  self.comment.created =
  [self createDateFromString:self.currentStringValue];
}

-(void)endElementBody {
  
  self.comment.body = self.currentStringValue;
}

-(void)endElementUpdatedAt {
  
  self.comment.updated =
  [self createDateFromString:self.currentStringValue];
}

-(void)endElementId {
  
  self.comment.commentId = [self.currentStringValue intValue];
}

-(void)endElementUser {
  
  self.comment.user = self.currentStringValue;
}


#pragma mark -
#pragma mark Super override implementation

+(void)initialize {
  
  localStartElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (startElementComment)], @"comment",
    nil] retain];
  
  localEndElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (endElementComment)], @"comment",
    [NSValue valueWithPointer:@selector
     (endElementGravatarId)], @"gravatar-id",
    [NSValue valueWithPointer:@selector
     (endElementCreatedAt)], @"created-at",
    [NSValue valueWithPointer:@selector
     (endElementBody)], @"body",
    [NSValue valueWithPointer:@selector
     (endElementUpdatedAt)], @"updated-at",
    [NSValue valueWithPointer:@selector
     (endElementId)], @"id",
    [NSValue valueWithPointer:@selector
     (endElementUser)], @"user",
    [NSValue valueWithPointer:@selector
     (endElementError)], @"error",
    nil] retain];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubCommentFactory *)commentFactoryWithDelegate:
(id<GitHubServiceGotCommentDelegate>)delegate {

    return [[[GitHubCommentFactory alloc]
             initWithDelegate:delegate] autorelease]; 
}

#pragma mark - Instance

-(void)requestCommentsForNumber:(NSUInteger)number
                           user:(NSString *)user
                     repository:(NSString *)repository {
  
  [self makeRequest:[NSString
                     stringWithFormat:
                     @"/api/v2/xml/issues/comments/%@/%@/%i",
                     user, repository, number]];
}

@end
