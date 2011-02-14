//
//  GitHubBaseFactory.h
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/19/10.
//  Copyright (c) 2010 Patchwork Solutions AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubService.h"
#import "GitHubServiceDelegate.h"

@interface GitHubBaseFactory : NSObject <GitHubService, NSXMLParserDelegate> {
  NSMutableData *receivedData;
  NSString *request;
  NSXMLParser* parser;
  NSURLConnection *connection;
  NSMutableString *currentStringValue;
  BOOL failSent;
  BOOL cancelling;
  id<GitHubServiceDelegate> delegate; 
  NSDictionary *endElement;
  NSDictionary *startElement;
}

@property (retain) NSMutableData* receivedData;
@property (retain) NSXMLParser* parser;
@property (retain) NSURLConnection *connection;
@property (retain) NSMutableString *currentStringValue;
@property (copy) NSString* request;
@property (assign) BOOL failSent;
@property (assign) BOOL cancelling;
@property (retain) id<GitHubServiceDelegate> delegate;
@property (readonly, retain) NSDictionary *endElement;
@property (readonly, retain) NSDictionary *startElement;

-(void)makePostRequest:(NSString *)url body:(NSString *)body;
-(void)makeRequest:(NSString *) url;
-(id<GitHubService>)initWithDelegate:(id<GitHubServiceDelegate>)newDelegate;
-(void)cancelRequest;
-(void)cleanUp;
-(void)handleErrorWithCode:(GitHubServerError)code message:(NSString *)message;
-(NSDate *)createDateFromString:(NSString *)string;
-(NSURL *)createURLFromString:(NSString *)string;
-(void)endElementError;
+(void)setServerAddress:(NSString *)serverAddress;
+(NSString *)serverAddress;
+(void)setSecureServerAddress:(NSString *)secureServerAddress;
+(NSString *)secureServerAddress;
+(void)setCredential:(NSURLCredential *)credential;
+(NSURLCredential *)credential;
+(void)setSecureConnection:(BOOL)secureConnection;
+(BOOL)secureConnection;

@end
