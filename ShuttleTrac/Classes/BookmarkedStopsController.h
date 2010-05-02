//
//  BookmarkedStopsController.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkedStopsDataStore.h"
#import "BusStopArrivals.h"
#import "BookmarksEditorController.h"

@interface BookmarkedStopsController : UIViewController <BusStopArrivalsDelegate, 
		UITableViewDelegate, 
		UITableViewDataSource,
		BookmarksEditorControllerDelegate> {
	BookmarkedStopsDataStore *dataStore;
	BookmarksEditorController *bookmarksEditorController;
	
	NSMutableArray *bookmarkedStops;
	NSMutableDictionary *bookmarkedStopsArrivals;
	
	UITableViewController *tableViewController;
	
	NSTimer *refreshTimer;
			
	IBOutlet UIBarButtonItem *refreshButton;
	IBOutlet UIBarButtonItem *editButton;
	IBOutlet UITableView *tableView;
}

-(IBAction)refreshBookmarksPressed:(UIBarButtonItem *)sender;
-(IBAction)editBookmarks:(UIBarButtonItem *)sender;

@end
