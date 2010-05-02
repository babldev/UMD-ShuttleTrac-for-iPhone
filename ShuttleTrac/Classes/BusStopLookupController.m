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

@interface BusStopLookupController ( )
-(void)updateBookmarkLock;
@end


@implementation BusStopLookupController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	ShuttleTracDataStore *mainDataStore = GetShuttleTracDataStore();
	dataStore = mainDataStore.busMapDataStore;
	bookmarksDataStore = mainDataStore.bookmarkedStopsDataStore;
	
	dataStore.delegate = self;
	
	stopSelectorTableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
	[stopSelectorTableViewController setView:stopSelectorTableView];
	
	[dataStore loadSelectedBusArrivals];
	[self updateBookmarkLock];
}

-(void)updateBookmarkLock {
	NSMutableArray *bookmarkedStops = bookmarksDataStore.bookmarkedStops;
	BusStopArrivals *newBookmark = dataStore.activeStop;
	
	bookmarkButton.enabled = (![bookmarkedStops containsObject:newBookmark]);
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

-(IBAction)bookmarkActiveStop:(UIBarButtonItem *)sender {
	NSMutableArray *bookmarkedStops = bookmarksDataStore.bookmarkedStops;
	BusStopArrivals *newBookmark = dataStore.activeStop;
	
	if (![bookmarkedStops containsObject:newBookmark])
		[bookmarkedStops insertObject:newBookmark atIndex:0];
	
	[self updateBookmarkLock];
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
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0)
		return [[[dataStore activeStop] upcomingBuses] count];
	else 
		return [[[dataStore allRoutes] allValues] count]+1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
		static NSString *CellIdentifier = @"BusTimes";
		
		BusTimeTableViewCell *cell = (BusTimeTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[BusTimeTableViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.busArrival = [[[dataStore activeStop] upcomingBuses] objectAtIndex:indexPath.row];
			 
		return cell;
	} else {
		static NSString *CellIdentifier = @"BusRoutes";
		
		RouteSelectorTableViewCell *cell = (RouteSelectorTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[RouteSelectorTableViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		}
		
		if (indexPath.row == 0) {
			cell.route = nil;
		} else {
			cell.route = [[[dataStore allRoutes] allValues] objectAtIndex:(indexPath.row - 1)];
		}
		
		return cell;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return [[dataStore activeStop] name];
	} else {
		return @"Select Route";
	}
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		if (indexPath.row == 0)
			dataStore.activeRoute = nil;
		else
			dataStore.activeRoute = [[[dataStore allRoutes] allValues] objectAtIndex:(indexPath.row - 1)];
		
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
		dataStore.activeStop = [[BusStopArrivals alloc] initWithBusStop: stop forBusRoute:nil];
		searchBar.text = [NSString stringWithFormat:@"%d", dataStore.activeStop.stopNumber];
	}
	
	[dataStore loadSelectedBusArrivals];
	[stopSelectorTableViewController.tableView reloadData];
	
	[self updateBookmarkLock];
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)sBar {
	[sBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)sBar {
	[sBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)sBar textDidChange:(NSString *)searchText {
	if ([searchText length] == 5) { // Set the active stop
		[searchBar resignFirstResponder];
		
		// FIXME
		dataStore.activeStop = nil;
		
		[dataStore loadSelectedBusArrivals];
		[stopSelectorTableViewController.tableView reloadData];
	} else if (dataStore.activeStop != nil) { // Clear the active stop
		dataStore.activeStop = nil;
		
		[dataStore loadSelectedBusArrivals];
		[stopSelectorTableViewController.tableView reloadData];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)sBar {
	[sBar resignFirstResponder];
}

#pragma mark dealloc

- (void)dealloc {
	[stopSelectorTableViewController release];
	stopSelectorTableViewController = nil;
	
	[busMapViewController release];
	busMapViewController = nil;
	
    [super dealloc];
}


@end
