//
//  ItemViewController_iPhone.m
//  Newsbox
//
//  Created by Ryan Ashcraft on 2/9/11.
//  Copyright 2011 Ashcraft Media. All rights reserved.
//

#import "ItemViewController_iPhone.h"
#import "AppDelegate_Shared.h"

@interface ItemViewController_iPhone (private) 
- (NSString *)stylizedHTMLWithItem:(Item *)anItem;
@end

@implementation ItemViewController_iPhone

@synthesize delegate;
@synthesize itemIdentifier;
@synthesize sourceLink;

#pragma mark -
#pragma mark Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        items = [[NSMutableArray alloc] init];
        
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
        
//        NSArray *prevNextControlItems = [NSArray arrayWithObjects:[UIImage imageNamed:@"up_arrow.png"],[UIImage imageNamed:@"down_arrow.png"],nil];
//        prevNextControl = [[UISegmentedControl alloc] initWithItems:prevNextControlItems];
//        [prevNextControl setSegmentedControlStyle:UISegmentedControlStyleBar];
//        [prevNextControl setMomentary:YES];
//        [prevNextControl setWidth:42.0f forSegmentAtIndex:0];
//        [prevNextControl setWidth:42.0f forSegmentAtIndex:1];
//        [prevNextControl addTarget:self action:@selector(prevNextControlValueChanged:) forControlEvents:UIControlEventValueChanged];
//        [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:prevNextControl] autorelease]];
        
        NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *flexibleSpaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        [toolbarItems addObject:flexibleSpaceItem];        
        
        upArrowItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"up_arrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(previousItemRequested:)] autorelease];
        [toolbarItems addObject:upArrowItem];
        
        UIBarButtonItem *flexibleSpaceItem2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        [toolbarItems addObject:flexibleSpaceItem2];
        
        downArrowItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"down_arrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(nextItemRequested:)] autorelease];
        [toolbarItems addObject:downArrowItem];
        
        UIBarButtonItem *flexibleSpaceItem3 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        [toolbarItems addObject:flexibleSpaceItem3];
        
        [self setToolbarItems:toolbarItems animated:NO];
        
        [toolbarItems release];
    }
    
    return self;
}

#pragma mark -
#pragma mark Data

- (void)reloadData {
    [items removeAllObjects];
    
    // Fill array of items
    NSArray *executedRequest;
    if (sourceLink) {
        NSFetchRequest *fetchRequest = [[(AppDelegate_Shared *)delegate managedObjectModel]
                                        fetchRequestFromTemplateWithName:@"itemsFromSourceWithLink"
                                        substitutionVariables:[NSDictionary dictionaryWithObject:sourceLink forKey:@"sourceLink"]];
        executedRequest = [[(AppDelegate_Shared *)delegate managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    } else {
        NSFetchRequest *fetchRequest = [[(AppDelegate_Shared *)delegate managedObjectModel]
                                        fetchRequestTemplateForName:@"allItems"];
        executedRequest = [[(AppDelegate_Shared *)delegate managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    }
    
    if (executedRequest) {
        [items addObjectsFromArray:executedRequest];
    }
    
    [items sortUsingSelector:@selector(compareByDate:)];
    
    // Set current item
    for (Item *i in items) {
        if ([i.identifier isEqualToString:itemIdentifier]) {
            currentItem = i;
        }
    }
    
    [self displayCurrentItem];
}

- (void)previousItemRequested:(id)sender {
	currentItem = [items objectAtIndex:[items indexOfObject:currentItem]-1];
    
    [delegate didChangeCurrentItemTo:currentItem];
    [self displayCurrentItem];
}

- (void)nextItemRequested:(id)sender {
    currentItem = [items objectAtIndex:[items indexOfObject:currentItem]+1];
    [delegate didChangeCurrentItemTo:currentItem];
    [self displayCurrentItem];
}

- (void)setIsPrevItemAvailable:(BOOL)prevItemAvailable andIsNextItemAvailable:(BOOL)nextItemAvailable {
    if (prevItemAvailable) {
        [upArrowItem setEnabled:YES];
    } else {
        [upArrowItem setEnabled:NO];
    }
    
    if (nextItemAvailable) {
        [downArrowItem setEnabled:YES];
    } else {
        [downArrowItem setEnabled:NO];
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

- (NSString *)stylizedHTMLWithItem:(Item *)anItem {
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
    [html appendFormat:@"<p class=\"chronodata\">%@</p>", [anItem dateString]];
	[html appendFormat:@"<h1><a href=\"%@\">%@</a></h1>", [anItem link], [anItem title]];
    [html appendFormat:@"<p class=\"source\">%@</p>", [[anItem source] title]];
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
        [html release];
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
         
- (void)displayCurrentItem {
    // Set Item's read property
    [currentItem setRead:[NSNumber numberWithBool:YES]];
    
    [self setIsPrevItemAvailable:[items indexOfObject:currentItem] > 0
          andIsNextItemAvailable:[items indexOfObject:currentItem] < [items count]-1];
    [wv loadHTMLString:[self stylizedHTMLWithItem:currentItem] baseURL:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	[self.view addSubview:wv];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    [self reloadData];
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
    [itemIdentifier release];
    [sourceLink release];
    [items release];
    
    [super dealloc];
}

@end
