//
//  BusMapDataStore.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShuttleTracDataStore.h"
#import "BusStopArrivals.h"

@class ShuttleTracDataStore;

@protocol BusMapDataStoreDelegate

-(void)loadSelectedBusArrivalsCompleted:(BusStopArrivals *)arrivals;
// -(void)loadStopsForActiveRouteCompleted:(NSDictionary *)stops;

@end


@interface BusMapDataStore : NSObject <BusStopArrivalsDelegate, NSCoding>{
	ShuttleTracDataStore *dataStore;
	
	// All mapped stops
	NSArray *mappedStops;

	BusRoute *activeRoute;
	BusStopArrivals *activeStopArrivals;
	
	id <BusMapDataStoreDelegate> delegate;
}

-(id)initWithDataStore:(ShuttleTracDataStore *)dStore;

-(void)setActiveStop:(BusStop *)bStop;
-(void)setActiveStopWithStopId:(NSInteger)stopId;

// Begin loading of upcoming buses for activeStop
-(void)loadSelectedBusArrivals;

// Load all stops for activeRoute
-(void)loadStopsForActiveRoute;

-(NSMutableDictionary *)allRoutes;


@property (retain, readonly) NSArray *mappedStops;
@property (retain, readwrite) BusRoute *activeRoute;
@property (retain, readonly) BusStopArrivals *activeStopArrivals;

@property (assign, readwrite) id <BusMapDataStoreDelegate> delegate;

@end
