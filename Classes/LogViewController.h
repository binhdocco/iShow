//
//  LogViewController.h
//  iShow
//
//  Created by binhdocco on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LogViewController : UIViewController {
	IBOutlet UITextView *textView;
}

@property(nonatomic, retain) IBOutlet UITextView *textView;

- (void) updateLog: (NSString *)logText;

- (IBAction) clearLog: (id) sender;
@end
