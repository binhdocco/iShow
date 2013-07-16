//
//  iShowViewController.h
//  iShow
//
//  Created by binhdocco on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogViewController.h"

@interface iShowViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate > {
	
	IBOutlet UIWebView *webview;
	IBOutlet UIBarButtonItem *goBtn;
	IBOutlet UIBarButtonItem *logBtn;
	IBOutlet UITextField *urlField;
	IBOutlet UIToolbar *toolbar;
	
	LogViewController *logView;
	UIPopoverController *popover;
	
	NSMutableArray *pastUrls;
	NSMutableArray *autocompleteUrls;
	UITableView *autocompleteTableView;
    NSString *serverURL;
    UIAlertView *myAlertView;
}

@property(nonatomic, retain) IBOutlet UIWebView *webview;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *goBtn;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *logBtn;
@property(nonatomic, retain) IBOutlet UITextField *urlField;
@property(nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) NSMutableArray *pastUrls;
@property (nonatomic, retain) NSMutableArray *autocompleteUrls;
@property (nonatomic, retain) UITableView *autocompleteTableView;

@property(nonatomic, retain) LogViewController *logView;
@property(nonatomic, retain) UIPopoverController *popover;

- (IBAction) onBookmarkClicked: (id) sender;
- (IBAction) onAddBookmarkClicked: (id) sender;
- (IBAction) onReloadClicked: (id) sender;
- (IBAction) onForwardClicked: (id) sender;
- (IBAction) onBackClicked: (id) sender;
- (IBAction) onGoClicked: (id) sender;
- (IBAction) onShowLog: (id) sender;
- (IBAction) onClearCache: (id) sender;
- (IBAction) onTakeSreenshot: (id) sender;

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
- (void) handleSwipeGesture: (UISwipeGestureRecognizer *) recognizer;
- (void) handleTapGesture: (UITapGestureRecognizer *) recognizer;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

