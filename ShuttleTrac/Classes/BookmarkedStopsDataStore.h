//
//  BookmarkedStopsDataStore.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShuttleTracDataStore.h"

@class ShuttleTracDataStore;

@protocol BookmarkedStopsDataStoreDelegate
-(void)refreshBookmarkedStopArrivalsCompleted:(NSMutableArray *)bookmarkedStops;
@end

@interface BookmarkedStopsDataStore : NSObject {
	ShuttleTracDataStore *dataStore;
	
	// Array of BusStopArrivals
	NSMutableArray *bookmarkedStops;
	
	id <BookmarkedStopsDataStoreDelegate> delegate;
}

-(id)initWithDataStore:(ShuttleTracDataStore *)dStore;

-(void)refreshBookmarkedStopArrivals;

@property (retain, readonly) NSMutableArray *bookmarkedStops;
@property (assign, readwrite) id <BookmarkedStopsDataStoreDelegate> delegate;

@end
