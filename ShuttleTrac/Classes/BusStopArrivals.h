//
//  BusArrival.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ShuttleTracDataStore.h"
#import "BusStopArrivals.h"
#import "BusStopArrivalsForRoute.h"
#import "BusStop.h"
#import "BusRoute.h"

@class ShuttleTracDataStore, BusStopArrivals;

@protocol BusStopArrivalsDelegate

-(void)arrivalsRefreshComplete:(BusStopArrivals *)arrivals;

@end

@interface BusStopArrivals : NSObject <NSCoding> {
	ShuttleTracDataStore *dataStore;
	
	// Route for the arriving buses
	BusRoute *route;
	BusStop *stop;
	
	// NSArray of BusStopArrivalsForRoute
	NSMutableArray *upcomingBusRoutes;
	
	// Time of last refresh
	NSDate *lastRefresh;
	
	id <BusStopArrivalsDelegate> delegate;
	
	// ----
	
	BOOL refreshing;
	NSMutableData *dataForConnection;
	
	BusStopArrivalsForRoute *currentParsingArrivalsRoute;
	
	// From ShuttleTracDataStore
	NSDictionary *routes; 
	NSDictionary *stops;
		
	NSMutableArray *newUpcomingBusRoutes;
	
	NSXMLParser *parser;
	bool isManualRefresh; 
}

-(NSString *) getBusStopName;

-(id)initWithBusStop:(BusStop *)bStop forBusRoute:(BusRoute *)bRoute;

-(void)refreshUpcomingBuses:(NSInteger)manualRefresh;
-(BOOL)isSameStopAs:(BusStopArrivals *)otherArrivals;
-(void)cleanArrivals;

@property (assign, readonly) BusRoute *route;
@property (assign, readonly) BusStop *stop;

@property (retain, readonly) NSMutableArray *upcomingBusRoutes;
@property (retain, readonly) NSDate *lastRefresh;
@property (assign, readwrite) id <BusStopArrivalsDelegate> delegate;

@end
