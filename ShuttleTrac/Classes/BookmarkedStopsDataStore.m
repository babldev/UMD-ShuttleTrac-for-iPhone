//
//  BookmarkedStopsDataStore.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BookmarkedStopsDataStore.h"

NSString *const BookmarksDidChange = @"BookmarksDidChange";

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
- (id)initWithCoder:(NSCoder *)coder {
    bookmarkedStops = [[coder decodeObjectForKey:@"bookmarkedStops"] retain];
	dataStore = [[coder decodeObjectForKey:@"dataStore"] retain];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:bookmarkedStops forKey :@"bookmarkedStops"];
	[coder encodeObject:dataStore forKey :@"dataStore"];

}

-(void)addStopToBookmarks:(BusStopArrivals *)newArrivals {
	if (![self containsStop:newArrivals]) {
		[bookmarkedStops insertObject:newArrivals atIndex:0];
		[[NSNotificationCenter defaultCenter] postNotificationName:BookmarksDidChange object:self userInfo:nil];
	}
}

-(void)removeStopFromBookmarks:(BusStopArrivals *)oldArrivals {
	BusStopArrivals *localArrivals = nil;
	
	for (BusStopArrivals *arr in bookmarkedStops) {
		if ([arr isSameStopAs:oldArrivals]) {
			localArrivals = arr;
			break;
		}
	}
	
	[bookmarkedStops removeObject:localArrivals];
	[[NSNotificationCenter defaultCenter] postNotificationName:BookmarksDidChange object:self userInfo:nil];
}

-(void)replaceBookmarks:(NSArray *)newBookmarks {
	[self setBookmarkedStops:[[newBookmarks mutableCopy] autorelease]];
	[[NSNotificationCenter defaultCenter] postNotificationName:BookmarksDidChange object:self userInfo:nil];
}

-(BOOL)containsStop:(BusStopArrivals *)compareArrivals {
	for (BusStopArrivals *arr in bookmarkedStops) {
		if ([arr isSameStopAs:compareArrivals])
			return YES;
	}
	
	return NO;
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
