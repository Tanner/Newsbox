//
//  MWFeedInfo.m
//  MWFeedParser
//
//  Copyright (c) 2010 Michael Waterfall
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  1. The above copyright notice and this permission notice shall be included
//     in all copies or substantial portions of the Software.
//  
//  2. This Software cannot be used to archive or collect data such as (but not
//     limited to) that of events, news, experiences and activities, for the 
//     purpose of any concept relating to diary/journal keeping.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "Source.h"
#import "NSString+HTML.h"
#import "GTMNSString+HTML.h"

#define EXCERPT(str, len) (([str length] > len) ? [[str substringToIndex:len-1] stringByAppendingString:@"…"] : str)

@implementation Source
@dynamic title;
@dynamic link;
@dynamic summary;
@dynamic items;

+ (id)newSource:(NSManagedObjectContext *)managedObjectContext {
    Source *result = (Source *)[NSEntityDescription insertNewObjectForEntityForName:@"Source" inManagedObjectContext:managedObjectContext];
    return [result retain];
}

- (void)addItemsObject:(Item *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"items" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"items"] addObject:value];
    [self didChangeValueForKey:@"items" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeItemsObject:(Item *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"items" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"items"] removeObject:value];
    [self didChangeValueForKey:@"items" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addItems:(NSSet *)value {    
    [self willChangeValueForKey:@"items" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"items"] unionSet:value];
    [self didChangeValueForKey:@"items" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeItems:(NSSet *)value {
    [self willChangeValueForKey:@"items" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"items"] minusSet:value];
    [self didChangeValueForKey:@"items" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (NSComparisonResult)compare:(Source *)otherSource {    
    return [self.link compare:otherSource.link];
}

- (NSComparisonResult)compareByName:(Source *)otherSource {
    return [self.title compare:otherSource.title options:NSCaseInsensitiveSearch];
}

#pragma mark NSObject

- (NSString *)description {
	NSMutableString *string = [[NSMutableString alloc] initWithString:@"MWFeedInfo: "];
	if (self.title)   [string appendFormat:@"“%@”", EXCERPT(self.title, 50)];
	//if (link)    [string appendFormat:@" (%@)", link];
	//if (summary) [string appendFormat:@", %@", MWExcerpt(summary, 50)];
	return [string autorelease];
}

- (void)setTitle:(NSString *)aTitle {
    self.title = [[NSString alloc] initWithString:[[aTitle stringByConvertingHTMLToPlainText] gtm_stringByUnescapingFromHTML]];
}

- (void)didTurnIntoFault {
	[super didTurnIntoFault];
}

@end
