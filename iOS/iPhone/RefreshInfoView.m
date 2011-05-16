//
//  RefreshInfoView.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/13/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "RefreshInfoView.h"

CGRect CGRectMakeInt(float x, float y, float width, float height) {
    return CGRectMake((int)x, (int)y, (int)width, (int)height);
}

@implementation RefreshInfoView

@synthesize delegate;

- (void)animateLogin {
    [self addSubview:label];
    [self addSubview:activityIndicator];
    
    [label setText:@"Logging into Google Reader…"];
    [activityIndicator startAnimating];
    [self customLayoutSubviews];
}

- (void)animateDownload {
    [self addSubview:label];
    [self addSubview:activityIndicator];

    [label setText:@"Downloading Items…"];
    [activityIndicator startAnimating];
    [self customLayoutSubviews];
}

- (void)animateParse {
    [self addSubview:label];
    [self addSubview:activityIndicator];
    
    [label setText:@"Processing Items…"];
    [activityIndicator startAnimating];
    [self customLayoutSubviews];
}

- (void)stopAnimating {
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
    [self refreshLastUpdatedDate];
        
    [self customLayoutSubviews];
}

- (void)refreshLastUpdatedDate {
    NSDate *date = [delegate dataSourceLastUpdated:self];
    
    if (date == nil) {
        [label setText:@"Never Updated"];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setAMSymbol:@"AM"];
    [formatter setPMSymbol:@"PM"];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    [label setText:[NSString stringWithFormat:@"Updated: %@", [formatter stringFromDate:date]]];
    [formatter release];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityIndicator setHidesWhenStopped:NO];
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

- (void)customLayoutSubviews {
    double const PADDING = 15.0f;
    
    [label setFrame:CGRectZero];
    [label sizeToFit];
    [activityIndicator setFrame:CGRectMakeInt((self.bounds.size.width - label.frame.size.width - PADDING - activityIndicator.frame.size.width)/2, 2.0f + activityIndicator.frame.size.height / 2, activityIndicator.frame.size.width, activityIndicator.frame.size.height)];
    
    float activityIndicatorWidth = 0.0f;
    if ([activityIndicator isAnimating]) {
        activityIndicatorWidth = activityIndicator.frame.size.width;
    }
    
    [label setFrame:CGRectMakeInt((self.bounds.size.width - label.frame.size.width - activityIndicatorWidth)/2 + activityIndicatorWidth, 5.0f + label.frame.size.height / 2, label.frame.size.width, label.frame.size.height)];
    
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
