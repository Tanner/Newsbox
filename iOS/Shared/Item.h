//
//  Feed.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
	ItemTypeUnread,
} ItemType;


@interface Item : NSObject {
	NSString *title;
	NSDate *date;
	NSString *content;
	NSString *contentLink;
	NSString *source;
	NSString *sourceLink;
}

- (NSString *)contentSample;
- (NSString *)dateString;
- (NSString *)titleString;
+ (NSString *)xmlSimpleUnescape:(NSString *)string;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *contentLink;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSString *sourceLink;

@end
