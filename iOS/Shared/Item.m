//
//  Feed.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "Item.h"


@interface Item (private)
- (NSString *)contentSample;
@end


@implementation Item


@synthesize title, date, content, contentLink, source, sourceLink, contentSample, dateString;


- (void)setContent:(NSString *)aContent {
	content = [[NSString alloc] initWithString:aContent];
	contentSample = [[NSString alloc] initWithString:content];
		
	NSScanner *scanner = [NSScanner scannerWithString:contentSample];
    NSString *tagText = nil;
	
	// no html tags
    while ([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:nil];
		[scanner scanUpToString:@">" intoString:&tagText];
				
		if (![tagText isEqualToString:@""] && tagText != nil) { 
			contentSample = [contentSample stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", tagText] withString:@""];
		}
    }
	
	// blank lines
	contentSample = [contentSample stringByReplacingOccurrencesOfString:[NSString stringWithString:@"\n"] withString:@""];
	
	// no xml chars
	contentSample = [Item xmlSimpleUnescape:contentSample];
	
	// trim
	contentSample = [contentSample stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];		
	
	// sample only needs max 150 chars
    contentSample = [[NSString alloc] initWithString:[contentSample substringToIndex:MIN(150, [contentSample length])]];
}


- (void)setTitle:(NSString *)aTitle {
	// no xml chars
	NSString *titleString = [Item xmlSimpleUnescape:aTitle];
	
	// trim
	titleString = [titleString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	title = [[NSString alloc] initWithString:titleString];
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


- (void)setDate:(NSDate *)aDate {
	date = aDate;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy hh:mm aaa"];
	NSString *aDateString = [dateFormatter stringFromDate:date];
	[dateFormatter release];

	self.dateString = aDateString;
}


- (void)dealloc {
	[title release];
	[date release];
	[dateString release];
	[content release];
	[contentSample release];
	[contentLink release];
	[source release];
	[sourceLink release];
	
	[super dealloc];
}


@end
