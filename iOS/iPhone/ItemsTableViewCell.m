//
//  ItemsTableViewCell.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "ItemsTableViewCell.h"
#import "OBGradientView.h"


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
        
        OBGradientView *gradientView = [[[OBGradientView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)] autorelease];
        [gradientView setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:241.0/255.0 green:22.0/255.0 blue:22.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:207.0/255.0 green:14.0/255.0 blue:14.0/255.0 alpha:1.0] CGColor], nil]];
        [gradientView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self setSelectedBackgroundView:gradientView];
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
        for (UIView *view in self.contentView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                [(UILabel *)view setTextColor:[UIColor whiteColor]];
                [(UILabel *)view setOpaque:NO];
                [(UILabel *)view setBackgroundColor:[UIColor clearColor]];
            }
        }
    }
    else {
        for (UIView *view in self.contentView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                if (view == titleLabel) {
                    [(UILabel *)view setTextColor:[UIColor blackColor]];
                } else if (view == dateLabel) {
                    [(UILabel *)view setTextColor:[UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0]];
                } else {
                    [(UILabel *)view setTextColor:[UIColor darkGrayColor]];
                }
            }
        }
    }
}


- (void)setSourceLabelText:(NSString *)sourceText
          andDateLabelText:(NSString *)dateText
			andTitleLabelText:(NSString *)titleText
		  andContentLabelText:(NSString *)contentText
				  andCellSize:(CGSize)size {
    
	int const MAX_HEIGHT = 95.0f;
    
    /*
     Date
     */
    
    //CGSize dateLabelConstSize = { size.width - PADDING*2 - DISCLOSURE_ACCESSORY_WIDTH - PADDING, MAX_HEIGHT };
	//CGSize dateLabelSize = [dateText sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:dateLabelConstSize lineBreakMode:UILineBreakModeClip];
	if (!dateLabel) {
		dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[dateLabel setOpaque:YES];
		[dateLabel setBackgroundColor:[UIColor whiteColor]];
		[dateLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [dateLabel setTextAlignment:UITextAlignmentRight];
        [dateLabel setNumberOfLines:1];
		[dateLabel setLineBreakMode:UILineBreakModeClip];
		[dateLabel setTextColor:[UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0]];
		[self.contentView addSubview:dateLabel];
	}
    
    [dateLabel setFrame:CGRectZero];
	[dateLabel setText:dateText];
    [dateLabel sizeToFit];
    [dateLabel setFrame:CGRectMake(size.width - DISCLOSURE_ACCESSORY_WIDTH - dateLabel.frame.size.width, 
                                   PADDING,
                                   dateLabel.frame.size.width,
                                   dateLabel.frame.size.height)];
    
    
    /*
     Source
     */
        
	//CGSize sourceLabelConstSize = { size.width - PADDING*2 - DISCLOSURE_ACCESSORY_WIDTH - PADDING, MAX_HEIGHT };
	//CGSize sourceLabelSize = [sourceText sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:sourceLabelConstSize lineBreakMode:UILineBreakModeTailTruncation];
	if (!sourceLabel) {
		sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[sourceLabel setOpaque:YES];
		[sourceLabel setBackgroundColor:[UIColor whiteColor]];
		[sourceLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [sourceLabel setNumberOfLines:1];
		[sourceLabel setLineBreakMode:UILineBreakModeTailTruncation];
		[sourceLabel setTextColor:[UIColor darkGrayColor]];
		[self.contentView addSubview:sourceLabel];
	}
    
    [sourceLabel setFrame:CGRectZero];
    [sourceLabel setText:sourceText];
    [sourceLabel sizeToFit];
    [sourceLabel setFrame:CGRectMake(PADDING, 
											PADDING,
											MIN(sourceLabel.frame.size.width, size.width - DISCLOSURE_ACCESSORY_WIDTH - PADDING*2 - dateLabel.frame.size.width),
											sourceLabel.frame.size.height)];
    
    /*
     Title
     */
		
	CGSize titleLabelConstSize = { size.width - PADDING*2 - DISCLOSURE_ACCESSORY_WIDTH - PADDING, MAX_HEIGHT - PADDING - sourceLabel.frame.origin.y - sourceLabel.frame.size.height };
	
	// substring to 50 makes it a max of two lines
	CGSize titleTextSize = [[titleText substringToIndex:MIN(50, [titleText length])] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:titleLabelConstSize lineBreakMode:UILineBreakModeTailTruncation];
	if (!titleLabel) {
		titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[titleLabel setOpaque:YES];
		[titleLabel setBackgroundColor:[UIColor whiteColor]];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
		[titleLabel setNumberOfLines:2];
		[titleLabel setLineBreakMode:UILineBreakModeTailTruncation];
        [titleLabel setTextColor:[UIColor blackColor]];
		[self.contentView addSubview:titleLabel];
	}

    [titleLabel setFrame:CGRectZero];
    [titleLabel setText:titleText];
    [titleLabel sizeToFit];
    [titleLabel setFrame:CGRectMake(sourceLabel.frame.origin.x,
										sourceLabel.frame.origin.y + sourceLabel.frame.size.height,
										MIN(titleLabel.frame.size.width, size.width - DISCLOSURE_ACCESSORY_WIDTH - PADDING*3),
										titleTextSize.height)];
	
	CGSize contentLabelConstSize = { size.width - PADDING*2 - DISCLOSURE_ACCESSORY_WIDTH - PADDING, MAX_HEIGHT - PADDING - (titleLabel.frame.origin.y + titleLabel.frame.size.height) };
	CGSize contentTextSize = [contentText sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:contentLabelConstSize lineBreakMode:UILineBreakModeTailTruncation];
	if (!contentLabel) {
		contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[contentLabel setOpaque:YES];
		[contentLabel setBackgroundColor:[UIColor whiteColor]];
		[contentLabel setFont:[UIFont systemFontOfSize:13.0f]];
		[contentLabel setNumberOfLines:2];
		[contentLabel setLineBreakMode:UILineBreakModeTailTruncation];
		[contentLabel setTextColor:[UIColor darkGrayColor]];
		[self.contentView addSubview:contentLabel];
	}
    
    [contentLabel setFrame:CGRectZero];
    [contentLabel setText:contentText];
    [contentLabel sizeToFit];
    [contentLabel setFrame:CGRectMake(titleLabel.frame.origin.x,
										  sourceLabel.frame.origin.y + sourceLabel.frame.size.height + titleLabel.frame.size.height + PADDING/2,
										  MIN(contentLabel.frame.size.width, size.width - DISCLOSURE_ACCESSORY_WIDTH - PADDING*3),
										  contentTextSize.height)];
}


- (void)dealloc {
    [super dealloc];
}


@end
