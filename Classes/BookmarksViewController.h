//
//  BookmarksViewController.h
//  iShow
//
//  Created by drcom_developer on 6/17/13.
//
//

#import <UIKit/UIKit.h>
#import "iShowViewController.h"

@interface BookmarksViewController : UIViewController <UITableViewDelegate> {

    NSMutableArray *bookmarks;
    iShowViewController *explorerView;
    IBOutlet UITableView *pTable;
}
@property (nonatomic, retain) NSMutableArray *bookmarks;
@property (nonatomic, retain) iShowViewController *explorerView;
@property (nonatomic, retain) IBOutlet UITableView *pTable;

-(IBAction)cancelButtonTapped: (id) sender;

@end
