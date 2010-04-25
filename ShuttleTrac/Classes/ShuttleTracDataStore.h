//
//  ShuttleTracDataStore.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "BookmarkedStopsDataStore.h"
#import "BusMapDataStore.h"

#import "BusStopArrivals.h"
#import "BusStop.h"
#import "BusRoute.h"

@class BookmarkedStopsDataStore, BusMapDataStore;

@interface ShuttleTracDataStore : NSObject {
	// Database
	sqlite3 *database;
	
	BookmarkedStopsDataStore *bookmarkedStopsDataStore;
	BusMapDataStore *busMapDataStore;
		
@private
	// Temporary
	NSMutableArray *busStops;
	NSMutableArray *busRoutes;
	NSMutableString *parserString;
	NSString *databasePath;
	BusStop *currBusStop; //used for parsing

}

-(NSArray *)allBusStops;
-(NSArray *)allBusRoutes;

-(void)refreshStopAndRouteData;

@property (retain, readonly) BookmarkedStopsDataStore *bookmarkedStopsDataStore;
@property (retain, readonly) BusMapDataStore *busMapDataStore;

@end