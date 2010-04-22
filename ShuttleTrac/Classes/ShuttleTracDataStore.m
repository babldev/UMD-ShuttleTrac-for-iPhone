//
//  ShuttleTracDataStore.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShuttleTracDataStore.h"

@interface ShuttleTracDataStore ( )

-(void)loadStopsAndRouteFromSQL;

@property (retain, readwrite) NSMutableArray			*bookmarkedStops;

@end


@implementation ShuttleTracDataStore

@synthesize bookmarkedStops, mapActiveStop;

-(id)init {
	if (self = [super init]) {
		busStops = [[NSMutableArray alloc] init];
		busRoutes = [[NSMutableArray alloc] init];
		
		bookmarkedStops = [[NSMutableArray alloc] init];
		
		[self loadStopsAndRouteFromSQL];
		
		// FIXME - Sample bus stop
		[bookmarkedStops addObject:[busStops objectAtIndex:0]];
	}
	
	return self;
}

-(void)loadStopsAndRouteFromSQL {
	NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"shuttleTracDataStore" ofType:@"sqlite"];
	
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		
		// Get all stops from SQLite file
		sqlite3_stmt *compiledStatement;
		const char *sqlStatement = "SELECT id,name,latitude,longitude FROM stops;";
		if (sqlite3_prepare(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
				CLLocationCoordinate2D loc = {sqlite3_column_double(compiledStatement, 2), sqlite3_column_double(compiledStatement, 3)};
				const char *name = (const char *) sqlite3_column_text(compiledStatement, 1);
				
				BusStopArrivals *newBusStop = [[BusStopArrivals alloc] initWithName:[NSString stringWithUTF8String:name] 
																		 stopNumber:sqlite3_column_int(compiledStatement, 0) 
																		   location:loc];
				[busStops addObject:[newBusStop autorelease]];
			}
		}
		
		// Get all routes from SQLite file
		const char *sqlStatement2 = "SELECT id,name,stops FROM routes;";
		if (sqlite3_prepare(database, sqlStatement2, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
				const char *name = (const char *) sqlite3_column_text(compiledStatement, 1);
				
				[busRoutes addObject:[BusRoute busRouteWithID:sqlite3_column_int(compiledStatement, 0) 
														 name:[NSString stringWithUTF8String:name] 
														stops:nil]];
			}
		}
		
	}
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
	sqlite3_close(database);
	
	[busStops release];
	[busRoutes release];
	[bookmarkedStops release];
	[super dealloc];
}

@end
