//
//  GitHubBlobImp.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubBlobImp.h"

@implementation GitHubBlobImp

#pragma mark -
#pragma mark Memory and member management

//Copy
@synthesize name, sha, mode, mime, data;

//Assign
@synthesize size;

-(void)dealloc {
  
  self.name = nil;
  self.sha = nil;
  self.mode = nil;
  self.mime = nil;
  self.data = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(id<GitHubBlob>)blob {
  
  return [[[GitHubBlobImp alloc] init] autorelease]; 
}

@end
