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

@interface BusMapViewController : UIViewController <MKMapViewDelegate> {
	ShuttleTracDataStore *dataStore;
	
	IBOutlet MKMapView  *mapView;
	MKReverseGeocoder   *reverseGeocoder;
	NSArray				*busStops;
}

- (IBAction)changeType:(UISegmentedControl *)sender;
- (IBAction)findMe:(UIBarButtonItem *)sender;

@property (retain, readwrite) NSArray *busStops;

@end
