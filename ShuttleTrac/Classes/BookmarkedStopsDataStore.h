//
//  BookmarkedStopsDataStore.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShuttleTracDataStore.h"
#import "BusStopArrivals.h"

extern NSString *const BookmarksDidChange;

@class BusStopArrivals, ShuttleTracDataStore;

@protocol BookmarkedStopsDataStoreDelegate
-(void)refreshBookmarkedStopArrivalsCompleted:(NSMutableArray *)bookmarkedStops;
@end

@interface BookmarkedStopsDataStore : NSObject <NSCoding> {
	ShuttleTracDataStore *dataStore;
	
	// Array of BusStopArrivals
	NSMutableArray *bookmarkedStops;
	
	id <BookmarkedStopsDataStoreDelegate> delegate;
}

-(id)initWithDataStore:(ShuttleTracDataStore *)dStore;

-(BOOL)containsStop:(BusStopArrivals *)compareArrivals;
-(void)addStopToBookmarks:(BusStopArrivals *)newArrivals;
-(void)removeStopFromBookmarks:(BusStopArrivals *)oldArrivals;
-(void)replaceBookmarks:(NSArray *)newBookmarks;

-(void)refreshBookmarkedStopArrivals;

@property (retain, readonly) NSMutableArray *bookmarkedStops;
@property (assign, readwrite) id <BookmarkedStopsDataStoreDelegate> delegate;

@end
