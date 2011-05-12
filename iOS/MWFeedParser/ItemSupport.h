//
//  ItemSupport.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 5/12/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

typedef enum {
	ItemTypeUnread,
    ItemTypeStarred
} ItemType;

@interface Item (Support)

+ (id)newItem:(NSManagedObjectContext *)managedObjectContext;

@end
