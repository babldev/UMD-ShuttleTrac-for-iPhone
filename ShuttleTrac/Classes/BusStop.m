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
@property (assign, readwrite, nonatomic) CLLocationCoordinate2D coordinate;

@end



@implementation BusStop

@synthesize name, stopNumber, coordinate;

+(BusStop *)busStopWithName:(NSString *)sName stopNumber:(NSInteger)sNumber coordinate:(CLLocationCoordinate2D)sLoc {
	BusStop *newStop = [[BusStop alloc] initWithName:sName stopNumber:sNumber coordinate:sLoc];
	return [newStop autorelease];
}
+(BusStop *)busStopWithName:(NSString *)sName stopNumber:(NSInteger)sNumber {
	BusStop *newStop = [[BusStop alloc] initWithName:sName stopNumber:sNumber];
	return [newStop autorelease];
}

-(id)initWithName:(NSString *)sName stopNumber:(NSInteger)sNumber coordinate:(CLLocationCoordinate2D)sLoc {
	if (self = [super init]) {
		[self setName:sName];
		[self setStopNumber:sNumber];
		[self setCoordinate:sLoc];
	}
	
	return self;
}

+(BusStop *)cloneStop:(BusStop *)bStop {
	return [[[BusStop alloc] initWithBusStop:bStop] autorelease];
}

-(id)initWithBusStop:(BusStop *)bStop {
	if (self = [super init]) {
		[self setName:[[bStop name] copy]];
		[self setStopNumber:[bStop stopNumber]];
		[self setCoordinate:[bStop coordinate]];
	}
	
	return self;
}
-(id)initWithName:(NSString *)sName stopNumber:(NSInteger)sNumber {
	if (self = [super init]) {
		[self setName:sName];
		[self setStopNumber:sNumber];
	}
	
	return self;
}


#pragma mark -
#pragma mark MKAnnotation

- (NSString *)title {
	return [self name];
}

- (NSString *)subtitle {
	return [NSString stringWithFormat:@"#%d", [self stopNumber]];
}

@end
