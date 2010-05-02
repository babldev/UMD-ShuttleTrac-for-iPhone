//
//  ShuttleTracDataStore.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BookmarkedStopsDataStore.h"
#import "BusMapDataStore.h"

#import "BusStopArrivals.h"
#import "BusStop.h"
#import "BusRoute.h"

@class BookmarkedStopsDataStore, BusMapDataStore;

@interface ShuttleTracDataStore : NSObject <NSCoding>{
	//Test
	BookmarkedStopsDataStore *bookmarkedStopsDataStore;
	BusMapDataStore *busMapDataStore;
	
		
@private
	// Temporary
	NSMutableDictionary *busStops;
	NSMutableDictionary *busRoutes;
	NSInteger parsingMode;
	
	BusStop *currBusStop; //used for parsing
	BusRoute *currBusRoute;//used for parsing
	NSMutableArray *currRouteBusStops; //used for parsing
}

-(NSMutableDictionary *)allBusStops;
-(NSMutableDictionary *)allBusRoutes;

-(void)refreshStopAndRouteData;

@property (retain, readonly) BookmarkedStopsDataStore *bookmarkedStopsDataStore;
@property (retain, readonly) BusMapDataStore *busMapDataStore;

@end