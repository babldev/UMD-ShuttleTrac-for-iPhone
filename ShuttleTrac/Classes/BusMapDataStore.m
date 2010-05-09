//
//  BusMapDataStore.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusMapDataStore.h"
#import "DataStoreGrabber.h"

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
	if (self = [super init]) {
		dataStore = [[coder decodeObjectForKey:@"dataStore"] retain];
		mappedStops = [[coder decodeObjectForKey:@"mappedStops"] retain];
		activeStopArrivals = [[coder decodeObjectForKey:@"activeStopArrivals"] retain];
		activeRoute = [[coder decodeObjectForKey:@"activeRoute"] retain];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:dataStore forKey:@"dataStore"];
	[coder encodeObject:mappedStops forKey :@"mappedStops"];
	[coder encodeObject:activeStopArrivals forKey :@"activeStopArrivals"];
	[coder encodeObject:activeRoute forKey :@"activeRoute"];
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
	if (activeStopArrivals != nil) {
		self.activeStopArrivals.delegate = self;
		[activeStopArrivals refreshUpcomingBuses];
	} else
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

-(NSArray *)allRoutes {
	return [dataStore sortedRoutes];
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
