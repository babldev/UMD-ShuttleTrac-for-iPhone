//
//  BusTimesTableViewController.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusArrival.h"

@interface BusTimesTableViewController : UITableViewController {
	NSArray *busArrivals;
}

@property (retain, readwrite) NSArray *busArrivals;

@end
