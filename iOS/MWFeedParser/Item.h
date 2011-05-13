//
//  Item.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 5/12/11.
//  Copyright (c) 2011 Ashcraft Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Source;

@interface Item : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * dateString;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * contentSample;
@property (nonatomic, retain) NSString * shortDateString;
@property (nonatomic, retain) NSNumber * unread;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) Source * source;

@end
