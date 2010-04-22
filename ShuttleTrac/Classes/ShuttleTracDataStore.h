//
//  ShuttleTracDataStore.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "BusStopArrivals.h"
#import "BusStop.h"
#import "BusRoute.h"

@interface ShuttleTracDataStore : NSObject {
	NSMutableArray *bookmarkedStops;
	
	sqlite3 *database;
	
@private
	// Temporary
	NSMutableArray *busStops;
	NSMutableArray *busRoutes;
}

-(NSArray *)allBusStops;
-(NSArray *)allBusRoutes;

// Send notifications
-(void)refreshAllBookmarkedStops;

@property (retain, readonly) NSMutableArray *bookmarkedStops;

@end