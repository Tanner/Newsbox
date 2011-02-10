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
	
	// no html tags
    while ([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:nil];
		[scanner scanUpToString:@">" intoString:&tagText];
		
        contentSample = [contentSample stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", tagText] withString:@""];
    }
	
	// blank lines
	contentSample = [contentSample stringByReplacingOccurrencesOfString:[NSString stringWithString:@"\n"] withString:@""];
	
	// no xml chars
	contentSample = [Item xmlSimpleUnescape:contentSample];
	
	// trim
	contentSample = [contentSample stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	// sample only needs max 150 chars
    return [contentSample substringToIndex:MIN(150, [contentSample length])];
}


- (NSString *)titleString {
	// no xml chars
	NSString *titleString = [Item xmlSimpleUnescape:title];
	
	// trim
	titleString = [titleString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	return titleString;
}


+ (NSString *)xmlSimpleUnescape:(NSString *)string {
	string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString: @"&"];
	string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
	string = [string stringByReplacingOccurrencesOfString:@"&#27;" withString:@"'"];
	string = [string stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
	string = [string stringByReplacingOccurrencesOfString:@"&#92;" withString:@"'"];
	string = [string stringByReplacingOccurrencesOfString:@"&#96;" withString:@"'"];
	string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
	string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
	
	return string;
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
