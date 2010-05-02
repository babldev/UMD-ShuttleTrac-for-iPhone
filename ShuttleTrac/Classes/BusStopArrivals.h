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

@interface BusStopArrivals : BusStop <NSCoding> {
	// Route for the arriving buses
	BusRoute *route;
	
	// NSArray of BusArrival
	NSMutableArray *upcomingBuses;
	
	// Time of last refresh
	NSDate *lastRefresh;
	
	id <BusStopArrivalsDelegate> delegate;
	
	// ----
	
	BOOL refreshing;
	
	// From ShuttleTracDataStore
	NSDictionary *routes; 
	NSDictionary *stops;
	
	//used for XML parsing
	BusArrival *currBusArrival;
	
	NSInteger currRouteNum;
	
	NSMutableArray *newUpcomingBuses;
}

-(id)initWithBusStop:(BusStop *)bStop forBusRoute:(BusRoute *)bRoute;

-(void)refreshUpcomingBuses;

@property (assign, readonly) BusRoute *route;
@property (retain, readonly) NSArray *upcomingBuses;
@property (retain, readonly) NSDate *lastRefresh;
@property (assign, readwrite) id <BusStopArrivalsDelegate> delegate;

@end
