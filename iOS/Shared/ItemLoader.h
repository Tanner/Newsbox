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
    NSString *token;
	
	BOOL authenticated;
	
	MWFeedParser *parser;
}

- (id)initWithDelegate:(id)aDelegate;
- (void)authenticateWithGoogleUser:(NSString *)username andPassword:(NSString *)password;
- (void)getItemsOfType:(ItemType)type;
- (void)markItemAsRead:(Item *)item;

@property (nonatomic, assign) id<ItemLoaderDelegate> delegate;
@property (nonatomic, assign) ItemType currentItemType;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *auth;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) BOOL authenticated;

@end

@protocol ItemLoaderDelegate
- (void)didLogin:(BOOL)login;
- (void)didLoadSourcesAndItems;
- (void)showError:(NSString *)errorTitle withMessage:(NSString *)errorMessage withSettingsButton:(BOOL)settingsButton;
@end