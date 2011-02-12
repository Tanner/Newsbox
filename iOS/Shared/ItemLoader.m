//
//  FeedLoader.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "ItemLoader.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


@interface ItemLoader()
- (NSString *)sidHeader;
- (NSString *)authHeader;
- (ASIHTTPRequest *)requestForAPIEndpoint:(NSString *)apiEndpoint;
@end


@implementation ItemLoader


@synthesize delegate;
@synthesize currentItemType;
@synthesize sid, auth;
@synthesize authenticated;


- (id)initWithDelegate:(id)aDelegate {
	if (self = [self init]) {
		delegate = aDelegate;
		
		parser = [[MWFeedParser alloc] init];
		[parser setDelegate:self];
		
		items = [[NSMutableArray alloc] init];
	}
	
	return self;
}


- (void)authenticateWithGoogleUser:(NSString *)username andPassword:(NSString *)password {	
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
    sidString = [sidString stringByReplacingOccurrencesOfString: @"SID=" withString:@""];
    self.sid = sidString;
	
	NSString *authString = [respArray objectAtIndex:2];
	authString = [authString stringByReplacingOccurrencesOfString: @"Auth=" withString:@""];
	self.auth = authString;
	
	authenticated = YES;
	[delegate didLogin:YES];
	
    return YES;
}

- (void)loginRequestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
	
    NSLog(@"login request failed with error: %@", [error localizedDescription]);
    //[self setLastError: error];
}

- (void)getItemsOfType:(ItemType)type {
	currentItemType = type;
	
	if (type == ItemTypeUnread) {
		ASIHTTPRequest *request = [self requestForAPIEndpoint:@"http://www.google.com/reader/atom/user/-/state/com.google/reading-list"];
		[request setDelegate:self];
		[request startAsynchronous];
	}
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	[parser startParsingData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSLog(@"%@", @"failed to get feeds");
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


#pragma mark -
#pragma mark MWFeedParserDelegate


- (void)feedParserDidStart:(MWFeedParser *)parser {
	// necessary?
}


- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	// necessary?
}


- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	[items addObject:item];
}


- (void)feedParserDidFinish:(MWFeedParser *)parser {
	[delegate didGetItems:items ofType:currentItemType];

	[items removeAllObjects];
}


- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	// todo
}


- (void)dealloc {
	[parser release];
	[super dealloc];
}

@end
