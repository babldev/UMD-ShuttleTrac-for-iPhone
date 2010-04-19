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

@class BusStop;

@interface BusArrival : NSObject {
	// Route for the arriving bus
	BusRoute *route;
	
	// Stop for the arriving bus
	BusStop *stop;
	
	// Arrival time for the bus
	NSDate *arrivalTime;
}

+(BusStop *)busArrivalWithRoute:(BusRoute *)bRoute stop:(BusStop *)bStop arrivalTime:(NSDate *)bArrivalTime;

-(id)initWithRoute:(BusRoute *)bRoute stop:(BusStop *)bStop arrivalTime:(NSDate *)bArrivalTime;

@property (assign, readonly) BusRoute *route;
@property (assign, readonly) BusStop *stop;
@property (retain, readonly) NSDate *arrivalTime;

@end
