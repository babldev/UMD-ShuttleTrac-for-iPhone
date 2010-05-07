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

@protocol BusMapViewControllerDelegate

-(void)busStopSelected:(BusStop *)stop;

@end


@interface BusMapViewController : UIViewController <MKMapViewDelegate> {
	BusMapDataStore *dataStore;
	
	IBOutlet MKMapView  *mapView;
	
	MKReverseGeocoder   *reverseGeocoder;
	
	id <BusMapViewControllerDelegate> delegate;
}

- (IBAction)cancelSearch:(UIBarButtonItem *)sender;
- (IBAction)findMe:(UIBarButtonItem *)sender;
- (IBAction)changeType:(UISegmentedControl *)sender;

@property (assign, readwrite) BusMapDataStore *dataStore;
@property (assign, readwrite) id <BusMapViewControllerDelegate> delegate;

-(void)reloadMap;

@end
