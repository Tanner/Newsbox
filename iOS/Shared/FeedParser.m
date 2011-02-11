//
//  FeedParser.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "FeedParser.h"
#import "Item.h"


@interface FeedParser()

- (BOOL)array:(NSArray *)arr containsElement:(NSString *)string;
- (void)removeElement:(NSString *)element fromArray:(NSMutableArray *)arr;

@end


@implementation FeedParser


- (void)parserDidStartDocument:(NSXMLParser *)parser {	
	NSLog(@"found file and started parsing");
	
}

- (NSArray *)getFeedsFromXMLData:(NSData *)data {
	items = [[NSMutableArray alloc] init];
	elementStack = [[NSMutableArray alloc] init];
	
    NSXMLParser *rssParser = [[NSXMLParser alloc] initWithData:data];
	
    [rssParser setDelegate:self];
	[rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
	
    [rssParser parse];
	
	[rssParser release];
	[elementStack release];
	
	NSArray *arr = [NSArray arrayWithArray:items];
	[items release];
	return arr;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i)", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {			
	[elementStack addObject:elementName];

	if ([elementName isEqualToString:@"entry"]) {
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentContent = [[NSMutableString alloc] init];
		currentSource = [[NSMutableString alloc] init];
	}
	
	else if ([elementName isEqualToString:@"link"]) {
		if ([self array:elementStack containsElement:@"source"]) {
			currentSourceLink = [[NSString alloc] initWithString:[attributeDict valueForKey:@"href"]];
		} else {
			currentContentLink = [[NSString alloc] initWithString:[attributeDict valueForKey:@"href"]];
		}
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	if ([elementName isEqualToString:@"entry"]) {
		Item *item = [[Item alloc] init];
		[item setTitle:[NSString stringWithString:currentTitle]];
		[currentTitle release];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
		NSDate *aDate = [dateFormatter dateFromString:currentDate];
		[currentDate release];
		[item setDate:aDate];
		[dateFormatter release];
				
		[item setContent:[NSString stringWithString:currentContent]];
		[currentContent release];
		[item setContentLink:[NSString stringWithString:currentContentLink]];
		[currentContentLink release];
		[item setSource:[NSString stringWithString:currentSource]];
		[currentSource release];
		[item setSourceLink:[NSString stringWithString:currentSourceLink]];
		[currentSourceLink release];
		
		[items addObject:item];
		[item release];
	}
	
	[self removeElement:elementName fromArray:elementStack];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([self array:elementStack containsElement:@"source"]) {
		if ([[elementStack lastObject] isEqualToString:@"title"]) {
			[currentSource appendString:string];
		}
	}
	
	else {
		if ([[elementStack lastObject] isEqualToString:@"title"]) {
			[currentTitle appendString:string];
		} else if ([[elementStack lastObject] isEqualToString:@"content"] || [[elementStack lastObject] isEqualToString:@"summary"]) {
			[currentContent appendString:string];
		} else if ([[elementStack lastObject] isEqualToString:@"updated"]) {
			[currentDate appendString:string];
		}
	}
}

- (void)removeElement:(NSString *)element fromArray:(NSMutableArray *)arr {
	for (int i = [arr count]-1; i >= 0; i--) {
		NSString *string = [arr objectAtIndex:i];
		if ([string isEqualToString:element]) {
			[arr removeObjectAtIndex:i];
		}
	}
}

- (BOOL)array:(NSArray *)arr containsElement:(NSString *)element {
	for (NSString *string in arr) {
		if ([string isEqualToString:element]) {
			return YES;
		}
	}
	
	return NO;
}



- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"all done!");
	NSLog(@"items array has %d items", [items count]);
}


- (void)dealloc {	
	[super dealloc];
}	


@end
