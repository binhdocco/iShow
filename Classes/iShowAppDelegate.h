//
//  iShowAppDelegate.h
//  iShow
//
//  Created by binhdocco on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iShowViewController;

@interface iShowAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iShowViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iShowViewController *viewController;

@end

