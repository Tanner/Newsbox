//
//  FeedLoader.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/8/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "ItemSupport.h"
#import "MWFeedParser.h"

@protocol ItemLoaderDelegate;

@interface ItemLoader : NSObject <ASIHTTPRequestDelegate, MWFeedParserDelegate> {
	id<ItemLoaderDelegate> delegate;
	ItemType currentItemType;
		
	NSString *sid;
	NSString *auth;
	
	BOOL authenticated;
	
	MWFeedParser *parser;
	
    NSMutableArray *sources;
}

- (id)initWithDelegate:(id)aDelegate;
- (void)authenticateWithGoogleUser:(NSString *)username andPassword:(NSString *)password;
- (void)getItemsOfType:(ItemType)type;

@property (nonatomic, assign) id<ItemLoaderDelegate> delegate;
@property (nonatomic, assign) ItemType currentItemType;
@property (nonatomic, retain) NSString *sid;
@property (nonatomic, retain) NSString *auth;
@property (nonatomic, assign) BOOL authenticated;

@end

@protocol ItemLoaderDelegate
- (void)didLogin:(BOOL)login;
- (void)didGetSources:(NSArray *)sources ofType:(ItemType)type;
- (void)showError:(NSString *)errorTitle withMessage:(NSString *)errorMessage withSettingsButton:(BOOL)settingsButton;
@end