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
@property (retain, readwrite) NSDate *lastRefresh;

@end

@implementation BusStopArrivals

@synthesize route, upcomingBuses, lastRefresh, delegate;

-(id)initWithBusStop:(BusStop *)bStop forBusRoute:(BusRoute *)bRoute {
	if (self = [super initWithBusStop:bStop]) {
		[self setRoute:bRoute];
		
		ShuttleTracDataStore *mainDataStore = GetShuttleTracDataStore();
		stops = [mainDataStore allBusStops];
		routes = [mainDataStore allBusRoutes];
		upcomingBuses = [[NSMutableArray alloc] init];
	}
	
	return self;
}

#pragma mark -
#pragma mark Refresh routes
-(void)refreshUpcomingBuses {
	// Set last refresh to today
	[self setLastRefresh:[NSDate date]];
	 
	[self requestBusArrivalFromWeb];
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
		currBusArrival = [[BusArrival busArrivalWithRoute:[self getBusRouteForID:currRouteNum] stop:[self getBusStopForID:self.stopNumber] arrivalTime:[NSDate dateWithTimeIntervalSinceNow:eta * 60]] retain];
	}
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{	
	if([elementName isEqual:@"Trip"]){
		[upcomingBuses addObject:[currBusArrival autorelease]];
		currBusArrival = nil;
	}
}
# pragma mark refresh arrival times
-(void)requestBusArrivalFromWeb{	
	NSString *request = [NSString stringWithFormat:@"http://shuttle.umd.edu/RTT/Public/Utility/File.aspx?ContentType=SQLXML&Name=RoutePositionET.xml&PlatformNo=%d", self.stopNumber];
	
	NSURL *url = [NSURL URLWithString:request];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
