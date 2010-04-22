//
//  BusMapViewController.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataStoreGrabber.h"

#import "BusMapViewController.h"
#import "MKAddressDictionaryPlacemark.h"

#import "DataStoreGrabber.h"
#import "BusStop.h"

#import "BusStopViewController.h"

@interface BusMapViewController ( )
- (void)addBusStops;
-(void)zoomToFitMapAnnotations;
@end


@implementation BusMapViewController

@synthesize busStops;

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
	
	dataStore = GetShuttleTracDataStore();
	[self addBusStops];
	
	// FIXME - We probably shouldn't run this for > 10 stops
	[self zoomToFitMapAnnotations];
	
	[self.navigationController setDelegate:self];
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
	[busStops release];
	
    [super dealloc];
}

- (void)addBusStops {
	self.busStops = [GetShuttleTracDataStore() allBusStops];
	
	for (BusStop *stop in busStops) {
		NSDictionary *address = [NSDictionary dictionaryWithObjectsAndKeys:[stop name], @"Country", nil];
		MKPlacemark *newPlacemark = [MKPlacemark placemarkWithCoordinate:[stop location] addressDictionary:address];
		[mapView addAnnotation:newPlacemark];
	}
}

#pragma mark -
#pragma mark Auto fit zoom

-(void)zoomToFitMapAnnotations
{
    if([mapView.annotations count] == 0)
        return;
	
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
	
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
	
    for(id <MKAnnotation> annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
		
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
	
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2;
	
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
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
	/*
    NSString *alertTitle = [[view annotation] title];
    NSString *alertMsg = [NSString stringWithFormat:@"You just tapped on %@!!1", [[view annotation] title]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
	 */
	BusStopViewController *busStopController = [[BusStopViewController alloc] initWithNibName:@"BusStopView" bundle:nil];
	[busStopController setDataStore:dataStore];
	[busStopController setArrivals:nil];
	//[busStopController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//	[self presentModalViewController:busStopController animated:YES];
	[self.navigationController pushViewController:busStopController animated:YES];
}

#pragma mark -
#pragma mark Location

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	mapView.userLocation.title = placemark.title;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	;
}

#pragma mark -
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (viewController == self)
		[navigationController setNavigationBarHidden:YES animated:YES];
}


@end
