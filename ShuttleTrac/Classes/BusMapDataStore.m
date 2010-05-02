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

- (id)initWithCoder:(NSCoder *)coder {
    mappedStops = [[coder decodeObjectForKey:@"mappedStops"] retain];
    activeStopArrivals = [[coder decodeObjectForKey:@"activeStopArrivals"] retain];
    activeRoute = [[coder decodeObjectForKey:@"activeRoute"] retain];
	dataStore = [[coder decodeObjectForKey:@"dataStore"] retain]; //Extremely inefficient
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:mappedStops forKey :@"mappedStops"];
	[coder encodeObject:activeStopArrivals forKey :@"activeStopArrivals"];
	[coder encodeObject:activeRoute forKey :@"activeRoute"];
	[coder encodeObject:dataStore forKey :@"dataStore"];
}

-(void)setActiveStop:(BusStop *)bStop {
	if (bStop != nil) {
		BusStopArrivals *newArrivals = [[[BusStopArrivals alloc] initWithBusStop:bStop forBusRoute:nil] autorelease];
		newArrivals.delegate = self;
		self.activeStopArrivals = newArrivals;
	} else {
		[self setActiveStopArrivals:nil];
	}
}

-(void)setActiveStopWithStopId:(NSInteger)stopId {
	BusStop *stop = [[dataStore allBusStops] objectForKey:[NSNumber numberWithInt:stopId]];
	[self setActiveStop:stop];
}

// Begin loading of upcoming buses for activeStop
-(void)loadSelectedBusArrivals {
	if (activeStopArrivals != nil)
		[activeStopArrivals refreshUpcomingBuses];
	else
		[delegate loadSelectedBusArrivalsCompleted:nil];
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
