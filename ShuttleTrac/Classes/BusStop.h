//
//  BusStop.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BusArrival.h"

@interface BusStop : NSObject {
	// Name of the bus stop
	NSString *name;
	
	// ShuttleTrac stop number 
	NSInteger stopNumber;
	
	// Geolocation of the bus stop
	CLLocationCoordinate2D location;
}

+(BusStop *)busStopWithName:(NSString *)sName stopNumber:(NSInteger)sNumber location:(CLLocationCoordinate2D)sLoc;

-(id)initWithName:(NSString *)sName stopNumber:(NSInteger)sNumber location:(CLLocationCoordinate2D)sLoc;

@property (retain, readonly) NSString *name;
@property (assign, readonly) NSInteger stopNumber;
@property (assign, readonly) CLLocationCoordinate2D location;

@end
