//
//  BusRoute.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusRoute.h"

@interface BusRoute ()

@property (retain, readwrite) NSString *routeName;
@property (assign, readwrite) NSInteger routeID;
@property (retain, readwrite) NSArray *stops;

@end


@implementation BusRoute

@synthesize routeName, routeID, stops;

+(BusRoute *)busRouteWithID:(NSInteger)rID name:(NSString *)rName stops:(NSArray *)rStops {
	BusRoute *newRoute = [[BusRoute alloc] initRouteWithID:rID name:rName stops:rStops];
	return [newRoute autorelease];
}

-(id)initRouteWithID:(NSInteger)rID name:(NSString *)rName stops:(NSArray *)rStops {
	if (self = [super init]) {
		[self setRouteID:rID];
		[self setRouteName:rName];
		[self setStops:rStops];
	}
	
	return self;
}
- (id)copyWithZone:(NSZone *)zone{
	return [[BusRoute alloc] initRouteWithID:self.routeID name:self.routeName stops:self.stops];
}

@end
