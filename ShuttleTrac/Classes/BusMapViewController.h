//
//  BusMapViewController.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusStop.h"
#import "ShuttleTracDataStore.h"
#import "BusStopViewController.h"
@interface BusMapViewController : UIViewController <MKMapViewDelegate, UINavigationControllerDelegate> {
	ShuttleTracDataStore *dataStore;
	
	BusStopViewController *busStopViewController;
	
	IBOutlet MKMapView  *mapView;
	MKReverseGeocoder   *reverseGeocoder;
	NSArray				*busStops;
}

- (IBAction)changeType:(UISegmentedControl *)sender;
- (IBAction)findMe:(UIBarButtonItem *)sender;

@property (retain, readwrite) NSArray *busStops;

@end
