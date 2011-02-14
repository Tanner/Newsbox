//
//  RefreshInfoView.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/13/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "RefreshInfoView.h"


@implementation RefreshInfoView

@synthesize delegate;

- (void)animateRefresh {
    [self addSubview:label];
    [self addSubview:activityIndicator];

    [label setText:@"Checking for feeds…"];
    [activityIndicator startAnimating];
    [self layoutSubviews];
}

- (void)stopAnimating {
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
    [self refreshLastUpdatedDate];
    
    [self layoutSubviews];
}

- (void)refreshLastUpdatedDate {
    NSDate *date = [delegate dataSourceLastUpdated:self];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setAMSymbol:@"AM"];
    [formatter setPMSymbol:@"PM"];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    label.text = [NSString stringWithFormat:@"Updated: %@", [formatter stringFromDate:date]];
 //   [[NSUserDefaults standardUserDefaults] setObject:label forKey:@"LastRefresh"];
 //   [[NSUserDefaults standardUserDefaults] synchronize];
    [formatter release];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setTextAlignment:UITextAlignmentLeft];
        [label setLineBreakMode:UILineBreakModeClip];
        [label setNumberOfLines:1];
        [label setOpaque:NO];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [label setShadowOffset:CGSizeMake(0, -1)];
        [label setShadowColor:[UIColor blackColor]];
    }
    return self;
}

- (void)layoutSubviews {
    double const PADDING = 15.0f;
    
    [label setFrame:CGRectZero];
    [label sizeToFit];
    [activityIndicator setFrame:CGRectMake((self.bounds.size.width - label.frame.size.width - PADDING - activityIndicator.frame.size.width)/2, 2.0f + activityIndicator.frame.size.height / 2, activityIndicator.frame.size.width, activityIndicator.frame.size.height)];
    
    float activityIndicatorWidth = 0.0f;
    if ([activityIndicator isAnimating]) {
        activityIndicatorWidth = activityIndicator.frame.size.width;
    }
    [label setFrame:CGRectMake((self.bounds.size.width - label.frame.size.width - activityIndicatorWidth)/2 + activityIndicatorWidth, 5.0f + label.frame.size.height / 2, label.frame.size.width, label.frame.size.height)];
        
    [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
