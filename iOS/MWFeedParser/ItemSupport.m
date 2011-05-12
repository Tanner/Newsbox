//
//  ItemSupport.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 5/12/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "ItemSupport.h"
#import "NSString+HTML.h"
#import "GTMNSString+HTML.h"
#import "AppDelegate_Shared.h"
#import "SourceSupport.h"

#define EXCERPT(str, len) (([str length] > len) ? [[str substringToIndex:len-1] stringByAppendingString:@"…"] : str)

@implementation Item (Support)

+ (id)newItem:(NSManagedObjectContext *)managedObjectContext {
    Item *result = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
    return [result retain];
}

- (NSComparisonResult)compareByDate:(Item *)otherItem {    
    // reverse sort
    return [otherItem.date compare:self.date];
}

- (void)setSummary:(NSString *)aSummary {
    [self willChangeValueForKey:@"summary"];
	[self setPrimitiveValue:aSummary forKey:@"summary"];
    [self didChangeValueForKey:@"summary"];
    
	NSString *aContentSample = [[NSString alloc] initWithString:[[self.summary stringByConvertingHTMLToPlainText] gtm_stringByUnescapingFromHTML]];
	
	// sample only needs max 150 chars
    [self willChangeValueForKey:@"contentSample"];
    [self setPrimitiveValue:[aContentSample substringToIndex:MIN(150, [aContentSample length])] forKey:@"contentSample"];
    [self didChangeValueForKey:@"contentSample"];
}

- (void)setTitle:(NSString *)aTitle {
    [self willChangeValueForKey:@"title"];
    [self setPrimitiveValue:[[aTitle stringByConvertingHTMLToPlainText] gtm_stringByUnescapingFromHTML] forKey:@"title"];
    [self didChangeValueForKey:@"title"];
}

- (void)setDate:(NSDate *)aDate {
	[self willChangeValueForKey:@"date"];
    [self setPrimitiveValue:aDate forKey:@"DATE"];
    [self didChangeValueForKey:@"date"];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy h:mm aaa"];
	NSString *aDateString = [dateFormatter stringFromDate:self.date];
    
    NSString *aShortDateString;
    if (abs((int)[aDate timeIntervalSinceNow]/(60*60*24)) >= 1) {
        [dateFormatter setDateFormat:@"MMMM dd"];
        aShortDateString = [dateFormatter stringFromDate:self.date];
        [dateFormatter release];
    } else {
        [dateFormatter setDateFormat:@"h:mm aaa"];
        aShortDateString = [dateFormatter stringFromDate:self.date];
        [dateFormatter release];
    }

    [self willChangeValueForKey:@"dateString"];
	[self setPrimitiveValue:aDateString forKey:@"dateString"];
    [self didChangeValueForKey:@"dateString"];
    
    [self willChangeValueForKey:@"shortDateString"];
	[self setPrimitiveValue:aShortDateString forKey:@"shortDateString"];
    [self didChangeValueForKey:@"shortDateString"];
}

#pragma mark NSObject

- (NSString *)description {
	NSMutableString *string = [[NSMutableString alloc] initWithString:@"MWFeedItem: "];
	if (self.title)   [string appendFormat:@"“%@”", EXCERPT(self.title, 50)];
	if (self.date)    [string appendFormat:@" - %@", self.date];
	if (self.link)    [string appendFormat:@" (%@)", self.link];
	if (self.summary) [string appendFormat:@", %@", EXCERPT(self.summary, 50)];
	return [string autorelease];
}

- (void)didTurnIntoFault {
	[super didTurnIntoFault];
}

@end
