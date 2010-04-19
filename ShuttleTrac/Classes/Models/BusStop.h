//
//  BusStop.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BusStop : NSObject {
	// Name of the bus stop
	NSString *name;
	
	// ShuttleTrac stop number 
	NSInteger stopNumber;
	
	// Last refresh of bus times
	NSDate *lastRefresh;
	
	// Geolocation of the bus stop
	CLLocationCoordinate2D location;
	
	// Array of ArrivingBus(es)
	NSArray	*upcomingBuses;
}

-(id)initWithName:(NSString *)sName stopNumber:(NSInteger)sNumber;
-(void)refreshBusArrivals;

@property (retain, readonly) NSString *name;
@property (assign, readonly) NSInteger stopNumber;
@property (retain, readwrite) NSDate *lastRefresh;
@property (assign, readonly) CLLocationCoordinate2D location;
@property (retain, readwrite) NSArray *upcomingBuses;

@end
