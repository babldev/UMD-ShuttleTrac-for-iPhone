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
#import "NSDateAdditions.h"

#define REFRESH_RATE 60

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
	
	
	
	for (BusStopArrivals *bookmarkStop in bookmarkedStops) 
		[bookmarkStop cleanArrivals];
	
	[self refreshBookmarks];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(bookmarksRefreshNeeded) 
												 name:BookmarksDidChange 
											   object:nil];
	
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	NSInteger size = [bookmarkedStops count];
    return size == 0 ? 1 : size;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSInteger size = [bookmarkedStops count];
	if(size == 0)
		return 0;
	
	return [[[bookmarkedStops objectAtIndex:section] upcomingBusRoutes] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BusTimeCell";
    
    BusTimeTableViewCell *cell = (BusTimeTableViewCell *) [tView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BusTimeTableViewCell" 
																 owner:self 
															   options:nil];
		
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (BusTimeTableViewCell *) currentObject;
				break;
			}
		}
	}
    
    // Configure the cell...
	// NSArray *arrivals = [[bookmarkedStops objectAtIndex:[indexPath section]] upcomingBusRoutes];
    NSArray *upcomingRoutes = [[bookmarkedStops objectAtIndex:[indexPath section]] upcomingBusRoutes];
	[cell setArrivals:[upcomingRoutes objectAtIndex:[indexPath row]]];
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if([bookmarkedStops count] == 0)
		return @"No Bookmarked Stops";
	return [[bookmarkedStops objectAtIndex:section] getBusStopName];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if(section == ([bookmarkedStops count] -1)) {
		NSDate *lastRefresh = [[bookmarkedStops objectAtIndex:section] lastRefresh];
		if (lastRefresh != nil)
			return [NSString stringWithFormat:@"Last Update: %@", [lastRefresh timeOfDayLocalizedString]];
	}
		
	return nil;
}

-(void)refreshBookmarks {
	bookmarkedStops = dataStore.bookmarkedStops;
	
	for (BusStopArrivals *bookmarkStop in bookmarkedStops) {
		[bookmarkStop setDelegate:self];
		[bookmarkStop refreshUpcomingBuses];
	}
	
	NSInteger count = [bookmarkedStops count];
	UIView *introSuperView = [introView superview];
	
	if (count == 0 && introSuperView == nil) {
		[tableView addSubview:introView];
		[tableView setUserInteractionEnabled:NO];
	} else if (count > 0 && introSuperView != nil) {
		[introView removeFromSuperview];
		[tableView setUserInteractionEnabled:YES];
	}
	
	[tableView reloadData];
}

#pragma mark -
#pragma mark BusStopArrivalsDelegate protocol
-(void)arrivalsRefreshComplete:(BusStopArrivals *)arrivals {
	[tableView reloadData];
}

#pragma mark -
#pragma mark Actions

-(IBAction)refreshBookmarksPressed:(UIBarButtonItem *)sender {
	[self refreshBookmarks];
}

-(IBAction)editBookmarks:(UIBarButtonItem *)sender {
	if (bookmarksEditorController == nil) {
		bookmarksEditorController = [[BookmarksEditorController alloc] initWithNibName:@"BookmarksEditorController"
																			bundle:nil];
		bookmarksEditorController.delegate = self;
		bookmarksEditorController.bookmarkedStops = [[bookmarkedStops mutableCopy] autorelease];
		bookmarksEditorController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	} else {
		bookmarksEditorController.bookmarkedStops = [[bookmarkedStops mutableCopy] autorelease];
		[bookmarksEditorController.tableView reloadData];
	}
	
	
	
	
	[self presentModalViewController:bookmarksEditorController animated:YES];
}

#pragma mark -
#pragma mark BookmarksEditorControllerDelegate

-(void)bookmarkEditingCompleted:(NSArray *)bookmarks {
	[dataStore replaceBookmarks:bookmarks];
	
	[self refreshBookmarks];
	[tableView reloadData];
	
	[self dismissModalViewControllerAnimated:YES];
}

-(void)bookmarkEditingCancelled {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark BookmarksDidChange Observer
-(void)bookmarksRefreshNeeded {
	[self refreshBookmarks];
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
	
	[[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:BookmarksDidChange];
	
    [super dealloc];
}


@end
