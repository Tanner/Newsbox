//
//  ItemsTableViewCell.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "ItemsTableViewCell.h"


#define PADDING 10.0f
#define DISCLOSURE_ACCESSORY_WIDTH 12.0f


@interface ItemsTableViewCell (private)
- (void)updateCellDisplay;
@end



@implementation ItemsTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		[self.textLabel setHidden:YES];
		[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	[self updateCellDisplay];
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	[self updateCellDisplay];
}


- (void)updateCellDisplay {
    if (self.selected || self.highlighted) {
        [timeStampLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[contentLabel setTextColor:[UIColor whiteColor]];
		
		[timeStampLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[contentLabel setBackgroundColor:[UIColor clearColor]];
		
		[timeStampLabel setOpaque:NO];
		[titleLabel setOpaque:NO];
		[contentLabel setOpaque:NO];
    }
    else {
        [timeStampLabel setTextColor:[UIColor darkGrayColor]];
		[titleLabel setTextColor:[UIColor blackColor]];
		[contentLabel setTextColor:[UIColor darkGrayColor]];
    }
}


- (void)setTimeStampLabelText:(NSString *)timeStampText andTitleLabelText:(NSString *)titleText andContentLabelText:(NSString *)contentText {	
	int const MAX_HEIGHT = 95.0f;
	
	CGSize constSize = { self.bounds.size.width - PADDING*2 - DISCLOSURE_ACCESSORY_WIDTH - PADDING, MAX_HEIGHT };
	CGSize timeStampTextSize = [timeStampText sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:constSize lineBreakMode:UILineBreakModeTailTruncation];
	if (!timeStampLabel) {
		timeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, 
																   PADDING,
																   constSize.width,
																   timeStampTextSize.height)];
		[timeStampLabel setOpaque:YES];
		[timeStampLabel setBackgroundColor:[UIColor whiteColor]];
		[timeStampLabel setFont:[UIFont systemFontOfSize:12.0f]];
		[timeStampLabel setTextColor:[UIColor darkGrayColor]];
		[timeStampLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		[self addSubview:timeStampLabel];
	} else {
		[timeStampLabel setFrame:CGRectMake(PADDING, 
											PADDING,
											constSize.width,
											timeStampTextSize.height)];
	}
	[timeStampLabel setText:timeStampText];
	
	CGSize titleLabelConstSize = { self.bounds.size.width - PADDING*2 - DISCLOSURE_ACCESSORY_WIDTH - PADDING, MAX_HEIGHT - PADDING - timeStampLabel.frame.origin.y - timeStampLabel.frame.size.height };
	
	// substring to 50 makes it a max of two lines
	CGSize titleTextSize = [[titleText substringToIndex:MIN(50, [titleText length])] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:titleLabelConstSize lineBreakMode:UILineBreakModeTailTruncation];
	if (!titleLabel) {
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeStampLabel.frame.origin.x,
															   timeStampLabel.frame.origin.y + timeStampLabel.frame.size.height,
															   titleLabelConstSize.width,
															   titleTextSize.height)];
		[titleLabel setOpaque:YES];
		[titleLabel setBackgroundColor:[UIColor whiteColor]];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
		[titleLabel setNumberOfLines:2];
		[titleLabel setLineBreakMode:UILineBreakModeTailTruncation];
		[titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		[self addSubview:titleLabel];
	} else {
		[titleLabel setFrame:CGRectMake(timeStampLabel.frame.origin.x,
										timeStampLabel.frame.origin.y + timeStampLabel.frame.size.height,
										titleLabelConstSize.width,
										titleTextSize.height)];
	}
	[titleLabel setText:titleText];
	
	CGSize contentLabelConstSize = { self.bounds.size.width - PADDING*2 - DISCLOSURE_ACCESSORY_WIDTH - PADDING, MAX_HEIGHT - PADDING - (titleLabel.frame.origin.y + titleLabel.frame.size.height) };
	CGSize contentTextSize = [contentText sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:contentLabelConstSize lineBreakMode:UILineBreakModeTailTruncation];
	if (!contentLabel) {
		contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x,
															   timeStampLabel.frame.origin.y + timeStampLabel.frame.size.height + titleLabel.frame.size.height + PADDING/2,
															   contentLabelConstSize.width,
															   contentTextSize.height)];
		[contentLabel setOpaque:YES];
		[contentLabel setBackgroundColor:[UIColor whiteColor]];
		[contentLabel setFont:[UIFont systemFontOfSize:13.0f]];
		[contentLabel setNumberOfLines:2];
		[contentLabel setLineBreakMode:UILineBreakModeTailTruncation];
		[contentLabel setTextColor:[UIColor darkGrayColor]];
		[contentLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		[self addSubview:contentLabel];
	} else {
		[contentLabel setFrame:CGRectMake(titleLabel.frame.origin.x,
										  timeStampLabel.frame.origin.y + timeStampLabel.frame.size.height + titleLabel.frame.size.height + PADDING/2,
										  contentLabelConstSize.width,
										  contentTextSize.height)];
	}
	[contentLabel setText:contentText];
}


- (void)dealloc {
    [super dealloc];
}


@end
