//
//  RefreshInfoView.h
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/13/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefreshInfoViewDelegate;

@interface RefreshInfoView : UIView {
    id <RefreshInfoViewDelegate> delegate;
    
    UIActivityIndicatorView *activityIndicator;
    UILabel *label;
}

- (void)customLayoutSubviews;

@property (nonatomic, assign) id<RefreshInfoViewDelegate> delegate;

- (void)animateLogin;
- (void)animateDownload;
- (void)stopAnimating;
- (void)refreshLastUpdatedDate;

@end

@protocol RefreshInfoViewDelegate
- (NSDate *)dataSourceLastUpdated:(id)sender;
- (BOOL)isRefreshing;
- (RefreshInfoView *)refreshInfoView;
- (UIBarButtonItem *)refreshButtonItem;
- (UIBarButtonItem *)refreshInfoViewButtonItem;
@end