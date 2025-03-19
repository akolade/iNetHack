//
//  TextDisplayViewController.m
//  iNetHack
//
//  Created by dirk on 7/10/09.
//  Copyright 2009 Dirk Zimmermann. All rights reserved.
//

//  This file is part of iNetHack.
//
//  iNetHack is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 2 of the License only.
//
//  iNetHack is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iNetHack.  If not, see <http://www.gnu.org/licenses/>.

#import "TextDisplayViewController.h"
#import "MainViewController.h"
#import <WebKit/WebKit.h>

@implementation TextDisplayViewController

@synthesize text, condition, HTML = isHTML, log = isLog;

- (void)dealloc {
    [condition release];
    self.text = nil;
    if (self.wkWebView) {
        self.wkWebView.navigationDelegate = nil;
    }
    [super dealloc];
}

- (void)updateText {
    if (textView) {
        textView.text = self.text;
        if (isLog && self.text && self.text.length > 0) {
            NSRange r = NSMakeRange(self.text.length - 1, 1);
            [textView scrollRangeToVisible:r];
        }
    } else if (self.wkWebView) {
        [self.wkWebView loadHTMLString:self.text baseURL:nil];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        NSURL *url = navigationAction.request.URL;
        if (url) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"URL opened successfully.");
                } else {
                    NSLog(@"Failed to open URL.");
                }
            }];
            decisionHandler(WKNavigationActionPolicyCancel); // Prevent the web view from navigating
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    colorInvert = [[NSUserDefaults standardUserDefaults] floatForKey:@"colorInvert"];

	if (self.isHTML) {
        self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame];
        self.wkWebView.backgroundColor = !colorInvert ? [UIColor blackColor] : [UIColor whiteColor];
        self.wkWebView.navigationDelegate = self;
        self.view = self.wkWebView;
	} else {
        textView = [[UITextView alloc] initWithFrame:self.view.frame];
        textView.backgroundColor = !colorInvert?[UIColor blackColor]:[UIColor whiteColor];
		textView.textColor = colorInvert?[UIColor blackColor]:[UIColor whiteColor];
		textView.editable = NO;
        textView.scrollEnabled = NO;    //iOS9 fix: disable then enable scrolling so initial scrolling works
        textView.scrollEnabled = YES;   //...
		self.view = textView;
		[textView release];
	}
	[self updateText];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	if (condition) {
		[[MainViewController instance] broadcastCondition:condition];
	}
}
@end
