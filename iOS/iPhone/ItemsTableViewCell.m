//
//  ItemsTableViewCell.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "ItemsTableViewCell.h"
#import "OBGradientView.h"
#import "SourceSupport.h"

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
                [(UILabel *)view setOpaque:NO];
                [(UILabel *)view setBackgroundColor:[UIColor clearColor]];
            }
        }
    }
}

- (void)setItem:(Item *)item andCellSize:(CGSize)size {
	int const MAX_HEIGHT = 95.0f;
    UIColor *redColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1];
    UIColor *darkGrayColor = [UIColor darkGrayColor];
    UIColor *blackColor = [UIColor blackColor];
    
    if ([item.read boolValue]) {
        redColor = [redColor colorWithAlphaComponent:0.5];
        darkGrayColor = [darkGrayColor colorWithAlphaComponent:0.5];
        blackColor = [blackColor colorWithAlphaComponent:0.5];
    }
    
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
        [dateLabel setHighlightedTextColor:[UIColor whiteColor]];
		[self.contentView addSubview:dateLabel];
	}
    
    [dateLabel setTextColor:redColor];
    [dateLabel setFrame:CGRectZero];
	[dateLabel setText:item.dateString];
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
        [sourceLabel setHighlightedTextColor:[UIColor whiteColor]];
		[self.contentView addSubview:sourceLabel];
	}
    
    [sourceLabel setTextColor:darkGrayColor];
    [sourceLabel setFrame:CGRectZero];
    [sourceLabel setText:item.source.title];
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
	CGSize titleTextSize = [[item.title substringToIndex:MIN(50, [item.title length])] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:titleLabelConstSize lineBreakMode:UILineBreakModeTailTruncation];
	if (!titleLabel) {
		titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[titleLabel setOpaque:YES];
		[titleLabel setBackgroundColor:[UIColor whiteColor]];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
		[titleLabel setNumberOfLines:2];
		[titleLabel setLineBreakMode:UILineBreakModeTailTruncation];
        [titleLabel setHighlightedTextColor:[UIColor whiteColor]];
		[self.contentView addSubview:titleLabel];
	}

    [titleLabel setTextColor:blackColor];
    [titleLabel setFrame:CGRectZero];
    [titleLabel setText:item.title];
    [titleLabel sizeToFit];
    [titleLabel setFrame:CGRectMake(sourceLabel.frame.origin.x,
										sourceLabel.frame.origin.y + sourceLabel.frame.size.height,
										MIN(titleLabel.frame.size.width, size.width - DISCLOSURE_ACCESSORY_WIDTH - PADDING*3),
										titleTextSize.height)];
	
    /*
     Content Sample
     */
    
	CGSize contentLabelConstSize = { size.width - PADDING*2 - DISCLOSURE_ACCESSORY_WIDTH - PADDING, MAX_HEIGHT - PADDING - (titleLabel.frame.origin.y + titleLabel.frame.size.height) };
	CGSize contentTextSize = [item.contentSample sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:contentLabelConstSize lineBreakMode:UILineBreakModeTailTruncation];
	if (!contentLabel) {
		contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[contentLabel setOpaque:YES];
		[contentLabel setBackgroundColor:[UIColor whiteColor]];
		[contentLabel setFont:[UIFont systemFontOfSize:13.0f]];
		[contentLabel setNumberOfLines:2];
		[contentLabel setLineBreakMode:UILineBreakModeTailTruncation];
        [contentLabel setHighlightedTextColor:[UIColor whiteColor]];
		[self.contentView addSubview:contentLabel];
	}
    
    [contentLabel setTextColor:darkGrayColor];
    [contentLabel setFrame:CGRectZero];
    [contentLabel setText:item.contentSample];
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
