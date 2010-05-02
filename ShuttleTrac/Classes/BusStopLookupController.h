//
//  BusStopLookupController.h
//  ShuttleTrac
//
//  Created by Brady Law on 3/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStopArrivals.h"
#import "BusMapDataStore.h"
#import "BusMapViewController.h"
#import "BookmarkedStopsDataStore.h"

@interface BusStopLookupController : UIViewController <BusMapDataStoreDelegate, BusMapViewControllerDelegate, UITableViewDataSource, UITableViewDelegate,
	UISearchBarDelegate> {
	IBOutlet UISearchBar *searchBar;
	IBOutlet UITableView *stopSelectorTableView;
	IBOutlet UIBarButtonItem *bookmarkButton;
	IBOutlet UIBarButtonItem *refreshButton;
	
	BusMapDataStore	*dataStore;
	BookmarkedStopsDataStore *bookmarksDataStore;
	
	BusMapViewController *busMapViewController;
	
	UITableViewController *stopSelectorTableViewController;
		
	NSTimer *refreshTimer;
}

-(IBAction)refreshView:(UIBarButtonItem *)sender;
-(IBAction)bookmarkActiveStop:(UIBarButtonItem *)sender;

@end
