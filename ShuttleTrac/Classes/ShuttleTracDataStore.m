//
//  ShuttleTracDataStore.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShuttleTracDataStore.h"

@interface ShuttleTracDataStore ( )

-(void)loadStopsAndRouteFromSQL;
-(void)requestStopsFromWeb;
-(void)installTables;
-(void)emptyTables;

@property (retain, readwrite) BookmarkedStopsDataStore *bookmarkedStopsDataStore;
@property (retain, readwrite) BusMapDataStore *busMapDataStore;

@end


@implementation ShuttleTracDataStore

@synthesize bookmarkedStopsDataStore, busMapDataStore;

-(id)init {
	if (self = [super init]) {
		busStops = [[NSMutableDictionary alloc] init];
		busRoutes = [[NSMutableDictionary alloc] init];
				
		NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		databasePath = [docsDir stringByAppendingFormat:@"/shuttleTracDataStore_v1.sqlite"];
		
		BOOL installRequired = ![[NSFileManager defaultManager] fileExistsAtPath:databasePath];
		
		if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			// Check if 
			if (installRequired) {
				[self installTables];
			}
			
			[self refreshStopAndRouteData];
		} else {
			NSLog(@"SQLite database failed to open");
		}

		// Initiate data stores
		self.bookmarkedStopsDataStore	= [[[BookmarkedStopsDataStore alloc] initWithDataStore:self] autorelease];
		self.busMapDataStore			= [[[BusMapDataStore alloc] initWithDataStore:self] autorelease];
	}
	
	return self;
}

-(void)installTables {
	const char *createStopsSql = "CREATE TABLE stops(id integer primary key, name text, latitude real, longitude real, roadName text, bearingToRoad real);";
	const char *createRotuesSql = "CREATE TABLE routes(id integer primary key, name text, stops text);";
	
	// CREATE STOPS TABLE
	
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_prepare_v2(database, createStopsSql, -1, &compiledStatement, NULL) == SQLITE_OK) {
		// Anything here?
	}
	
	if(SQLITE_DONE != sqlite3_step(compiledStatement)) {
		NSLog(@"Error while creating STOPS table. Error: '%s'.", sqlite3_errmsg(database));
	}
	
	
	// CREATE ROUTES TABLE
	
	sqlite3_reset(compiledStatement);
	
	if(sqlite3_prepare_v2(database, createRotuesSql, -1, &compiledStatement, NULL) == SQLITE_OK) {
		// Anything here?
	}
	
	if(SQLITE_DONE != sqlite3_step(compiledStatement)) {
		NSLog(@"Error while creating ROUTES table. Error: '%s'.", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(compiledStatement);
}

-(void)emptyTables {
	const char *createStopsSql = "DELETE FROM stops;";
	const char *createRoutesSql = "DELETE FROM routes;";
	
	// TRUNCATE STOPS TABLE
	
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_prepare_v2(database, createStopsSql, -1, &compiledStatement, NULL) == SQLITE_OK) {
		// Anything here?
	}
	
	if(SQLITE_DONE != sqlite3_step(compiledStatement)) {
		NSLog(@"Error while creating STOPS table. Error: '%s'.", sqlite3_errmsg(database));
	}
	
	
	// TRUNCATE ROUTES TABLE
	
	sqlite3_reset(compiledStatement);
	
	if(sqlite3_prepare_v2(database, createRoutesSql, -1, &compiledStatement, NULL) == SQLITE_OK) {
		// Anything here?
	}
	
	if(SQLITE_DONE != sqlite3_step(compiledStatement)) {
		NSLog(@"Error while creating ROUTES table. Error: '%s'.", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(compiledStatement);
}

-(void)refreshStopAndRouteData {
	[self emptyTables];
	[self requestStopsFromWeb];
	[self loadStopsAndRouteFromSQL];

	[self requestRoutesFromWeb];
	
	// FIXME Remove this debug line
	//[busRoutes addObject:[BusRoute busRouteWithID:105 name:@"Courtyards Express" stops:nil]];
}

-(void)requestStopsFromWeb{
	NSURL *url = [NSURL URLWithString:@"http://shuttle.umd.edu/RTT/Public/Utility/File.aspx?ContentType=SQLXML&Name=Platform.xml"];

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)requestRoutesFromWeb{
	NSURL *url = [NSURL URLWithString:@"http://shuttle.umd.edu/RTT/Public/Utility/File.aspx?ContentType=SQLXML&Name=RoutePattern.xml"];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark SQL

-(void)loadStopsAndRouteFromSQL {		
		// Get all stops from SQLite file
	sqlite3_stmt *compiledStatement;
	const char *sqlStatement = "SELECT id,name,latitude,longitude FROM stops;";
	if (sqlite3_prepare(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
			CLLocationCoordinate2D loc = {sqlite3_column_double(compiledStatement, 2), sqlite3_column_double(compiledStatement, 3)};
			const char *name = (const char *) sqlite3_column_text(compiledStatement, 1);
			NSInteger stopNumber = sqlite3_column_int(compiledStatement, 0);
			BusStop *newBusStop = [[BusStop alloc] initWithName:[NSString stringWithUTF8String:name] 
																	 stopNumber:stopNumber
																	 coordinate:loc];
			if(stopNumber != 0)
				[busStops setObject:newBusStop forKey:[NSNumber numberWithInteger:stopNumber]];
		}
	}
	
	// Get all routes from SQLite file
	const char *sqlStatement2 = "SELECT id,name,stops FROM routes;";
	if (sqlite3_prepare(database, sqlStatement2, -1, &compiledStatement, NULL) == SQLITE_OK) {
		while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
			const char *name = (const char *) sqlite3_column_text(compiledStatement, 1);
			
			[busRoutes addObject:[BusRoute busRouteWithID:sqlite3_column_int(compiledStatement, 0) 
													 name:[NSString stringWithUTF8String:name] 
													stops:nil]];
		}		
	}
}

-(void) addBusStopToDatabaseWithStop:(BusStop *)stop {
	const char *sql = "INSERT INTO stops(id, name, latitude, longitude) VALUES(?, ?, ?, ?);";
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
		sqlite3_bind_int(compiledStatement, 1, stop.stopNumber);
		sqlite3_bind_text(compiledStatement, 2, [stop.name UTF8String], [stop.name length], SQLITE_TRANSIENT);
		sqlite3_bind_double(compiledStatement, 3, stop.coordinate.latitude );
		sqlite3_bind_double(compiledStatement, 4, stop.coordinate.longitude );
	}
	
	if(SQLITE_DONE != sqlite3_step(compiledStatement)) {
		NSLog(@"Error while inserting data. Error: '%s'. Stop: '%@'", sqlite3_errmsg(database), [stop name]);
	}
	sqlite3_reset(compiledStatement);
}

-(void) addBusRouteToDatabaseWithRoute:(BusStop *)stop {
	;
	/*
	const char *sql = "INSERT INTO route(id, name, latitude, longitude) VALUES(?, ?, ?, ?);";
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
		sqlite3_bind_int(compiledStatement, 1, stop.stopNumber);
		sqlite3_bind_text(compiledStatement, 2, [stop.name UTF8String], [stop.name length], SQLITE_TRANSIENT);
		sqlite3_bind_double(compiledStatement, 3, stop.coordinate.latitude );
		sqlite3_bind_double(compiledStatement, 4, stop.coordinate.longitude );
	}
	
	if(SQLITE_DONE != sqlite3_step(compiledStatement)) {
		NSLog(@"Error while inserting data. Error: '%s'. Stop: '%@'", sqlite3_errmsg(database), [stop name]);
	}
	sqlite3_reset(compiledStatement);*/
}


-(NSMutableDictionary *)allBusStops {	
	return busStops;
}

-(NSMutableDictionary *)allBusRoutes {
	return busRoutes;
}

#pragma mark XML Parsing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	
	if ([elementName isEqual: @"Platform"]) {
		if (!parserString) 
			parserString = [[NSMutableString alloc] init];
		if(!currBusStop){
			NSString *name = [attributeDict objectForKey:@"Name"];
			NSInteger busNo = [[attributeDict objectForKey:@"PlatformNo"] integerValue];
			currBusStop = [[BusStop alloc] init];
			[currBusStop setName:name];
			[currBusStop setStopNumber:busNo];
			
			if(currRouteBusStops){
				currBusStop = [busStops objectForKey:[NSNumber numberWithInteger:busNo]];
				if(currBusStop) [currRouteBusStops addObject: currBusStop];
			}
		}
	}
	else if([elementName isEqual:@"Position"]){
		if(currBusStop){
			CLLocationCoordinate2D loc;
			loc.latitude = [[attributeDict objectForKey:@"Lat"] doubleValue];
			loc.longitude = [[attributeDict objectForKey:@"Long"] doubleValue];
			[currBusStop setCoordinate:loc];
		}
	}
	
	//Get Routes
	else if([elementName isEqual:@"Route"]){
		if(!currBusRoute){
			NSInteger routeNum = [[attributeDict objectForKey:@"RouteNo"] integerValue];
			NSString *routeName = [attributeDict objectForKey:@"Name"];
			
			currRouteBusStops = [[NSMutableArray alloc] init]; // create array to store bus stops reached on route
			routeDict = [[NSMutableDictionary alloc] init];
			
			currBusRoute = [[BusRoute alloc] init];
			[currBusRoute setRouteName:routeName];
			[currBusRoute setRouteID:routeNum];
		}
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[parserString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{	
	if([elementName isEqual:@"Platform"]){
		[self addBusStopToDatabaseWithStop:currBusStop];
		[currBusStop release]; 
		currBusStop = nil;
	}
	else if([elementName isEqual:@"Route"]){
		[currBusRoute setStops:currRouteBusStops];
		[busRoutes setObject:currBusRoute forKey:[NSNumber numberWithInteger:currBusRoute.routeID]];
		
		//[currRouteBusStops release];
		//currRouteBusStops = nil;
		[currBusRoute release];
		currBusRoute = nil;
	}
}


-(void)dealloc {
	sqlite3_close(database);
	
	
	[bookmarkedStopsDataStore release];
	[busMapDataStore release];
	[busStops release];
	[busRoutes release];
	[parserString release];
	[databasePath release];
	
	[super dealloc];
}

@end
