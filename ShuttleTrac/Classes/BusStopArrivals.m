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

@interface BusStopArrivals ()

@property (assign, readwrite) BusRoute *route;
@property (assign, readwrite) BusStop *stop;

@property (retain, readwrite) NSDate *lastRefresh;
@property (retain, readwrite) NSArray *upcomingBuses;

@end

@implementation BusStopArrivals

@synthesize route, upcomingBuses, lastRefresh, delegate, stop;

-(id)initWithBusStop:(BusStop *)bStop forBusRoute:(BusRoute *)bRoute {
	if (self = [super init]) {
		[self setRoute:bRoute];
		[self setStop:bStop];
		
		ShuttleTracDataStore *mainDataStore = GetShuttleTracDataStore();
		stops = [mainDataStore allBusStops];
		routes = [mainDataStore allBusRoutes];
		upcomingBuses = [[NSMutableArray alloc] init];
		
		refreshing = NO;
	}
	
	return self;
}
- (id)initWithCoder:(NSCoder *)coder {
	stop = [[coder decodeObjectForKey:@"stop"] retain];
	upcomingBuses = [[coder decodeObjectForKey:@"upcomingBuses"]retain];
	stops = [[coder decodeObjectForKey:@"stops"] retain];
	route = [[coder decodeObjectForKey:@"route"]retain];
	routes = [[coder decodeObjectForKey:@"routes"]retain];
	lastRefresh = [[coder decodeObjectForKey:@"lastRefresh"] retain];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:stop forKey:@"stop"];
	[coder encodeObject:upcomingBuses forKey:@"upcomingBuses"];	
	[coder encodeObject:route forKey:@"route"];	
	[coder encodeObject:lastRefresh forKey:@"lastRefresh"];	
	[coder encodeObject:routes forKey:@"routes"];
	[coder encodeObject:stops forKey:@"stops"];	

}

-(NSString *) getBusStopName{
	return stop.name;	
}

#pragma mark -
#pragma mark Refresh routes
-(void)refreshUpcomingBuses {
	if (!refreshing) {
		refreshing = YES;
		[self performSelectorInBackground:@selector(requestBusArrivalFromWeb) withObject:nil];
	}
}

-(void)doneRefreshing {
	refreshing = NO;
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
		 currRouteNum = [[attributeDict objectForKey:@"RouteNo"] integerValue];
	}
	else if ([elementName isEqual: @"Trip"]) {
		NSInteger eta = [[attributeDict objectForKey:@"ETA"] integerValue];
		currBusArrival = [[BusArrival busArrivalWithRoute:[self getBusRouteForID:currRouteNum] stop:[self getBusStopForID:stop.stopNumber] arrivalTime:[NSDate dateWithTimeIntervalSinceNow:eta * 60]] retain];
	}
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{	
	if([elementName isEqual:@"Trip"]){
		[newUpcomingBuses addObject:[currBusArrival autorelease]];
		currBusArrival = nil;
	}
}
# pragma mark refresh arrival times
-(void)requestBusArrivalFromWeb{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *request = [NSString stringWithFormat:@"http://shuttle.umd.edu/RTT/Public/Utility/File.aspx?ContentType=SQLXML&Name=RoutePositionET.xml&PlatformNo=%d", stop.stopNumber];
	
	newUpcomingBuses = [[NSMutableArray alloc] init];
	
	NSURL *url = [NSURL URLWithString:request];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	self.upcomingBuses = newUpcomingBuses;
	[newUpcomingBuses release];
	
	[self setLastRefresh:[NSDate date]];
	[self performSelectorOnMainThread:@selector(doneRefreshing) withObject:nil waitUntilDone:NO];
	
	[pool release];
}


@end
