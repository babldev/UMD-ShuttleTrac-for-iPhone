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

@property (retain, readwrite) NSMutableArray			*bookmarkedStops;

@end


@implementation ShuttleTracDataStore

@synthesize bookmarkedStops, mapActiveStop;

-(id)init {
	if (self = [super init]) {
		busStops = [[NSMutableArray alloc] init];
		busRoutes = [[NSMutableArray alloc] init];
		
		bookmarkedStops = [[NSMutableArray alloc] init];
		databasePath = [[NSBundle mainBundle] pathForResource:@"shuttleTracDataStore" ofType:@"sqlite"];
		
		if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			[self requestStopsFromWeb];
			[self loadStopsAndRouteFromSQL];
		}
		
		// FIXME - Sample bus stop
		[bookmarkedStops addObject:[busStops objectAtIndex:0]];
	}
	
	return self;
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
#pragma mark SQL
-(void)loadStopsAndRouteFromSQL {
	//if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		
		// Get all stops from SQLite file
		sqlite3_stmt *compiledStatement;
		const char *sqlStatement = "SELECT id,name,latitude,longitude FROM stops;";
		if (sqlite3_prepare(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
				CLLocationCoordinate2D loc = {sqlite3_column_double(compiledStatement, 2), sqlite3_column_double(compiledStatement, 3)};
				const char *name = (const char *) sqlite3_column_text(compiledStatement, 1);
				
				BusStopArrivals *newBusStop = [[BusStopArrivals alloc] initWithName:[NSString stringWithUTF8String:name] 
																		 stopNumber:sqlite3_column_int(compiledStatement, 0) 
																		 coordinate:loc];
				[busStops addObject:[newBusStop autorelease]];
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
		//}
		
	}
}

-(void) addBusStopToDatabaseWithName:(NSString*) name stopNumber:(NSInteger) stopNum location:(CLLocationCoordinate2D) location{
	const char *sql = "INSERT INTO stops(id, name, latitude, longitude, roadName, bearingToRoad) VALUES(?, ?, ?, ?, null, null);";
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
		sqlite3_bind_int(compiledStatement, 1, stopNum);
		sqlite3_bind_text(compiledStatement, 2, [name UTF8String], [name length], SQLITE_TRANSIENT);
		sqlite3_bind_double(compiledStatement, 3, location.latitude );
		sqlite3_bind_double(compiledStatement, 4, location.longitude );
	}
	
	if(SQLITE_DONE != sqlite3_step(compiledStatement))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));

	sqlite3_reset(compiledStatement);
}

-(NSArray *)allBusStops {
	return busStops;
}

-(NSArray *)allBusRoutes {
	return busRoutes;
}

-(void)refreshAllBookmarkedStops {
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
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[parserString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{	
	if([elementName isEqual:@"Platform"]){
		[self addBusStopToDatabaseWithName: currBusStop.name stopNumber:currBusStop.stopNumber location: currBusStop.coordinate];
		[currBusStop release]; 
		currBusStop = nil;
	}
}


-(void)dealloc {
	sqlite3_close(database);
	
	[busStops release];
	[busRoutes release];
	[bookmarkedStops release];
	[super dealloc];
}

@end
