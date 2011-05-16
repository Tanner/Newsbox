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
#import "SourceSupport.h"
#import "AppDelegate_Shared.h"

#define NUM_ITEMS_REQUESTED 2500

@interface ItemLoader()
- (NSString *)sidHeader;
- (NSString *)authHeader;
- (ASIHTTPRequest *)requestForAPIEndpoint:(NSString *)apiEndpoint;
- (void)getToken;
@end

@implementation ItemLoader

@synthesize delegate;
@synthesize currentItemType;
@synthesize sid;
@synthesize auth;
@synthesize token;
@synthesize authenticated;

- (id)initWithDelegate:(id)aDelegate {
	if ((self = [self init])) {
		delegate = aDelegate;
		
		parser = [[MWFeedParser alloc] init];
		[parser setDelegate:self];
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

-(void)loginRequestFinished:(ASIHTTPRequest *)request {	
    NSString *responseString = [request responseString];
	
    //login failed
    if ([responseString rangeOfString:@"Error=BadAuthentication" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        //[self setLastError: [self errorWithDescription: @"Bad Username/Passsword" code: 0x001 andErrorLevel: 0x00]];
		
		NSLog(@"login failed");
        [delegate showError:@"Google Reader Login Failed" withMessage:@"Failed to log into Google Reader." withSettingsButton:YES];
		
        authenticated = NO;
        [delegate didLogin:NO];
        
        return;
    }
	
    //captcha required
    if ([responseString rangeOfString:@"CaptchaRequired" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        //[self setLastError: [self errorWithDescription: @"Captcha Required" code: 0x001 andErrorLevel: 0x00]];
		
		NSLog(@"captcha required");
        [delegate showError:@"Google Reader Login Failed" withMessage:@"Failed to log into Google Reader." withSettingsButton:YES];
		
        authenticated = NO;
        [delegate didLogin:NO];
        
        return;
    }
    
    //extract SID + auth
    NSArray *respArray = [responseString componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
	
    NSString *sidString = [respArray objectAtIndex:0];
    sidString = [sidString stringByReplacingOccurrencesOfString: @"SID=" withString:@""];
    self.sid = sidString;
	
	NSString *authString = [respArray objectAtIndex:2];
	authString = [authString stringByReplacingOccurrencesOfString: @"Auth=" withString:@""];
	self.auth = authString;
    
    [self getToken];
	
	authenticated = YES;
	[delegate didLogin:YES];
}

- (void)loginRequestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
	
    NSLog(@"login request failed with error: %@", [error localizedDescription]);
    [delegate showError:@"No Connection" withMessage:@"Could not connect to Google Reader." withSettingsButton:NO];

    authenticated = NO;
    [delegate didLogin:NO];
    
    //[self setLastError: error];
}

- (void)getItemsOfType:(ItemType)type {
	currentItemType = type;
	
	if (type == ItemTypeUnread) {
		ASIHTTPRequest *request = [self requestForAPIEndpoint:[NSString stringWithFormat:@"https://www.google.com/reader/atom/user/-/state/com.google/reading-list?xt=user/-/state/com.google/read&n=%d", NUM_ITEMS_REQUESTED]];
		[request setDelegate:self];
		[request startAsynchronous];
	}
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [delegate showParsing];
    
	[parser performSelectorInBackground:@selector(startParsingData:) withObject:[[[[request responseString] dataUsingEncoding:NSUTF8StringEncoding] retain] autorelease]];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [delegate showError:@"Failed to Download Items" withMessage:@"An error occurred when downloading your items. Try again." withSettingsButton:NO];
    
    authenticated = NO;
    [delegate didLogin:NO];
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

- (void)getToken {
    ASIHTTPRequest *request = [self requestForAPIEndpoint:@"https://www.google.com/reader/api/0/token"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(tokenRequestFailed:)];
    [request setDidFinishSelector:@selector(tokenRequestFinished:)];
    
    [request start];
}

- (void)tokenRequestFinished:(ASIHTTPRequest *)request {
    self.token = [request responseString];
}

- (void)tokenRequestFailed:(ASIHTTPRequest *)request {
    NSLog(@"Failed to get token: %@", [request responseString]);
}

- (void)markItemAsRead:(Item *)item {
    NSURL *url = [NSURL URLWithString:@"http://www.google.com/reader/api/0/edit-tag"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setPostValue:@"newsbox" forKey:@"client"];
    
    [request addRequestHeader:@"Authorization" value:[self authHeader]];
    
    [request setPostValue:@"user/-/state/com.google/read" forKey:@"a"];
    [request setPostValue:[NSString stringWithFormat:@"feed/%@", item.source.xml] forKey:@"s"];
	[request setPostValue:[NSString stringWithFormat:@"%@", item.identifier] forKey:@"i"];
    [request setPostValue:[self token] forKey:@"T"];
	
    [request setDelegate:self];
    [request setDidFailSelector:@selector(markItemFailed:)];
    [request setDidFinishSelector:@selector(markItemFinished:)];
	
    [request start];
}

- (void)markItemFinished:(ASIHTTPRequest *)request {
//    NSLog(@"%@", [request responseString]);
}

- (void)markItemFailed:(ASIHTTPRequest *)request {
    NSLog(@"Failed to mark item as read: %d", [request responseStatusCode]);
}


#pragma mark -
#pragma mark MWFeedParserDelegate


- (void)feedParserDidStart:(MWFeedParser *)parser {
	// necessary?
}


- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(Source *)info {

}


- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(Item *)item {    
    
}


- (void)feedParserDidFinish:(MWFeedParser *)parser {
	[delegate didLoadSourcesAndItems];
}


- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	// todo
}

- (void)dealloc {
	[parser release];
    
	[super dealloc];
}

@end
