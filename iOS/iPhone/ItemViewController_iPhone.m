//
//  ItemViewController_iPhone.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "ItemViewController_iPhone.h"


@interface ItemViewController_iPhone (private) 
- (NSString *)stylizedHTMLWithTitle:(NSString *)title andBody:(NSString *)body;
@end


@implementation ItemViewController_iPhone


@synthesize delegate;


#pragma mark -
#pragma mark UIWebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeOther) {
		return YES;
	}
	
	[[UIApplication sharedApplication] openURL:[request URL]];
	return NO;
}


#pragma mark -


- (NSString *)stylizedHTMLWithTitle:(NSString *)title andBody:(NSString *)body {
	NSMutableString *html = [[NSMutableString alloc] init];
	
	[html appendString:@"<body style=\"font-family: Helvetica;\">"];

	[html appendString:@"<h1>"];
	[html appendString:title];
	[html appendString:@"</h1>"];
	
	[html appendString:@"<p>"];
	[html appendString:body];
	[html appendString:@"</p>"];
	
	[html appendString:@"</body>"];

	return [NSString stringWithString:html];
}


- (void)setItem:(Feed *)anItem {
	[wv loadHTMLString:[self stylizedHTMLWithTitle:[anItem title] andBody:[anItem summary]] baseURL:nil];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		wv = [[UIWebView alloc] initWithFrame:self.view.bounds];
		[wv setDelegate:self];
		[wv setBackgroundColor:[UIColor whiteColor]];
		
		for (UIView *aView in [[[wv subviews] objectAtIndex:0] subviews]) { 
			if ([aView isKindOfClass:[UIImageView class]]) {
				aView.hidden = YES;
			}
		}   
		
		[self.view addSubview:wv];
	}
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewDidDisappear:(BOOL)animated {
	[wv loadHTMLString:@"" baseURL:nil];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
