//
//  BusTimeLookupController.m
//  ShuttleTrac
//
//  Created by Brady Law on 3/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusStopLookupController.h"
#import "DataStoreGrabber.h"
#import "BusTimeTableViewCell.h"
#import "RouteSelectorTableViewCell.h"

#define REFRESH_RATE 30

@interface BusStopLookupController ( )
@property (retain, readwrite) NSTimer *refreshTimer;
@end


@implementation BusStopLookupController
@synthesize refreshTimer;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	ShuttleTracDataStore *mainDataStore = GetShuttleTracDataStore();
	dataStore = mainDataStore.busMapDataStore;
	bookmarksDataStore = mainDataStore.bookmarkedStopsDataStore;
	
	dataStore.delegate = self;
	
	stopSelectorTableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
	[stopSelectorTableViewController setView:stopSelectorTableView];
	
	BusStopArrivals *arrivals = dataStore.activeStopArrivals;
	if (arrivals != nil) {
		searchBar.text = [NSString stringWithFormat:@"%d", arrivals.stop.stopNumber];
		navItem.rightBarButtonItem = cancelButton;
	}
	
	[self setRefreshTimer:[NSTimer scheduledTimerWithTimeInterval:REFRESH_RATE target:dataStore
														 selector:@selector(loadSelectedBusArrivals)
														 userInfo:nil repeats:YES]];
}

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

-(IBAction)refreshView:(UIBarButtonItem *)sender {
	[dataStore loadSelectedBusArrivals];
}

/*
-(IBAction)bookmarkActiveStop:(UIBarButtonItem *)sender {
	NSMutableArray *bookmarkedStops = bookmarksDataStore.bookmarkedStops;
	BusStopArrivals *newBookmark = dataStore.activeStopArrivals;
	
	if (![bookmarkedStops containsObject:newBookmark])
		[bookmarkedStops insertObject:newBookmark atIndex:0];
}
*/

-(IBAction)cancelEditing:(UIBarButtonItem *)sender {
	searchBar.text = nil;
	[dataStore setActiveStop:nil];
	[dataStore loadSelectedBusArrivals];
	[navItem setRightBarButtonItem:nil animated:YES];
}

-(IBAction)doneEditing:(UIBarButtonItem *)sender {
	[searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark BusMapDataStoreDelegate
-(void)loadSelectedBusArrivalsCompleted:(BusStopArrivals *)arrivals {
	[stopSelectorTableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if ([dataStore activeStopArrivals] != nil)
		return [[[dataStore activeStopArrivals] upcomingBuses] count];
	else 
		return [[[dataStore allRoutes] allValues] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([dataStore activeStopArrivals] != nil) {
		static NSString *CellIdentifier = @"BusTimes";
		
		BusTimeTableViewCell *cell = (BusTimeTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[BusTimeTableViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.busArrival = [[[dataStore activeStopArrivals] upcomingBuses] objectAtIndex:indexPath.row];
			 
		return cell;
	} else {
		static NSString *CellIdentifier = @"BusRoutes";
		
		RouteSelectorTableViewCell *cell = (RouteSelectorTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[RouteSelectorTableViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.route = [[[dataStore allRoutes] allValues] objectAtIndex:indexPath.row];
		
		return cell;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([dataStore activeStopArrivals] != nil) {
		return [[dataStore activeStopArrivals] getBusStopName];
	} else {
		return @"Or Select Route";
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	BusStopArrivals *arrivals = [dataStore activeStopArrivals];
	
	if ([dataStore activeStopArrivals] != nil)
		return [NSString stringWithFormat:@"Last Update: %@", [[arrivals lastRefresh] description]];
	else
		return nil;

}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([dataStore activeStopArrivals] == nil) {
		dataStore.activeRoute = [[[dataStore allRoutes] allValues] objectAtIndex:indexPath.row];
		
		if (busMapViewController == nil) {
			busMapViewController = [[BusMapViewController alloc] initWithNibName:@"BusMapViewController" bundle:nil];
		}
		
		busMapViewController.delegate = self;
		busMapViewController.dataStore = dataStore;
		[self presentModalViewController:busMapViewController animated:YES];
		[busMapViewController reloadMap];
	}
}

#pragma mark BusMapViewControllerDelegate

-(void)busStopSelected:(BusStop *)stop {
	[self dismissModalViewControllerAnimated:YES];
	
	if (stop != nil) {
		[dataStore setActiveStop:stop];
		searchBar.text = [NSString stringWithFormat:@"%d", dataStore.activeStopArrivals.stop.stopNumber];
		navItem.rightBarButtonItem = cancelButton;
	}
	
	[dataStore loadSelectedBusArrivals];
	[stopSelectorTableViewController.tableView reloadData];
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)sBar {
	[navItem setRightBarButtonItem:doneButton animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)sBar {
	
	if ([dataStore activeStopArrivals] != nil) {
		[navItem setRightBarButtonItem:cancelButton animated:YES];
	} else 
		[navItem setRightBarButtonItem:nil animated:YES];
}

- (void)searchBar:(UISearchBar *)sBar textDidChange:(NSString *)searchText {
	if ([searchText length] == 5) { // Set the active stop
		[searchBar resignFirstResponder];
		
		[dataStore setActiveStopWithStopId:[searchText intValue]];
		[dataStore loadSelectedBusArrivals];
		
		if ([dataStore activeStopArrivals] != nil) {
			[navItem setRightBarButtonItem:cancelButton animated:YES];
		}
	} else if (dataStore.activeStopArrivals != nil) { // Clear the active stop
		[dataStore setActiveStop:nil];
		[dataStore loadSelectedBusArrivals];
		
		if ([searchText length] == 0) {
			[sBar resignFirstResponder];
		}
	}
}

#pragma mark dealloc

- (void)dealloc {
	[stopSelectorTableViewController release];
	stopSelectorTableViewController = nil;
	
	[busMapViewController release];
	busMapViewController = nil;
	
	[refreshTimer release];
	refreshTimer = nil;
	
    [super dealloc];
}


@end
