//
//  iShowViewController.m
//  iShow
//
//  Created by binhdocco on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iShowViewController.h"
#import "LogViewController.h"
#import "BookmarksViewController.h"
#include <QuartzCore/QuartzCore.h>

@implementation iShowViewController

@synthesize webview, goBtn, urlField, toolbar, logView, popover, logBtn;
@synthesize pastUrls, autocompleteUrls, autocompleteTableView;

- (IBAction) onTakeSreenshot: (id) sender {
    myAlertView = [[UIAlertView alloc] initWithTitle:@"iSHOW" message:@"Capturing..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [myAlertView show];
    UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(125, 80, 30, 30)];
    progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [progress startAnimating];
    [myAlertView addSubview:progress];
    progress = nil;
    
    
    //waiting for 2 seconds
	[NSTimer scheduledTimerWithTimeInterval:.5f
									 target: self
								   selector: @selector(doTakeScreenshot:)
								   userInfo: nil
									repeats:NO];

	
	
	//[imageView retain];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	NSLog(@"imageSavedToPhotosAlbum");
	
	
}
- (void) doTakeScreenshot: (NSTimer *) theTimer {
	CGRect holderRect = CGRectMake(0, 0, 1024, 768);
    UIGraphicsBeginImageContext(holderRect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[webview.layer renderInContext:context];
	UIImage *imageView = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
    //UIImageWriteToSavedPhotosAlbum(imageView, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), context);
    
    NSData *imageData = UIImageJPEGRepresentation(imageView, .7);
	
    //get name of device
    NSString *deviceType = [UIDevice currentDevice].name;
    //get unique name
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    NSDate *now = [[NSDate alloc] init ];
    NSString *imageName = [NSString stringWithFormat:@"%@_%@", deviceType, [format stringFromDate:now]];
    now = nil;
    format = nil;
    
    // setting up the request object now
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:serverURL]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]   dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n", imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //NSLog(@"returnString: %@",returnString);
    //
	[myAlertView dismissWithClickedButtonIndex:0 animated:YES];
    myAlertView = nil;
    
    UIAlertView* Alert = [[UIAlertView alloc] initWithTitle:@"iSHOW"
                                                    message:nil delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    if ([returnString isEqualToString:@"ok"]) {
        [Alert setMessage:@"Wooow! Capturing completed.\n------\nGet file @ \\\\192.168.1.222\\ishow\nLogin: drca/drca"];
    } else {
        [Alert setMessage:[NSString stringWithFormat:@"Ooops! Capturing failed.\nError: %@", returnString]];
    }
    [Alert show];
    Alert = nil;
}

- (IBAction) onBookmarkClicked: (id) sender{
    BookmarksViewController *tempView = [[BookmarksViewController alloc] initWithNibName:@"BookmarksViewController" bundle:nil];
    tempView.explorerView = self;
    [self presentModalViewController:tempView animated:true];
    [tempView release];
}
- (IBAction) onAddBookmarkClicked: (id) sender {
    NSString *url = [[[[self webview]request] URL] absoluteString];
    //NSLog(@"url: %@", url);
    if (url) {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[[[[self webview]request] URL] absoluteString] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
       /* NSMutableArray *bookmarks = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"Bookmarks"] mutableCopy];
        if (!bookmarks) {
            bookmarks = [[NSMutableArray alloc] init];
        }*/
        NSString *url = [[[[self webview]request] URL] absoluteString];
        if (![url isEqualToString:@""]) {
            if ([pastUrls indexOfObject:url] == NSNotFound) {
                [pastUrls addObject:url];
                [[NSUserDefaults standardUserDefaults] setObject:pastUrls forKey:@"Bookmarks"];
            }
        }
        
        //[bookmarks release];
    }
}

- (IBAction) onBackClicked: (id) sender {
    //NSLog(@"onBackClicked");
    if ([webview canGoBack]) {
       // NSLog(@"can go back");
        [webview goBack];
        [webview reload];
    }
}

- (IBAction) onReloadClicked: (id) sender {
    if ([self webview]) {
        // NSLog(@"can go back");
        //[webview goBack];
        [webview reload];
    }
}
- (IBAction) onForwardClicked: (id) sender {
    if ([webview canGoForward]) {
        // NSLog(@"can go back");
        [webview goForward];
        [webview reload];
    }
}

- (IBAction) onClearCache: (id) sender {
	    
}

- (IBAction) onGoClicked: (id) sender {
    [webview stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML='';"];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

	// Clean up UI
	[urlField resignFirstResponder];
	
	NSString *text = [self urlField].text;
	
	if ([text isEqual:@""]) {
		return;
	}
	if (![text hasPrefix:@"http://"]) {
		text = [NSString stringWithFormat:@"http://%@", text];
	}
	//NSLog(@"url: %@", text);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:text]cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval: 1.0];
    
	[webview loadRequest:request];
	
	
	autocompleteTableView.hidden = YES;
	
	// Add the URL to the list of entered URLS as long as it isn't already there
	/*if (![pastUrls containsObject:urlField.text]) {
		[pastUrls addObject:urlField.text];
	}*/
}

- (IBAction) onShowLog: (id) sender {
	if (popover) {
		[popover presentPopoverFromBarButtonItem:logBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [webview stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML='';"];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

	// Clean up UI
	[urlField resignFirstResponder];
	
	NSString *text = [self urlField].text;
	//NSLog(@"url: %@", text);
	if ([text isEqual:@""]) {
		return YES;
	}
	if (![text hasPrefix:@"http://"]) {
		text = [NSString stringWithFormat:@"http://%@", text];
	}
	//NSLog(@"url: %@", text);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:text]cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval: 1.0];
    
	[webview loadRequest:request];
	
	autocompleteTableView.hidden = YES;
	
	// Add the URL to the list of entered URLS as long as it isn't already there
	//if (![pastUrls containsObject:urlField.text]) {
		//[pastUrls addObject:urlField.text];
	//}
	
	return YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
        
    /*
	NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	if ([requestString hasPrefix:@"ios-log"]) {
		NSString *logString =[[requestString componentsSeparatedByString:@":#iOS#"] objectAtIndex:1];
		//NSLog(@"UIWebView console: %@", logString);
		[logView updateLog:logString];
		return FALSE;
	}
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
     */
	NSString *url = [[request URL] absoluteString];
	urlField.text = url;
	return TRUE;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Can not load url!"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[alert show];
	//[alert release];
	
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
	
	// Put anything that starts with this substring into the autocompleteUrls array
	// The items in this array is what will show up in the table view
	[autocompleteUrls removeAllObjects];
	for(NSString *curString in pastUrls) {
		NSRange substringRange = [curString rangeOfString:substring options:NSCaseInsensitiveSearch];
		if (substringRange.length > 0) {
			[autocompleteUrls addObject:curString];  
		}
	}
	[autocompleteTableView reloadData];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	autocompleteTableView.hidden = NO;
	
	NSString *substring = [NSString stringWithString:textField.text];
	substring = [substring stringByReplacingCharactersInRange:range withString:string];
	[self searchAutocompleteEntriesWithSubstring:substring];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	autocompleteTableView.hidden = YES;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
	return autocompleteUrls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell = nil;
	static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
	cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier] autorelease];
	}
	
	cell.textLabel.text = [autocompleteUrls objectAtIndex:indexPath.row];
	return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	urlField.text = selectedCell.textLabel.text;
	
	[self onGoClicked:nil];
	
}


- (void) handleSwipeGesture: (UISwipeGestureRecognizer *) recognizer {
	//NSLog(@"swipe: %f", self.toolbar.alpha);
	if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
		if (self.toolbar.alpha == 1.0) {
			[UIView beginAnimations:@"toolbarAni" context:nil];
			toolbar.frame = CGRectOffset(toolbar.frame, 0, - toolbar.frame.size.height);
			toolbar.alpha = 0.0;
			//[self.infoLabel setHidden:YES];
			[UIView commitAnimations];
		}
	}  else if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
		if (self.toolbar.alpha == 0.0) {
			[UIView beginAnimations:@"toolbarAni" context:nil];
			toolbar.frame = CGRectOffset(toolbar.frame, 0, + toolbar.frame.size.height);
			toolbar.alpha = 1.0;
			//[self.infoLabel setHidden:NO];
			[UIView commitAnimations];
		}
	} else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
		//[self loadPrevPage];
	} else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
		//[self loadNextPage];
	}
	
}

- (void) handleTapGesture: (UITapGestureRecognizer *) recognizer {
	autocompleteTableView.hidden = YES;
}
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//add swipe gesture
	UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
	//swipeUpRecognizer = (UISwipeGestureRecognizer *) recognizer;
	recognizer.direction = UISwipeGestureRecognizerDirectionUp;
	recognizer.delegate = self;
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];
	
	
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
	//recognizer = (UISwipeGestureRecognizer *) recognizer;
	recognizer.direction = UISwipeGestureRecognizerDirectionDown;
	recognizer.delegate = self;
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];
	
	///UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	//tapGesture.delegate = self;
	//[self.view addGestureRecognizer:tapGesture];
	//[tapGesture release];
	
	webview.allowsInlineMediaPlayback = TRUE;
	webview.mediaPlaybackRequiresUserAction = FALSE;
	
    
    id webDocumentView = [webview performSelector:@selector(_browserView)];
    id backingWebView = [webDocumentView performSelector:@selector(webView)];
    [backingWebView _setWebGLEnabled:YES];
    
	self.urlField.delegate = self;
	self.webview.delegate = self;
	
	//[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];
	//[[NSUserDefaults standardUserDefaults] synchronize];
	
	logView = [[LogViewController alloc] init];
	
	UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:logView];
	popover = [[UIPopoverController alloc] initWithContentViewController:controller];
	
	[controller release];
	
	self.pastUrls = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"Bookmarks"] mutableCopy];
    if (!pastUrls) {
        pastUrls = [[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:pastUrls forKey:@"Bookmarks"];
    }
	self.autocompleteUrls = [[NSMutableArray alloc] init];
	
	autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 44, 900, 200) style:UITableViewStylePlain];
	autocompleteTableView.delegate = self;
	autocompleteTableView.dataSource = self;
	autocompleteTableView.scrollEnabled = YES;
	autocompleteTableView.hidden = YES;  
	[self.view addSubview:autocompleteTableView];
    
    //send to server
    serverURL = @"http://int-prod.drcom.asia/iShow/save.php";
    //serverURL = @"http://192.168.1.14:8080/iShow/save.php";
	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		return YES;
	}
    return NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.urlField = nil;
	self.goBtn = nil;
	self.webview = nil;
	self.toolbar = nil;
	logBtn = nil;
}


- (void)dealloc {
	[pastUrls release];
	[autocompleteUrls release];
	[autocompleteTableView release];	
	[logBtn release];
	[popover release];
	[logView release];
	[webview release];
	[goBtn release];
	[urlField release];
	[toolbar release];
    [super dealloc];
}

@end
