//
//  SourceTableViewCell.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 5/16/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "SourceTableViewCell.h"
#import "OBGradientView.h"

#define PADDING 10.0f
#define DISCLOSURE_ACCESSORY_WIDTH 12.0f

@implementation SourceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        OBGradientView *gradientView = [[[OBGradientView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)] autorelease];
        [gradientView setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:241.0/255.0 green:22.0/255.0 blue:22.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:207.0/255.0 green:14.0/255.0 blue:14.0/255.0 alpha:1.0] CGColor], nil]];
        [gradientView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self setSelectedBackgroundView:gradientView];
        
        [self setBadgeString:@"Foo"];
        [self setBadgeColor:[UIColor lightGrayColor]];
        
        [self layoutSubviews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
