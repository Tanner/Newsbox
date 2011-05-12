//
//  SourceSupport.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 5/12/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "SourceSupport.h"
#import "NSString+HTML.h"
#import "GTMNSString+HTML.h"

#define EXCERPT(str, len) (([str length] > len) ? [[str substringToIndex:len-1] stringByAppendingString:@"…"] : str)

@implementation Source (Support)

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
    [self willChangeValueForKey:@"title"];
    [self setPrimitiveValue:[[aTitle stringByConvertingHTMLToPlainText] gtm_stringByUnescapingFromHTML] forKey:@"title"];
    [self didChangeValueForKey:@"title"];
}

- (void)didTurnIntoFault {
	[super didTurnIntoFault];
}

@end
