//
//  ItemsTableViewCell.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemsTableViewCell : UITableViewCell {
	UILabel *timeStampLabel;
	UILabel *titleLabel;
	UILabel *contentLabel;
}


- (void)setTimeStampLabelText:(NSString *)text andTitleLabelText:(NSString *)text andContentLabelText:(NSString *)contentText;

@end
