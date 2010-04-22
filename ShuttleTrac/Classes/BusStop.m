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

@synthesize name, stopNumber, location;

+(BusStop *)busStopWithName:(NSString *)sName stopNumber:(NSInteger)sNumber location:(CLLocationCoordinate2D)sLoc {
	BusStop *newStop = [[BusStop alloc] initWithName:sName stopNumber:sNumber location:sLoc];
	return [newStop autorelease];
}

-(id)initWithName:(NSString *)sName stopNumber:(NSInteger)sNumber location:(CLLocationCoordinate2D)sLoc {
	if (self = [super init]) {
		[self setName:sName];
		[self setStopNumber:sNumber];
		[self setLocation:sLoc];
	}
	
	return self;
}

+(BusStop *)cloneStop:(BusStop *)bStop {
	return [[[BusStop alloc] initWithBusStop:bStop] autorelease];
}

-(id)initWithBusStop:(BusStop *)bStop {
	if (self = [super init]) {
		[self setName:[bStop name]];
		[self setStopNumber:[bStop stopNumber]];
		[self setLocation:[bStop location]];
	}
	
	return self;
}

@end
