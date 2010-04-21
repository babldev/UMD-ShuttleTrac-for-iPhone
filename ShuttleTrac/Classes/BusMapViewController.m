//
//  BusMapViewController.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusMapViewController.h"
#import "MKAddressDictionaryPlacemark.h"

@interface BusMapViewController ( )
- (void)addBusStops;
@end


@implementation BusMapViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self addBusStops];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)addBusStops {
	CLLocationCoordinate2D	coordinate1 = { 41.890158,12.492185 };
	NSDictionary *address = [NSDictionary dictionaryWithObjectsAndKeys:@"Italy", @"Country", nil];
    MKPlacemark	*rome = [MKPlacemark placemarkWithCoordinate:coordinate1 addressDictionary:address];    
	[mapView addAnnotation:rome];
	
	CLLocationCoordinate2D coordinate2 = { 48.858196,2.294748 };
	address = [NSDictionary dictionaryWithObjectsAndKeys:@"France", @"Country", nil];
	MKPlacemark *paris = [MKPlacemark placemarkWithCoordinate:coordinate2 addressDictionary:address];
	[mapView addAnnotation:paris];
}

#pragma mark -
#pragma mark Actions

- (IBAction)changeType:(UISegmentedControl *)sender {
	NSInteger index = sender.selectedSegmentIndex;
	mapView.mapType = (MKMapType)index;
}

- (IBAction)findMe:(UIBarButtonItem *)sender {
	// TODO Move to current user location
}

#pragma mark -
#pragma mark Map View Delegate

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = nil;
    if (annotation != [aMapView userLocation]) { // custom pin for everything except the user's location
        pinView = (MKPinAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"customID"];
        if (!pinView) {
            // No reusable view, create one
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
													  reuseIdentifier:@"customID"];
            
            [pinView setPinColor: MKPinAnnotationColorGreen];
            [pinView setAnimatesDrop: YES];
            [pinView setCanShowCallout: YES];
            
            UIButton* rightButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
            [pinView setRightCalloutAccessoryView: rightButton];
        }
        else {
            [pinView setAnnotation: annotation];
        }
    }
    return pinView;
}

- (void)mapView:(MKMapView *)aMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSString *alertTitle = [[view annotation] title];
    NSString *alertMsg = [NSString stringWithFormat:@"You just tapped on %@!!1", [[view annotation] title]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark -
#pragma mark Location

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	mapView.userLocation.title = placemark.title;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	;
}


@end
