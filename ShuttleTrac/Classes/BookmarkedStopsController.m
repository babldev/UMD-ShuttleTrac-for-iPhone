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
#import "BusStopArrivals.h"

#define REFRESH_RATE 30

@interface BookmarkedStopsController ( )

@property (retain, readwrite) NSTimer *refreshTimer;

-(void)refreshBookmarks;

@end


@implementation BookmarkedStopsController

@synthesize refreshTimer;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	dataStore = [GetShuttleTracDataStore() bookmarkedStopsDataStore];
	bookmarkedStops = [dataStore bookmarkedStops];
	
	[self setRefreshTimer:[NSTimer scheduledTimerWithTimeInterval:REFRESH_RATE target:self
													  selector:@selector(refreshBookmarks)
													  userInfo:nil repeats:YES]];
	
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
	return [[bookmarkedStops objectAtIndex:section] getBusStopName];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return [NSString stringWithFormat:@"Last Update: %@", [[[bookmarkedStops objectAtIndex:section] lastRefresh] description]];
}

-(void)refreshBookmarks {
	// Get new arrivals for all bookmarked stops
	for (BusStopArrivals *bookmarkStop in bookmarkedStops) {
		[bookmarkStop setDelegate:self];
		[bookmarkStop refreshUpcomingBuses];
	}
}

#pragma mark -
#pragma mark BusStopArrivalsDelegate protocol
-(void)arrivalsRefreshComplete:(BusStopArrivals *)arrivals {
	[tableView reloadData];
}

#pragma mark -
#pragma mark Actions

-(IBAction)refreshBookmarksPressed:(UIBarButtonItem *)sender {
	// Get new arrivals for all bookmarked stops
	for (BusStopArrivals *bookmarkStop in bookmarkedStops) {
		[bookmarkStop setDelegate:self];
		[bookmarkStop refreshUpcomingBuses];
	}
}

-(IBAction)editBookmarks:(UIBarButtonItem *)sender {
	if (bookmarksEditorController == nil) {
		bookmarksEditorController = [[BookmarksEditorController alloc] initWithNibName:@"BookmarksEditorController"
																				bundle:nil];
	}
	
	bookmarksEditorController.delegate = self;
	bookmarksEditorController.bookmarkedStops = [[bookmarkedStops mutableCopy] autorelease];
	bookmarksEditorController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	
	[self presentModalViewController:bookmarksEditorController animated:YES];
}

#pragma mark -
#pragma mark BookmarksEditorControllerDelegate

-(void)bookmarkEditingCompleted:(NSArray *)bookmarks {
	[self dismissModalViewControllerAnimated:YES];
	[bookmarkedStops setArray:bookmarks];
	
	[self refreshBookmarks];
	[tableView reloadData];
}

-(void)bookmarkEditingCancelled {
	[self dismissModalViewControllerAnimated:YES];
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
	[bookmarksEditorController release];
	bookmarksEditorController = nil;
	
	[refreshTimer release];
	refreshTimer = nil;
	
    [super dealloc];
}


@end
