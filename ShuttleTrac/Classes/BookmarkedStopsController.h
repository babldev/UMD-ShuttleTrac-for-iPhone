//
//  BookmarkedStopsController.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShuttleTracDataStore.h"

@interface BookmarkedStopsController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tableView;
	ShuttleTracDataStore *dataStore;
	
	UITableViewController *tableViewController;
}

@property (assign, readwrite) ShuttleTracDataStore *dataStore;

@end
