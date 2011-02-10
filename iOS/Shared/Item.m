//
//  Feed.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "Item.h"


@implementation Item


@synthesize title, date, content, contentLink, source, sourceLink;


- (NSString *)contentSample {
	NSScanner *scanner = [NSScanner scannerWithString:content];
	NSString *contentSample = content;
    NSString *tagText = nil;
	
    while ([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:nil];
		[scanner scanUpToString:@">" intoString:&tagText];
		
        contentSample = [contentSample stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", tagText] withString:@""];
    }
    
    return [[contentSample stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] substringToIndex:MIN(150, [contentSample length])];
}


- (NSString *)dateString {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy hh:mm aaa"];
	NSString *dateString = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return dateString;
}


- (void)dealloc {
	[title release];
	[date release];
	[content release];
	[contentLink release];
	[source release];
	[sourceLink release];
	
	[super dealloc];
}


@end
