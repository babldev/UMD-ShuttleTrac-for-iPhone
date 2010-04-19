//
//  BusStop.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusStop.h"

@interface BusStop ()

@property (retain, readwrite) NSString *name;
@property (assign, readwrite) NSInteger stopNumber;
@property (assign, readwrite) CLLocationCoordinate2D location;

@end



@implementation BusStop

@synthesize name, stopNumber, lastRefresh, location, upcomingBuses;

-(BusStop *)busStopWithName:(NSString *)sName stopNumber:(NSInteger)sNumber {
	BusStop *newStop = [[BusStop alloc] initWithName:sName stopNumber:sNumber];
	return [newStop autorelease];
}

#pragma mark Initializer

-(id)initWithName:(NSString *)sName stopNumber:(NSInteger)sNumber {
	if (self = [super init]) {
		[self setName:sName];
		[self setStopNumber:sNumber];
	}
	
	return self;
}

#pragma mark ShuttleTrac calls

-(void)refreshBusArrivals {
	// TODO Implement ShuttleTrac arrival calls
	
	// FIXME this is just temporary
	self.upcomingBuses = [NSArray arrayWithObject:[BusArrival 
									busArrivalWithRoute:[[BusRoute busRouteWithID:1 name:@"Purple" stops:nil] retain]
									stop:self
									arrivalTime:[NSDate date]]];
}

@end
