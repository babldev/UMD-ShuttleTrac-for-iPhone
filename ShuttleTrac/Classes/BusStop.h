//
//  BusStop.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BusArrival.h"

@interface BusStop : NSObject <MKAnnotation> {
	// Name of the bus stop
	NSString *name;
	
	// ShuttleTrac stop number 
	NSInteger stopNumber;
	
	// Geolocation of the bus stop
	CLLocationCoordinate2D coordinate;
}

+(BusStop *)busStopWithName:(NSString *)sName stopNumber:(NSInteger)sNumber coordinate:(CLLocationCoordinate2D)sLoc;

-(id)initWithName:(NSString *)sName stopNumber:(NSInteger)sNumber coordinate:(CLLocationCoordinate2D)sLoc;


+(BusStop *)cloneStop:(BusStop *)bStop;

-(id)initWithBusStop:(BusStop *)bStop;


@property (retain, readonly) NSString *name;
@property (assign, readonly) NSInteger stopNumber;
@property (assign, readonly, nonatomic) CLLocationCoordinate2D coordinate;

@end
