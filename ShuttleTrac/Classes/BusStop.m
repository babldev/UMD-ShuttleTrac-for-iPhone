//
//  BusStop.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusStop.h"

@implementation BusStop

@synthesize name, stopNumber, tagNumber, coordinate;

+(BusStop *)busStopWithName:(NSString *)sName stopNumber:(NSInteger)sNumber coordinate:(CLLocationCoordinate2D)sLoc {
	BusStop *newStop = [[BusStop alloc] initWithName:sName stopNumber:sNumber coordinate:sLoc];
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

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super init]) {
		self.name = [coder decodeObjectForKey:@"name"];
		self.stopNumber =  [[coder decodeObjectForKey:@"stopNumber"] integerValue];
		self.tagNumber =  [[coder decodeObjectForKey:@"tagNumber"] integerValue];
		
		float lon =  [[coder decodeObjectForKey:@"longitude"] floatValue];
		float lat =  [[coder decodeObjectForKey:@"latitude"] floatValue];
		
		CLLocationCoordinate2D loc;
		loc.latitude = lat;
		loc.longitude = lon;
		self.coordinate = loc;
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:name forKey:@"name"];	
	[coder encodeObject:[NSNumber numberWithInteger:stopNumber] forKey:@"stopNumber"];	
	[coder encodeObject:[NSNumber numberWithInteger:tagNumber] forKey:@"tagNumber"];	
	[coder encodeObject: [NSNumber numberWithFloat: coordinate.longitude] forKey:@"longitude"];
	[coder encodeObject: [NSNumber numberWithFloat: coordinate.latitude] forKey:@"latitude"];	

}

-(id)initWithBusStop:(BusStop *)bStop {
	if (self = [super init]) {
		self.name		= [[bStop.name copy] autorelease];
		self.stopNumber = bStop.stopNumber;
		self.coordinate = bStop.coordinate;
		self.tagNumber = bStop.tagNumber;
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

- (id)copyWithZone:(NSZone *)zone{
	return [[BusStop alloc] initWithBusStop:self];
}

#pragma mark -
#pragma mark MKAnnotation

- (NSString *)title {
	return [self name];
}

- (NSString *)subtitle {
	return [NSString stringWithFormat:@"#%d", [self stopNumber]];
}

#pragma mark dealloc

-(void)dealloc {
	[name release];
	name = nil;
	
	[super dealloc];
}

@end
