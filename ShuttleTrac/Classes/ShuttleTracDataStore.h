//
//  ShuttleTracDataStore.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShuttleTracDataStore : NSObject {
	NSMutableArray *bookmarkedStops;
}

-(NSArray *)allBusStops;
-(NSArray *)allBusRoutes;

@property (retain, readonly) NSMutableArray *bookmarkedStops;

@end