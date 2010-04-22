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
	// BookmarkedStops Data
	NSMutableArray *bookmarkedStops;	
	
	// BusMap Data
	BusStopArrivals *mapActiveStop;
	sqlite3 *database;
	
	NSInteger temp; // used for testing purposes REMOVE! 

	
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

// Send notifications
-(void)refreshAllBookmarkedStops;

@property (retain, readonly) NSMutableArray *bookmarkedStops;
@property (retain, readwrite) BusStopArrivals *mapActiveStop;

@end