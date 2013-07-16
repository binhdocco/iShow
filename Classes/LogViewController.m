    //
//  LogViewController.m
//  iShow
//
//  Created by binhdocco on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LogViewController.h"


@implementation LogViewController

@synthesize textView;

- (IBAction) clearLog: (id) sender {
	textView.text = @"";
}

- (void) updateLog: (NSString *)logText {
	
	NSString *newLog = [textView.text copy];
	newLog = [newLog stringByAppendingFormat:@"%@%@",@"\n",logText];
	textView.text = [newLog copy];
	
	[textView setContentOffset:CGPointMake(0, textView.text.length)];
	//[textView performSelectorOnMainThread:@selector(setText:) withObject:newLog waitUntilDone: YES];
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.contentSizeForViewInPopover = CGSizeMake(600, 768);
    [super viewDidLoad];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
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
	textView = nil;
}


- (void)dealloc {
	[textView release];
    [super dealloc];
}


@end
