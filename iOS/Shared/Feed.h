//
//  Feed.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
	FeedTypeUnread,
	FeedTypeStarred
} FeedType;


@interface Feed : NSObject {
	NSString *title;
	NSString *date;
	NSString *summary;
	NSString *link;
	NSString *source;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *source;

@end
