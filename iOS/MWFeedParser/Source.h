//
//  Source.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 5/13/11.
//  Copyright (c) 2011 Ashcraft Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Source : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * xml;
@property (nonatomic, retain) NSSet* items;

@end
