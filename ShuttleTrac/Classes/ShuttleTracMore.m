//
//  ShuttleTracMore.m
//  ShuttleTrac
//
//  Created by Brady Law on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShuttleTracMore.h"
#import "DataStoreGrabber.h"

@implementation ShuttleTracMore

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark actions

-(IBAction)resetApplication:(UIButton *)sender {
	// Verify with confirm dialog warning bookmarks are lost
	UIAlertView *verifyReset = [[UIAlertView alloc] initWithTitle:@"Are you sure?" 
														  message:@"Reseting stored data will cause you to lose your saved bookmarks."
														 delegate:self
												cancelButtonTitle:@"Cancel"
												otherButtonTitles:nil];
	[verifyReset addButtonWithTitle:@"OK, Reset"];
	[verifyReset show];
	[verifyReset autorelease];
}

-(IBAction)loadTransportationWebsite:(UIButton *)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.transportation.umd.edu/routes/commuter.html"]]; 
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != 1)
		return;
	
	UIAlertView *verifyReset = [[[UIAlertView alloc] initWithTitle:@"Restart Application" 
														  message:@"Data will be re-downloaded after you reload the application."
														 delegate:nil
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil] autorelease];
	[verifyReset show];
	
	ShuttleTracDataStore *dataStore = GetShuttleTracDataStore();
	[dataStore setUpdateNeeded:YES];

}

#pragma mark -

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
