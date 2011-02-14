//
//  GitHubTagFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubTagFactory.h"
#import "GitHubTagImp.h"
#import "GitHubBaseFactory.h"

@implementation GitHubTagFactory

#pragma mark -
#pragma mark Memory and member management

//Retain
@synthesize user, repository;

-(void)cleanUp {
  
  self.repository = nil;
  self.user = nil;
  [super cleanUp];
}

-(void)dealloc {
  
  [self cleanUp];
  [super dealloc];
}

#pragma mark -
#pragma mark Delegate protocol implementation
#pragma mark - NSURLConnectionDelegate

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
  
  NSMutableCharacterSet *characterSet = 
  [NSMutableCharacterSet characterSetWithCharactersInString:@"\""];
  
  [characterSet formUnionWithCharacterSet:
   [NSCharacterSet whitespaceCharacterSet]];
  
  NSString *string = [[[NSString alloc]
                       initWithData:self.receivedData
                       encoding:NSUTF8StringEncoding]
                      autorelease];
  
  NSArray *lines = [string componentsSeparatedByString:@"\n"];
  BOOL tagsStarted = NO;
  
  for (NSString *line in lines) {
    
    if (tagsStarted && ![line isEqualToString:@""]) {
      
      NSArray * tagStrings= [line componentsSeparatedByString:@":"];
      
      if ([tagStrings count] == 2) {
        
        GitHubTagImp *tag = [GitHubTagImp tag];
        
        tag.name = [[tagStrings objectAtIndex:0]
                    stringByTrimmingCharactersInSet:characterSet];
        
        tag.sha = [[tagStrings objectAtIndex:1]
                        stringByTrimmingCharactersInSet:characterSet];
        
        tag.userName = self.user;
        tag.repositoryName = self.repository;
         
        [(id<GitHubServiceGotTagDelegate>)self.delegate
         gitHubService:self gotTag:tag];
      }
      
    } else if ([[line stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceCharacterSet]]
                                     isEqualToString:@"tags:"]) {
                                       
      tagsStarted = YES;
      
    } else if ([[line stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceCharacterSet]]
                                     isEqualToString:@"error:"]) {
      
      [self handleErrorWithCode:GitHubServerServerError message:@""];
    }
  }
  self.connection = nil;
  self.receivedData = nil;
  
  if (!self.failSent && !self.cancelling) {
    
    [self.delegate gitHubServiceDone:self];
    [self cleanUp];
  }
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubTagFactory *)tagFactoryWithDelegate:
(id<GitHubServiceGotTagDelegate>)delegate {
  
  return [[[GitHubTagFactory alloc] initWithDelegate:delegate] autorelease]; 
}

#pragma mark - Instance

-(void)requestTagsByName:(NSString *)newRepository
                    user:(NSString *)newUser {
  
  self.user = newUser;
  self.repository = newRepository;
  
  [self makeRequest:
   [NSString stringWithFormat:@"/api/v2/yaml/repos/show/%@/%@/tags",
    newUser, newRepository]];
}

@end
