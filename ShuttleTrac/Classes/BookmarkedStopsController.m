//
//  BookmarkedStopsController.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusTimeTableViewCell.h"
#import "BookmarkedStopsController.h"
#import "DataStoreGrabber.h"

@implementation BookmarkedStopsController

@synthesize dataStore;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	dataStore = GetShuttleTracDataStore();
	bookmarkedStops = [dataStore bookmarkedStops];
	
	tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[tableViewController setView:tableView];
	
	// Get new arrivals for all bookmarked stops
	for (BusStopArrivals *bookmarkStop in bookmarkedStops) {
		[bookmarkStop setDelegate:self];
		[bookmarkStop refreshUpcomingBuses];
	}
	
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [bookmarkedStops count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSArray *arrivals = [[bookmarkedStops objectAtIndex:section] upcomingBuses];
    return [arrivals count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BookmarkedStops";
    
    BusTimeTableViewCell *cell = (BusTimeTableViewCell *) [tView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BusTimeTableViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSArray *arrivals = [[bookmarkedStops objectAtIndex:[indexPath section]] upcomingBuses];
    [cell setBusArrival:[arrivals objectAtIndex:[indexPath row]]];
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[bookmarkedStops objectAtIndex:section] name];
}

#pragma mark -
#pragma mark BusStopArrivalsDelegate protocol
-(void)arrivalsRefreshComplete:(BusStopArrivals *)arrivals {
	[tableView reloadData];
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
