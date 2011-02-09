//
//  FeedParser.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "FeedParser.h"
#import "Feed.h"


@interface FeedParser()

- (BOOL)array:(NSArray *)arr containsElement:(NSString *)string;
- (void)removeElement:(NSString *)element fromArray:(NSMutableArray *)arr;

@end


@implementation FeedParser


- (void)parserDidStartDocument:(NSXMLParser *)parser {	
	NSLog(@"found file and started parsing");
	
}

- (NSArray *)getFeedsFromXMLData:(NSData *)data {
	stories = [[NSMutableArray alloc] init];
	elementStack = [[NSMutableArray alloc] init];
	
    rssParser = [[NSXMLParser alloc] initWithData:data];
	
    [rssParser setDelegate:self];
	[rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
	
    [rssParser parse];
	
	return [NSArray arrayWithArray:stories];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i)", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {			
	[elementStack addObject:[elementName copy]];

	if ([elementName isEqualToString:@"entry"]) {
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentSource = [[NSMutableString alloc] init];
	}
	
	else if (![self array:elementStack containsElement:@"source"] && [elementName isEqualToString:@"link"]) {
		currentLink = [[NSString alloc] initWithString:[attributeDict valueForKey:@"href"]];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	if ([elementName isEqualToString:@"entry"]) {
		Feed *feed = [[Feed alloc] init];
		[feed setTitle:[[NSString alloc] initWithString:currentTitle]];
		[feed setDate:[[NSString alloc] initWithString:currentDate]];
		[feed setSummary:[[NSString alloc] initWithString:currentSummary]];
		[feed setLink:[[NSString alloc] initWithString:currentLink]];
		[feed setSource:[[NSString alloc] initWithString:currentSource]];
		
		[stories addObject:feed];
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
		} else if ([[elementStack lastObject] isEqualToString:@"content"]) {
			[currentSummary appendString:string];
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
	NSLog(@"stories array has %d items", [stories count]);
}


- (void)dealloc {
	[elementStack release];
	[rssParser release];
	[stories release];
	[currentTitle release];
	[currentDate release];
	[currentSummary release];
	[currentLink release];
	[currentSource release];
	
	[super dealloc];
}	


@end
