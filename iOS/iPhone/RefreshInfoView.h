//
//  RefreshInfoView.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/13/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RefreshInfoViewDelegate
- (NSDate *)dataSourceLastUpdated:(id)sender;
@end


@interface RefreshInfoView : UIView {
    id <RefreshInfoViewDelegate> delegate;
    
    UIActivityIndicatorView *activityIndicator;
    UILabel *label;
}

@property (nonatomic, assign) id<RefreshInfoViewDelegate> delegate;

- (void)animateRefresh;
- (void)stopAnimating;
- (void)refreshLastUpdatedDate;

@end
