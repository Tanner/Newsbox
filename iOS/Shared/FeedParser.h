//
//  FeedParser.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FeedParser : NSObject <NSXMLParserDelegate> {
	@private
	NSMutableArray *items;
	NSMutableArray *elementStack;
	NSMutableString *currentTitle, *currentDate, *currentContent, *currentContentLink, *currentSource, *currentSourceLink;
}

- (NSArray *)getFeedsFromXMLData:(NSData *)data;

@end
