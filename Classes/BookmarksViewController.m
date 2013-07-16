//
//  BookmarksViewController.m
//  iShow
//
//  Created by drcom_developer on 6/17/13.
//
//

#import "BookmarksViewController.h"

@interface BookmarksViewController ()
    
@end

@implementation BookmarksViewController 

@synthesize bookmarks, explorerView, pTable;

-(IBAction)cancelButtonTapped: (id) sender{
    //[self.parentViewController dismissModalViewControllerAnimated:true];
    [self dismissModalViewControllerAnimated:true];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [bookmarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
    
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [bookmarks objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    explorerView.urlField.text = [bookmarks objectAtIndex:indexPath.row];
    [explorerView textFieldShouldReturn:explorerView.urlField];
    [self dismissModalViewControllerAnimated:true];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [bookmarks removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [[NSUserDefaults standardUserDefaults] setObject:bookmarks forKey:@"Bookmarks"];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    bookmarks = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"Bookmarks"] mutableCopy];
   // NSLog(@"bookmarks: %@", bookmarks);
    // Do any additional setup after loading the view from its nib.
    UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch.jpg"]];
    [iView setAlpha:.3f];
    [pTable setBackgroundView:iView];
    iView = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    [explorerView release];
    explorerView = nil;
    [bookmarks release];
    bookmarks = nil;

}


- (void)dealloc {
   
    [super dealloc];
}

@end
