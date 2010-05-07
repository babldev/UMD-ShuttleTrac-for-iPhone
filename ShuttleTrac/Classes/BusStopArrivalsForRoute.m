//
//  BusStopArrivalsForRoute.m
//  ShuttleTrac
//
//  Created by Brady Law on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusStopArrivalsForRoute.h"


@interface BusStopArrivalsForRoute ()
@property (assign, readwrite) NSMutableArray *upcomingArrivals;

@end


@implementation BusStopArrivalsForRoute

@synthesize route, upcomingArrivals;


#pragma mark init

-(id)initWithRoute:(BusRoute *)nRoute {
	if (self = [super init]) {
		route = nRoute;
		upcomingArrivals = [[NSMutableArray alloc] init];
	}
	
	return self;
}


#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)coder {
	route = [[coder decodeObjectForKey:@"route"] retain];
	upcomingArrivals = [[coder decodeObjectForKey:@"upcomingArrivals"] retain];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:route forKey:@"route"];
	[coder encodeObject:upcomingArrivals forKey:@"upcomingArrivals"];	
}

#pragma mark -

-(BOOL)cleanArrivals:(NSDate *)requiredDate {
	NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:[upcomingArrivals count]];
	
	for (NSDate *arrival in upcomingArrivals) {
		// Valid arrival
		if ([requiredDate compare:arrival] != NSOrderedAscending)
			[toRemove addObject:arrival];
	}
	
	[upcomingArrivals removeObjectsInArray:toRemove];
	
	return [upcomingArrivals count] == 0;
}

@end
