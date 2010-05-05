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

#define STOP_SECTION		0
#define BOOKMARK_SECTION	1

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
	
	// Update bookmark button if we have an active stop
	if (dataStore.activeStopArrivals != nil)
		bookmarkCell.bookmarked = [bookmarksDataStore containsStop:dataStore.activeStopArrivals];
	
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
	// Stop selected
    if ([dataStore activeStopArrivals] != nil)
		/*
		Section 1 - Upcoming Arrivals
		Section 2 - Add/Remove Bookmark
		 */
		return 2;
	
	// Select route
	else 
		// Section 1 - All Routes
		return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Stop selected
	if ([dataStore activeStopArrivals] != nil) {
		/*
		 Section 1 - Upcoming Arrivals
		 Section 2 - Add/Remove Bookmark
		 */
		
		if (section == STOP_SECTION)
			return [[[dataStore activeStopArrivals] upcomingBuses] count];
		else
			return 1; // Add/remove bookmark button
	}
	
	// Select route
	else 
		return [[[dataStore allRoutes] allValues] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Stop selected
    if ([dataStore activeStopArrivals] != nil) {
		
		// Section 1 - Upcoming Arrivals
		if ([indexPath section] == STOP_SECTION) {
			static NSString *CellIdentifier = @"BusTimes";
			
			BusTimeTableViewCell *cell = (BusTimeTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[BusTimeTableViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
			}
			
			cell.busArrival = [[[dataStore activeStopArrivals] upcomingBuses] objectAtIndex:indexPath.row];
				 
			return cell;
		}
		
		// Section 2 - Add/Remove Bookmark
		else {
			return bookmarkCell;
		}
	}
	
	// Select route
	else {
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
	// Stop selected
	if ([dataStore activeStopArrivals] != nil) {
		if (section == STOP_SECTION)
			return [[dataStore activeStopArrivals] getBusStopName];
		else
			return nil;
	}
	
	// Route selected
	else {
		return @"Or Select Route";
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	BusStopArrivals *arrivals = [dataStore activeStopArrivals];
	
	if ([dataStore activeStopArrivals] != nil)
		if (section == STOP_SECTION)
			return [NSString stringWithFormat:@"Last Update: %@", [[arrivals lastRefresh] description]];
		else
			return nil;
	else
		return nil;

}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([dataStore activeStopArrivals] != nil) {
		// BOOKMARK_SECTION
		if (indexPath.section == BOOKMARK_SECTION) {
			BusStopArrivals *activeStop = dataStore.activeStopArrivals;
			
			if (![bookmarksDataStore containsStop:activeStop]) {
				[bookmarksDataStore addStopToBookmarks:activeStop];
				bookmarkCell.bookmarked = YES;
			} else {
				[bookmarksDataStore removeStopFromBookmarks:activeStop];
				bookmarkCell.bookmarked = NO;
			}

			bookmarkCell.selected = NO;
		}
	} else  {
		dataStore.activeRoute = [[[dataStore allRoutes] allValues] objectAtIndex:indexPath.row];
		
		if (busMapViewController == nil) {
			busMapViewController = [[BusMapViewController alloc] initWithNibName:@"BusMapViewController" bundle:nil];
		}
		
		busMapViewController.delegate = self;
		busMapViewController.dataStore = dataStore;
		busMapViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		
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
