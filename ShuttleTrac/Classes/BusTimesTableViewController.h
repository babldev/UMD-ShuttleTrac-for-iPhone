//
//  BusTimesTableViewController.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStopArrivals.h"

@interface BusTimesTableViewController : UITableViewController {
	BusStopArrivals *busArrivals;
}

@property (retain, readwrite) BusStopArrivals *busArrivals;

@end
