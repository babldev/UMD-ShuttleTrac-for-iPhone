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
@end

@implementation BusMapDataStore

@synthesize mappedStops, activeRoute, activeStop, delegate;

-(id)initWithDataStore:(ShuttleTracDataStore *)dStore {
	if (self = [super init]) {
		dataStore = dStore;
		
		// FIXME - This isn't necessary
		self.activeStop.delegate = self;
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    mappedStops = [[coder decodeObjectForKey:@"mappedStops"] retain];
    activeStop = [[coder decodeObjectForKey:@"activeStop"] retain];
    activeRoute = [[coder decodeObjectForKey:@"activeRoute"] retain];
	dataStore = [[coder decodeObjectForKey:@"dataStore"] retain]; //Extremely inefficient
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:mappedStops forKey :@"mappedStops"];
	[coder encodeObject:activeStop forKey :@"activeStop"];
	[coder encodeObject:activeRoute forKey :@"activeRoute"];
	[coder encodeObject:dataStore forKey :@"dataStore"];

}

// Begin loading of upcoming buses for activeStop
-(void)loadSelectedBusArrivals {
	[self.activeStop refreshUpcomingBuses];
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
-(void)arrivalsRefreshComplete:(BusStopArrivals *)arrivals {
	[delegate loadSelectedBusArrivalsCompleted:activeStop];
}

#pragma mark dealloc
-(void)dealloc {
	[mappedStops release];
	[activeStop release];
	[activeRoute release];
	
	[super dealloc];
}

@end
