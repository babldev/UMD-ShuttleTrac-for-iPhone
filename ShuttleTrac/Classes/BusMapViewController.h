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

@interface BusMapViewController : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView  *mapView;
	MKReverseGeocoder   *reverseGeocoder;
	NSSet				*busStops;
}

- (IBAction)changeType:(UISegmentedControl *)sender;
- (IBAction)findMe:(UIBarButtonItem *)sender;

@end
