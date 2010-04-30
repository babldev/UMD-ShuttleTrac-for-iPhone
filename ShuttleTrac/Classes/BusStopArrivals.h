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
#import "BusArrival.h"

@class BusStopArrivals;

@protocol BusStopArrivalsDelegate

-(void)arrivalsRefreshComplete:(BusStopArrivals *)arrivals;

@end

@interface BusStopArrivals : BusStop {
	// Route for the arriving buses (OPTIONAL)
	BusRoute *route;
	
	// NSArray of BusArrival
	NSMutableArray *upcomingBuses;
	
	// Time of last refresh
	NSDate *lastRefresh;
	
	//used for XML parsing
	BusArrival *currBusArrival;
	
	id <BusStopArrivalsDelegate> delegate;
	
	NSDictionary *routes; 
	NSDictionary *stops;
	
	
}

-(id)initWithBusStop:(BusStop *)bStop forBusRoute:(BusRoute *)bRoute;

-(void)refreshUpcomingBuses;

@property (assign, readonly) BusRoute *route;
@property (retain, readwrite) NSMutableArray *upcomingBuses;
@property (retain, readonly) NSDate *lastRefresh;
@property (assign, readwrite) id <BusStopArrivalsDelegate> delegate;

@end
