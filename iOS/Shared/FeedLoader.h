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
	FeedType currentFeedType;
		
	NSString *sid;
	NSString *auth;
	
	FeedParser *fp;
	
	BOOL authenticated;
}

- (id)initWithDelegate:(id)aDelegate;
- (void)authenticateWithGoogleUser:(NSString *)username andPassword:(NSString *)password;
- (void)getFeedsOfType:(FeedType)type;


@property (nonatomic, assign) id<FeedLoaderDelegate> delegate;
@property (nonatomic, assign) FeedType currentFeedType;
@property (nonatomic, retain) NSString *sid;
@property (nonatomic, retain) NSString *auth;
@property (nonatomic, assign) BOOL authenticated;


@end


@protocol FeedLoaderDelegate
- (void)didLogin:(BOOL)login;
- (void)didGetFeeds:(NSArray *)feeds ofType:(FeedType)type;
@end