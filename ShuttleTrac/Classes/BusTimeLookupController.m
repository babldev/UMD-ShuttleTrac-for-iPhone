//
//  BusTimeLookupController.m
//  ShuttleTrac
//
//  Created by Brady Law on 3/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusTimeLookupController.h"

@implementation BusTimeLookupController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	arrivalTimesTableController = [[BusTimesTableViewController alloc] initWithStyle:UITableViewStylePlain];
	[arrivalTimesTableController setView:busStopTableView]; 
	[busStopTableView setDataSource:arrivalTimesTableController];
	[busStopTableView setDelegate:arrivalTimesTableController];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark IBActions

-(IBAction)lookupBusStop:(UIButton *)submitButton {
	CLLocationCoordinate2D loc;
	loc.latitude = 0;
	loc.longitude = 0;
	busStop = [[BusStop alloc] initWithName:@"Courtyards"
								 stopNumber:[[busStopNumber text] intValue]
								   location:loc];
	
	busStopArrivals = [[BusStopArrivals alloc] initWithBusStop:busStop];
	
	// Refresh bus arrivals
	[busStopArrivals refreshUpcomingBuses];
	
	// TODO Use delegate or notification to figure out when we are done
	[arrivalTimesTableController setBusArrivals:busStopArrivals];
	[busStopTableView reloadData];
}

#pragma mark dealloc

- (void)dealloc {
	[busStop release];
	busStop = nil;
	
	[arrivalTimesTableController release];
	arrivalTimesTableController = nil;
	
    [super dealloc];
}


@end
