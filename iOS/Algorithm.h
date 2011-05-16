//
//  Algorithm.h
//  NewsBox
//
//  Created by Tanner Smith on 2/11/11.
//  Copyright 2011 TS Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"
#import "Topic.h"

@interface Algorithm : NSObject {
	
}

+ (NSArray *)clusterWithItems:(NSArray *)items;

@end