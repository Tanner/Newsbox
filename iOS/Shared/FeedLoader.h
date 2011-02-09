//
//  FeedLoader.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "Feed.h"
#import "FeedParser.h"

@protocol FeedLoaderDelegate;


@interface FeedLoader : NSObject <ASIHTTPRequestDelegate> {
	id<FeedLoaderDelegate> delegate;
	//NSString *gUsername;
	//NSString *gPassword;
		
	NSString *sid;
	NSString *auth;
	
	FeedParser *fp;
}

- (id)initWithDelegate:(id)aDelegate;
- (void)authenticateWithGoogleUser:(NSString *)username andPassword:(NSString *)password;
- (NSArray *)getFeeds:(FeedType)type;


@property (nonatomic, assign) id<FeedLoaderDelegate> delegate;
@property (nonatomic, retain) NSString *sid;
@property (nonatomic, retain) NSString *auth;


@end


@protocol FeedLoaderDelegate
- (void)didLogin:(BOOL)login;
@end