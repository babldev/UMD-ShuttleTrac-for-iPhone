//
//  ShuttleTracDataStore.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShuttleTracDataStore.h"

@interface ShuttleTracDataStore ( )

@property (retain, readwrite) NSMutableArray *bookmarkedStops;

@end


@implementation ShuttleTracDataStore

@synthesize bookmarkedStops;

-(NSArray *)allBusStops {
	return nil;
}

-(NSArray *)allBusRoutes {
	return nil;
}

@end
