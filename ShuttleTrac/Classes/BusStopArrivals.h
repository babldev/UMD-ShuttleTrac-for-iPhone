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


@class BusStop;

@interface BusStopArrivals : NSObject {
	// Stop for the arriving buses (REQUIRED)
	BusStop *stop;
	
	// Route for the arriving buses (OPTIONAL)
	BusRoute *route;
	
	// NSArray of BusArrival
	NSArray *upcomingBuses;
	
	// Time of last refresh
	NSDate *lastRefresh;
	
	id <BusStopArrivalsDelegate> delegate;
}

-(id)initWithBusStop:(BusStop *)bStop;
-(id)initWithBusStop:(BusStop *)bStop forBusRoute:(BusRoute *)bRoute;

-(void)refreshUpcomingBuses;

@property (assign, readonly) BusRoute *route;
@property (assign, readonly) BusStop *stop;
@property (retain, readonly) NSArray *upcomingBuses;
@property (retain, readonly) NSDate *lastRefresh;
@property (assign, readwrite) id <BusStopArrivalsDelegate> delegate;

@end
