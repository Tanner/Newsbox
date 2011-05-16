//
//  Algorithm.h
//  NewsBox
//
//  Created by Tanner Smith on 2/11/11.
//  Copyright 2011 TS Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Algorithm : NSObject {
}

+ (NSArray *)splitStringIntoWords:(NSString *)string;
+ (BOOL)isStopWord:(NSString *)aString;
+ (void)clusterItems;

@end