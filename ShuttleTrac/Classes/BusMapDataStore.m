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
		activeRoute = [[dataStore allBusRoutes] objectAtIndex:0];
	}
	
	return self;
}

// Begin loading of upcoming buses for activeStop
-(void)loadSelectedBusArrivals {
}

// Load all stops for activeRoute
-(void)loadStopsForActiveRoute {
	self.mappedStops = [dataStore allBusStops];
}

-(NSArray *)allRoutes {
	return [dataStore allBusRoutes];
}

@end
