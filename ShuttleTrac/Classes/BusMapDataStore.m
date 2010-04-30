//
//  BusMapDataStore.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusMapDataStore.h"

@interface BusMapDataStore ( )
@property (retain, readwrite) NSArray *mappedStops;
@property (retain, readwrite) BusStopArrivals *activeStopArrivals;
@end

@implementation BusMapDataStore

@synthesize mappedStops, activeRoute, activeStopArrivals, delegate;

-(id)initWithDataStore:(ShuttleTracDataStore *)dStore {
	if (self = [super init]) {
		dataStore = dStore;
	}
	
	return self;
}

-(void)setActiveStop:(BusStop *)bStop {
	BusStopArrivals *newArrivals = [[[BusStopArrivals alloc] initWithBusStop:bStop forBusRoute:nil] autorelease];
	newArrivals.delegate = self;
	self.activeStopArrivals = newArrivals;
}

// Begin loading of upcoming buses for activeStop
-(void)loadSelectedBusArrivals {
	[activeStopArrivals refreshUpcomingBuses];
}

// Load all stops for activeRoute
-(void)loadStopsForActiveRoute {
	if (activeRoute == nil) {
		self.mappedStops = [[dataStore allBusStops] allValues];
	} else {
		self.mappedStops = [activeRoute stops];
	}
}

-(NSMutableDictionary *)allRoutes {
	return [dataStore allBusRoutes];
}

#pragma mark BusStopArrivalsDelegate
-(void)arrivalsRefreshComplete:(BusStopArrivals *)bArrivals {
	[delegate loadSelectedBusArrivalsCompleted:activeStopArrivals];
}

#pragma mark dealloc
-(void)dealloc {
	[mappedStops release];
	[activeStopArrivals release];
	[activeRoute release];
	
	[super dealloc];
}

@end
