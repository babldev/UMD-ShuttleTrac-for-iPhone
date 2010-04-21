//
//  BusTimeLookupController.h
//  ShuttleTrac
//
//  Created by Brady Law on 3/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStopArrivals.h"

@interface BusTimeLookupController : UIViewController <BusStopArrivalsDelegate, UITableViewDataSource> {
	IBOutlet UITextField *busStopNumber;
	IBOutlet UITableView *busStopTableView;
	
	BusStop *busStop;
	BusStopArrivals *busStopArrivals;
	
	UITableViewController *arrivalTimesTableController;
}

-(IBAction)lookupBusStop:(UIButton *)submitButton;

@end
