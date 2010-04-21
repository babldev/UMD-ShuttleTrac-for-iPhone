//
//  ShuttleTracDataStore.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShuttleTracDataStore.h"

@interface ShuttleTracDataStore ( )

@property (retain, readwrite) NSMutableArray	*bookmarkedStops;
@property (retain, readwrite) NSArray			*bookmarkedStopsArrivals;

@end


@implementation ShuttleTracDataStore

@synthesize bookmarkedStops, bookmarkedStopsArrivals;

-(id)init {
	if (self = [super init]) {
		// FIXME
		CLLocationCoordinate2D loc;
		loc.latitude = 0;
		loc.longitude = 0;
		
		busStops = [[NSArray arrayWithObject:
					[BusStop busStopWithName:@"Courtyards" stopNumber:1 location:loc]] retain];
		busRoutes = [[NSArray arrayWithObject:
					 [BusRoute busRouteWithID:1 name:@"Purple" stops:nil]] retain];
	}
	
	return self;
}

-(NSArray *)allBusStops {
	return busStops;
}

-(NSArray *)allBusRoutes {
	return busRoutes;
}

-(void)refreshAllBookmarkedStops {
}

-(void)dealloc {
	[busStops release];
	[busRoutes release];
	[super dealloc];
}

@end
