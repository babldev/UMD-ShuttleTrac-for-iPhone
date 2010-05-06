//
//  BusStopArrivalsForRoute.h
//  ShuttleTrac
//
//  Created by Brady Law on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusRoute.h"

@interface BusStopArrivalsForRoute : NSObject <NSCoding> {
	BusRoute *route;
	NSMutableArray *upcomingArrivals;
}

-(id)initWithRoute:(BusRoute *)route;

@property (assign, readonly) BusRoute *route;
@property (assign, readonly) NSMutableArray *upcomingArrivals;

@end
