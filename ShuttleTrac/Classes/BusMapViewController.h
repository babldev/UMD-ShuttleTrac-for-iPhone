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
#import "BusMapDataStore.h"
#import "BusStopViewController.h"
#import "RouteSelectorController.h"

@interface BusMapViewController : UIViewController <MKMapViewDelegate, 
							UINavigationControllerDelegate, 
							RouteSelectorControllerDelegate> {
	BusMapDataStore *dataStore;
	
	BusStopViewController *busStopViewController;
	RouteSelectorController *routeSelectorController;
	
	IBOutlet MKMapView  *mapView;
	IBOutlet UIButton	*routeButton;
	
	MKReverseGeocoder   *reverseGeocoder;
}

- (IBAction)changeType:(UISegmentedControl *)sender;
- (IBAction)findMe:(UIBarButtonItem *)sender;
- (IBAction)selectRoute:(UIButton *)sender;

@end
