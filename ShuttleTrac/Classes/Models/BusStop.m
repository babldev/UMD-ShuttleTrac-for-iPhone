//
//  BusStop.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusStop.h"

@interface BusStop (Internal)

@property (retain, readwrite) NSString *name;
@property (assign, readwrite) NSInteger stopNumber;
@property (assign, readwrite) CLLocationCoordinate2D location;

@end



@implementation BusStop

@synthesize name, stopNumber, lastRefresh, location, upcomingBuses;

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
}

@end
