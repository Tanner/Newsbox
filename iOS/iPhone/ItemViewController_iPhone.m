//
//  ItemViewController_iPhone.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "ItemViewController_iPhone.h"

@interface ItemViewController_iPhone (private) 
- (NSString *)stylizedHTMLWithItem:(MWFeedItem *)anItem;
@end

@implementation ItemViewController_iPhone

@synthesize delegate;

- (void)prevNextControlValueChanged:(id)sender {
	if ([sender selectedSegmentIndex] == 0) {
		[delegate showPrevItemBefore:item];
	} else {
		[delegate showNextItemAfter:item];
	}
}

- (void)setIsPrevItemAvailable:(BOOL)prevItemAvailable andIsNextItemAvailable:(BOOL)nextItemAvailable {
    if (prevItemAvailable) {
        [prevNextControl setEnabled:YES forSegmentAtIndex:0];
    } else {
        [prevNextControl setEnabled:NO forSegmentAtIndex:0];
    }
    
    if (nextItemAvailable) {
        [prevNextControl setEnabled:YES forSegmentAtIndex:1];
    } else {
        [prevNextControl setEnabled:NO forSegmentAtIndex:1];
    }
}

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

- (NSString *)stylizedHTMLWithItem:(MWFeedItem *)anItem {
	NSMutableString *html = [[NSMutableString alloc] init];
		
	[html appendString:@"<html>"];
	[html appendString:@"<head>"];
	
	[html appendString:@"<meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0;'>"];
	
	[html appendString:@"<style type=\"text/css\">"];
	NSError *err = nil;
	NSString *css = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"itemstyle" ofType:@"css"] encoding:NSASCIIStringEncoding error:&err];
	if (css == nil) {
		NSLog(@"%@", err);
	}
	[html appendString:css];
	[html appendString:@"</style>"];
	
	/*
	NSString *js = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"itemscript" ofType:@"js"] encoding:NSASCIIStringEncoding error:&err];
	if (js == nil) {
		NSLog(@"%@", err);
	}
	[html appendString:js];
	 */
	
	[html appendString:@"</head>"];
	
	[html appendString:@"<body>"];
	[html appendString:@"<div id=\"wrapper\">"];

	[html appendFormat:@"<div id=\"head\""];
	[html appendFormat:@"<h1><a href=\"%@\">%@</a></h1>", [anItem link], [anItem title]];
	[html appendFormat:@"<p class=\"chronodata\">%@</p>", [anItem dateString]];
	[html appendFormat:@"</div>"];
	[html appendFormat:@"<div id=\"content\">"];
	
	NSScanner *scanner;
	NSString *content;
	if ([anItem content]) {
		scanner = [NSScanner scannerWithString:[anItem content]];
		content = [anItem content];
	} else if ([anItem summary]) {
		scanner = [NSScanner scannerWithString:[anItem summary]];
		content = [anItem summary];
	} else {
		return @"";
	}
	
	NSString *tagText = nil;
	
	// remove styling
	while ([scanner isAtEnd] == NO) {
		[scanner scanUpToString:@"<img" intoString:nil];
		[scanner scanUpToString:@">" intoString:&tagText];
		
		if ([tagText rangeOfString:@"height=\"0\""].location == NSNotFound && [tagText rangeOfString:@"height=\"1\""].location == NSNotFound
			/*&& [tagText rangeOfString:@"quantserve"].location == NSNotFound && [tagText rangeOfString:@"quantserve"].location == NSNotFound && [tagText rangeOfString:@"pheedo"].location == NSNotFound*/) {
			content = [content stringByReplacingOccurrencesOfString:tagText withString:[NSString stringWithFormat:@"%@ class=\"bigImage\"",tagText]];
		}
	}
	
    tagText = nil;
    
	// big image class
	[scanner setScanLocation:0];
	while ([scanner isAtEnd] == NO) {
		[scanner scanUpToString:@"style=\"" intoString:nil];
		[scanner scanUpToString:@"\"" intoString:&tagText];
		
		if (tagText != nil) {
			content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@\"", tagText] withString:@""];
		}
	}
	
	[html appendString:content];
	
	[html appendString:@"</div></div></body></html>"];
	
	NSString *stylizedHTML = [NSString stringWithString:html];
	[html release];
	
    
	return stylizedHTML;
}

- (void)setItem:(MWFeedItem *)anItem {
    item = anItem;
	[wv loadHTMLString:[self stylizedHTMLWithItem:anItem] baseURL:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		wv = [[UIWebView alloc] initWithFrame:self.view.bounds];
		[wv setDelegate:self];
		[wv setBackgroundColor:[UIColor whiteColor]];
		[wv setScalesPageToFit:NO];
		[wv setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		
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
	
    if (!prevNextControl) {
        NSArray *prevNextControlItems = [NSArray arrayWithObjects:[UIImage imageNamed:@"left_arrow.png"],[UIImage imageNamed:@"right_arrow.png"],nil];
        prevNextControl = [[UISegmentedControl alloc] initWithItems:prevNextControlItems];
        [prevNextControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [prevNextControl setMomentary:YES];
        [prevNextControl setWidth:42.0f forSegmentAtIndex:0];
        [prevNextControl setWidth:42.0f forSegmentAtIndex:1];
        [prevNextControl setFrame:CGRectMake(0, 0, prevNextControl.frame.size.width, 35)]; // 35 is height of UIBarButton in UIToolbar
        [prevNextControl addTarget:self action:@selector(prevNextControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:prevNextControl] autorelease]];
    
	[self.view addSubview:wv];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}
	 
- (void)viewDidDisappear:(BOOL)animated {
	[wv loadHTMLString:@"" baseURL:nil];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

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
