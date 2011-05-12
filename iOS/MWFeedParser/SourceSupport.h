//
//  SourceSupport.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 5/12/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Source.h"

@interface Source (Support)

+ (id)newSource:(NSManagedObjectContext *)managedObjectContext;

- (NSComparisonResult)compare:(Source *)feedInfo;

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end