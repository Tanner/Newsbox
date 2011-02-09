//
//  FeedLoader.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "FeedLoader.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


@interface FeedLoader()
- (NSString *)sidHeader;
- (NSString *)authHeader;
- (ASIHTTPRequest *)requestForAPIEndpoint:(NSString *)apiEndpoint;
@end


@implementation FeedLoader


@synthesize delegate;
@synthesize sid, auth;


- (id)initWithDelegate:(id)aDelegate {
	if (self = [self init]) {
		delegate = aDelegate;
	}
	
	return self;
}


- (void)authenticateWithGoogleUser:(NSString *)username andPassword:(NSString *)password {
	fp = [[FeedParser alloc] init];

	NSURL *url = [NSURL URLWithString:@"https://www.google.com/accounts/ClientLogin"];;
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[username stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"Email"];
    [request setPostValue:[password stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"Passwd"];
	[request setPostValue:@"reader" forKey:@"service"];
	[request setPostValue:@"HOSTED_OR_GOOGLE" forKey:@"accountType"];
	[request setPostValue:@"newsbox" forKey:@"source"];
	
    [request setDelegate:self];
    [request setDidFailSelector:@selector(loginRequestFailed:)];
    [request setDidFinishSelector:@selector(loginRequestFinished:)];
	
    [request start];
}

-(BOOL)loginRequestFinished:(ASIHTTPRequest *)request {	
    NSString *responseString = [request responseString];
	
    //login failed
    if ([responseString rangeOfString:@"Error=BadAuthentication" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        //[self setLastError: [self errorWithDescription: @"Bad Username/Passsword" code: 0x001 andErrorLevel: 0x00]];
		
		NSLog(@"login failed");
		
        return NO;
    }
	
    //captcha required
    if ([responseString rangeOfString:@"CaptchaRequired" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        //[self setLastError: [self errorWithDescription: @"Captcha Required" code: 0x001 andErrorLevel: 0x00]];
		
		NSLog(@"captcha required");
		
        return NO;
    }
		
    //extract SID + auth
    NSArray *respArray = [responseString componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
	
    NSString *sidString = [respArray objectAtIndex:0];
    sidString = [sidString stringByReplacingOccurrencesOfString: @"SID=" withString: @""];
    self.sid = sidString;
	
	NSString *authString = [respArray objectAtIndex:2];
	authString = [authString stringByReplacingOccurrencesOfString: @"Auth=" withString: @""];
	self.auth = authString;
	
	[delegate didLogin:YES];
	
    return YES;
}

- (void)loginRequestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
	
    NSLog(@"login request failed with error: %@", [error localizedDescription]);
    //[self setLastError: error];
}

- (NSArray *)getFeeds:(FeedType)type {
	NSMutableArray *feeds;
	
	if (type == FeedTypeUnread) {
		ASIHTTPRequest *request = [self requestForAPIEndpoint:@"http://www.google.com/reader/atom/user/-/state/com.google/reading-list"];
		[request startSynchronous];
		
		feeds = [NSMutableArray arrayWithArray:[fp getFeedsFromXMLData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding]]];
	}
	
	return feeds;
}

- (ASIHTTPRequest *)requestForAPIEndpoint:(NSString *)apiEndpoint {
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:apiEndpoint]];
    [request addRequestHeader:@"Authorization" value:[self authHeader]];
	
    return request;
}

- (NSString *)sidHeader {
    return [NSString stringWithFormat:@"SID=%@", [self sid]];
}

- (NSString *)authHeader {
    return [NSString stringWithFormat:@"GoogleLogin auth=%@",[self auth]];
}

- (void)dealloc {
	[super dealloc];
}

@end
