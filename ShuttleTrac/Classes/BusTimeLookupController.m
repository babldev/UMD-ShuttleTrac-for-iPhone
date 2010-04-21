//
//  BusTimeLookupController.m
//  ShuttleTrac
//
//  Created by Brady Law on 3/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusTimeLookupController.h"
#import "DataStoreGrabber.h"

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
	[busStop release];
	busStop = nil;
	
	[busStopArrivals release];
	busStopArrivals = nil;
	
	busStop = [[GetShuttleTracDataStore() allBusStops] objectAtIndex:0];
	busStopArrivals = [[BusStopArrivals alloc] initWithBusStop:busStop];
	[busStopArrivals setDelegate:self];
	
	// Refresh bus arrivals
	[busStopArrivals refreshUpcomingBuses];
}

#pragma mark -
#pragma mark BusStopArrivalsDelegate
-(void)arrivalsRefreshComplete:(BusStopArrivals *)arrivals {
	[arrivalTimesTableController setBusArrivals:arrivals];
	[busStopTableView reloadData];
}

#pragma mark dealloc

- (void)dealloc {
	[busStop release];
	busStop = nil;
	
	[busStopArrivals release];
	busStopArrivals = nil;
	
	[arrivalTimesTableController release];
	arrivalTimesTableController = nil;
	
    [super dealloc];
}


@end
