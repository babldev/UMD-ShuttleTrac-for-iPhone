//
//  BookmarkedStopsDataStore.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BookmarkedStopsDataStore.h"

@interface BookmarkedStopsDataStore ( )
@property (retain, readwrite) NSMutableArray *bookmarkedStops;
@end

@implementation BookmarkedStopsDataStore
@synthesize bookmarkedStops, delegate;

-(id)initWithDataStore:(ShuttleTracDataStore *)dStore {
	if (self = [super init]) {
		dataStore = dStore;
		self.bookmarkedStops = [[[NSMutableArray alloc] init] autorelease];
	}
	
	return self;
}

-(void)refreshBookmarkedStopArrivals {
	// Do nothing for now
	[delegate refreshBookmarkedStopArrivalsCompleted:self.bookmarkedStops];
}

@end
