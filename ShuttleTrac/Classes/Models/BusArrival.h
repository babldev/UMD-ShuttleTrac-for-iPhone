//
//  BusArrival.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BusStop.h"
#import "BusRoute.h"

@interface BusArrival : NSObject {
	// Route for the arriving bus
	BusRoute *route;
	
	// Stop for the arriving bus
	BusStop *stop;
	
	// Arrival time for the bus
	NSDate *arrivalTime;
}

@property (retain, readonly) BusRoute *route;
@property (retain, readonly) BusStop *stop;
@property (retain, readonly) NSDate *arrivalTime;

@end
