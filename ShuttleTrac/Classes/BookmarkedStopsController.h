//
//  BookmarkedStopsController.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShuttleTracDataStore.h"
#import "BusStopArrivals.h"

@interface BookmarkedStopsController : UIViewController <BusStopArrivalsDelegate, UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tableView;
	ShuttleTracDataStore *dataStore;
	
	NSMutableArray *bookmarkedStops;
	NSMutableDictionary *bookmarkedStopsArrivals;
	
	UITableViewController *tableViewController;
}

-(IBAction)refreshBookmarks:(UIBarButtonItem *)sender;

@property (assign, readwrite) ShuttleTracDataStore *dataStore;

@end
