//
//  BusArrival.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStopArrivals.h"
#import "DataStoreGrabber.h"

@interface BusStopArrivals ()

@property (assign, readwrite) BusRoute *route;
@property (retain, readwrite) NSArray *upcomingBuses;
@property (retain, readwrite) NSDate *lastRefresh;

@end



@implementation BusStopArrivals

@synthesize route, upcomingBuses, lastRefresh, delegate;

-(id)initWithBusStop:(BusStop *)bStop forBusRoute:(BusRoute *)bRoute {
	if (self = [super initWithBusStop:bStop]) {
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
	ShuttleTracDataStore *dataStore = GetShuttleTracDataStore();
	// BusRoute *badRoute = [[dataStore allBusRoutes] objectAtIndex:0];
	[self setUpcomingBuses:[NSArray arrayWithObject:
							[BusArrival busArrivalWithRoute:nil
													   stop:self 
												arrivalTime:[NSDate date]]]];
	[delegate arrivalsRefreshComplete:self];
}

@end
