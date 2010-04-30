//
//  BusArrival.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusArrival.h"

@interface BusArrival ()

@property (assign, readwrite) BusRoute *route;
@property (assign, readwrite) BusStop *stop;
@property (retain, readwrite) NSDate *arrivalTime;

@end

@implementation BusArrival

@synthesize route, stop, arrivalTime;

+(BusStop *)busArrivalWithRoute:(BusRoute *)bRoute stop:(BusStop *)bStop arrivalTime:(NSDate *)bArrivalTime {
	BusArrival *newArrival = [[BusArrival alloc]
							  initWithRoute:bRoute stop:bStop arrivalTime:bArrivalTime];
	return [newArrival autorelease];
}

-(id)initWithRoute:(BusRoute *)bRoute stop:(BusStop *)bStop arrivalTime:(NSDate *)bArrivalTime {
	if (self = [super init]) {
		[self setRoute:bRoute];
		[self setStop:bStop];
		[self setArrivalTime:bArrivalTime];
	}
	
	return self;
}

@end
