//
//  GitHubDataFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/29/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubDataFactory.h"

@implementation GitHubDataFactory

#pragma mark -
#pragma mark Delegate protocol implementation
#pragma mark - NSURLConnectionDelegate

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
  
  [(id<GitHubServiceGotDataDelegate>)self.delegate
   gitHubService:self
   gotData:[[[NSString alloc]
             initWithData:self.receivedData
             encoding:NSUTF8StringEncoding]
            autorelease]];
    
  [self.delegate gitHubServiceDone:self];
  [self cleanUp];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubDataFactory *)dataFactoryWithDelegate:
(id<GitHubServiceGotDataDelegate>)delegate {
  
  return [[[GitHubDataFactory alloc] initWithDelegate:delegate] autorelease]; 
}

#pragma mark - Instance

-(void)requestDataBySha:(NSString *)sha
                   user:(NSString *)user
             repository:(NSString *)repository {
  
  [self makeRequest:[NSString
                     stringWithFormat:@"/api/v2/xml/blob/show/%@/%@/%@",
                     user, repository, sha]];
}
@end
