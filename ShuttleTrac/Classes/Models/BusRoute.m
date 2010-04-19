//
//  BusRoute.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusRoute.h"

@interface BusRoute (Internal)

@property (retain, readwrite) NSString *routeName;
@property (assign, readwrite) NSInteger routeID;
@property (retain, readwrite) NSArray *stops;

@end


@implementation BusRoute

@synthesize routeName, routeID, stops;

-(id)initRouteWithID:(NSInteger)rID name:(NSString *)rName stops:(NSArray *)rStops {
	if (self = [super init]) {
		[self setRouteID:rID];
		[self setRouteName:rName];
		[self setStops:rStops];
	}
	
	return self;
}

@end
