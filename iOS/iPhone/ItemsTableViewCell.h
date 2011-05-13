//
//  ItemsTableViewCell.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemSupport.h"

@interface ItemsTableViewCell : UITableViewCell {
	UILabel *sourceLabel;
    UILabel *dateLabel;
	UILabel *titleLabel;
	UILabel *contentLabel;
}

- (void)setItem:(Item *)item andCellSize:(CGSize)size;

@end
