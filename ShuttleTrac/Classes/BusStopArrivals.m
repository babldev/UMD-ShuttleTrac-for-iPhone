//
//  BusArrival.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStopArrivals.h"
#import "DataStoreGrabber.h"

#define REFRESH_PARSING_TIMEOUT	0.001f

@interface BusStopArrivals ()

@property (assign, readwrite) BusRoute *route;
@property (assign, readwrite) BusStop *stop;

@property (retain, readwrite) NSDate *lastRefresh;
@property (retain, readwrite) NSMutableArray *upcomingBusRoutes;

@end

@implementation BusStopArrivals

@synthesize route, upcomingBusRoutes, lastRefresh, delegate, stop;

-(id)initWithBusStop:(BusStop *)bStop forBusRoute:(BusRoute *)bRoute {
	if (self = [super init]) {
		[self setRoute:bRoute];
		[self setStop:bStop];
		
		dataStore = GetShuttleTracDataStore();
		stops = [dataStore allBusStops];
		routes = [dataStore allBusRoutes];
		upcomingBusRoutes = [[NSMutableArray alloc] init];
		
		refreshing = NO;
	}
	
	return self;
}
- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super init]) {
		dataStore = [[coder decodeObjectForKey:@"dataStore"] retain];
		
		stops = [dataStore allBusStops];
		routes = [dataStore allBusRoutes];
		
		stop = [[coder decodeObjectForKey:@"stop"] retain];
		route = [[coder decodeObjectForKey:@"route"]retain];
				
		upcomingBusRoutes = [[coder decodeObjectForKey:@"upcomingBusRoutes"]retain];
		lastRefresh = [[coder decodeObjectForKey:@"lastRefresh"] retain];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:dataStore forKey:@"dataStore"];
	
	[coder encodeObject:stop forKey:@"stop"];
	[coder encodeObject:route forKey:@"route"];	
	
	[coder encodeObject:upcomingBusRoutes forKey:@"upcomingBusRoutes"];	
	[coder encodeObject:lastRefresh forKey:@"lastRefresh"];	
}

-(NSString *) getBusStopName{
	return stop.name;	
}

#pragma mark -
#pragma mark Refresh routes
-(void)refreshUpcomingBuses {
	if (!refreshing) {
		refreshing = YES;
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		
		NSString *request = [NSString stringWithFormat:@"http://shuttle.umd.edu/RTT/Public/Utility/File.aspx?ContentType=SQLXML&Name=RoutePositionET.xml&PlatformNo=%d", 
							 stop.stopNumber];
		NSURL *url = [NSURL URLWithString:request];
		
		newUpcomingBusRoutes = [[NSMutableArray alloc] init];
		
		parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
		[parser setDelegate:self];
		
		// [self performSelector:@selector(parsingDidTimeout:) withObject:parser afterDelay:REFRESH_PARSING_TIMEOUT];
		[self performSelectorInBackground:@selector(requestBusArrivalFromWeb) withObject:nil];
	}
}

-(void)doneRefreshing {
	refreshing = NO;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	[delegate arrivalsRefreshComplete:self];
}

-(BusStop *) getBusStopForID:(NSInteger)stopNum{
	return [stops objectForKey:[NSNumber numberWithInteger:stopNum]];
}
-(BusRoute *) getBusRouteForID:(NSInteger)routeNum{
	return [routes objectForKey:[NSNumber numberWithInteger:routeNum]];
}

# pragma mark XML parsing
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqual: @"Route"]) {
		NSInteger currRouteNum = [[attributeDict objectForKey:@"RouteNo"] integerValue];
		BusRoute *newRoute = [self getBusRouteForID:currRouteNum];
		currentParsingArrivalsRoute = [[[BusStopArrivalsForRoute alloc] initWithRoute:newRoute] autorelease];
		[newUpcomingBusRoutes addObject:currentParsingArrivalsRoute];
	}
	else if ([elementName isEqual: @"Trip"]) {
		NSInteger eta = [[attributeDict objectForKey:@"ETA"] integerValue];

		[[currentParsingArrivalsRoute upcomingArrivals] addObject:[NSDate dateWithTimeIntervalSinceNow:eta * 60]];
	}
}

# pragma mark refresh arrival times
-(void)requestBusArrivalFromWeb {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if ([parser parse]) {
		self.lastRefresh = [NSDate date]; // Clean any arrivals older than 60 seconds
		self.upcomingBusRoutes = newUpcomingBusRoutes;
		[newUpcomingBusRoutes release];
	} else {
		[self cleanArrivals];
		NSLog(@"Arrival Parsing Error: %@", [parser parserError]);
	}

	[parser release];
	parser = nil;
	
	[self performSelectorOnMainThread:@selector(doneRefreshing) withObject:nil waitUntilDone:NO];
	
	[pool release];
}

-(void)cleanArrivals {
	NSDate *requiredDate = [NSDate dateWithTimeIntervalSinceNow:-59];
	NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:[upcomingBusRoutes count]];
	
	for (BusStopArrivalsForRoute *routeArrivals in upcomingBusRoutes) {
		if ([routeArrivals cleanArrivals:requiredDate]) // still has values
			[toRemove addObject:routeArrivals];
	}
	
	[upcomingBusRoutes removeObjectsInArray:toRemove];
}

-(BOOL)isSameStopAs:(BusStopArrivals *)otherArrivals {
	return [stop isEqual:otherArrivals.stop];
}

@end
