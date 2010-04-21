//
//  BusArrival.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusStopArrivals.h"
#import "DataStoreGrabber.h"

@interface BusStopArrivals ()

@property (assign, readwrite) BusRoute *route;
@property (assign, readwrite) BusStop *stop;
@property (retain, readwrite) NSArray *upcomingBuses;
@property (retain, readwrite) NSDate *lastRefresh;

@end



@implementation BusStopArrivals

@synthesize route, stop, upcomingBuses, lastRefresh, delegate;

-(id)initWithBusStop:(BusStop *)bStop {
	if (self = [super init]) {
		[self setStop:bStop];
	}
	
	return self;
}

-(id)initWithBusStop:(BusStop *)bStop forBusRoute:(BusRoute *)bRoute {
	if (self = [super init]) {
		[self setStop:bStop];
		[self setRoute:bRoute];
	}
	
	return self;
}

#pragma mark -
#pragma mark Refresh routes
-(void)refreshUpcomingBuses {
	// Set last refresh to today
	[self setLastRefresh:[NSDate date]];
	 
	 // TODO - Implement XML fetching of bus times
	 // TAREK - Implement your code here
	BusRoute *badRoute = [[GetShuttleTracDataStore() allBusRoutes] objectAtIndex:0];
	[self setUpcomingBuses:[NSArray arrayWithObject:
							[BusArrival busArrivalWithRoute:badRoute
													   stop:[self stop] 
												arrivalTime:[NSDate date]]]];
	[delegate arrivalsRefreshComplete:self];
}

@end
