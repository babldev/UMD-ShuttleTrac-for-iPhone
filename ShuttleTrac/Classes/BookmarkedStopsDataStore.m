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
		
		// FIXME - Debug statement
		// [self.bookmarkedStops addObject:[[dataStore allBusStops] objectAtIndex:100]];
		// [self.bookmarkedStops addObject:[[dataStore allBusStops] objectAtIndex:101]];
		// [self.bookmarkedStops addObject:[[dataStore allBusStops] objectAtIndex:102]];
	}
	
	return self;
}
- (id)initWithCoder:(NSCoder *)coder {
    bookmarkedStops = [[coder decodeObjectForKey:@"bookmarkedStops"] retain];
	dataStore = [[coder decodeObjectForKey:@"dataStore"] retain];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:bookmarkedStops forKey :@"bookmarkedStops"];
	[coder encodeObject:dataStore forKey :@"dataStore"];

}

-(void)refreshBookmarkedStopArrivals {
	// Do nothing for now
	[delegate refreshBookmarkedStopArrivalsCompleted:self.bookmarkedStops];
}

#pragma mark dealloc
-(void)dealloc {
	[bookmarkedStops release];
	bookmarkedStops = nil;
	
	[super dealloc];
}

@end
