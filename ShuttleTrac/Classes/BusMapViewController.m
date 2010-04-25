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

@interface BusMapViewController ( )
-(void)reloadMap;
-(void)zoomToFitMapAnnotations;
@end


@implementation BusMapViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	dataStore = [GetShuttleTracDataStore() busMapDataStore];
	[self reloadMap];
	
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
	[busStopViewController release];
	[routeSelectorController release];
	
    [super dealloc];
}

- (void)reloadMap {
	[dataStore loadStopsForActiveRoute];
	
	[mapView removeAnnotations:mapView.annotations];
	for (BusStop *stop in [dataStore mappedStops])
		[mapView addAnnotation:stop];
	
	[self zoomToFitMapAnnotations];
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

- (IBAction)selectRoute:(UIButton *)sender {
	if (routeSelectorController == nil) {
		routeSelectorController = [[RouteSelectorController alloc] initWithNibName:@"RouteSelectorController" bundle:nil];
	}
	
	routeSelectorController.delegate = self;
	routeSelectorController.busRoutes = [dataStore allRoutes];
	routeSelectorController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	
	[self presentModalViewController:routeSelectorController animated:YES];
}

#pragma mark -
#pragma mark Map View Delegate

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = nil;
    if (annotation != [aMapView userLocation]) { // custom pin for everything except the user's location
        pinView = (MKPinAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"busMapPins"];
        if (!pinView) {
            // No reusable view, create one
            pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
													  reuseIdentifier:@"busMapPins"] autorelease];
            
            [pinView setPinColor: MKPinAnnotationColorGreen];
            [pinView setAnimatesDrop: NO];
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
	busStopViewController = [[BusStopViewController alloc] initWithNibName:@"BusStopView" bundle:nil];
	
	// FIXME - Any data leaks here?
	
	BusStop *stop = (BusStop *) [view annotation];
	BusStopArrivals *activeStop = [[[BusStopArrivals alloc] initWithBusStop:stop] autorelease];
	
	[dataStore setActiveStop:activeStop];
	[busStopViewController setArrivals:activeStop];
	
	[self.navigationController pushViewController:busStopViewController animated:YES];
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
#pragma mark RouteSelectorControllerDelegate

-(void)routeSelected:(BusRoute *)route {
	if (route != [dataStore activeRoute]) {
		[dataStore setActiveRoute:route];
		[self dismissModalViewControllerAnimated:YES];
		[self reloadMap];
	}
}

#pragma mark -
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {	
	if (viewController == self) {
		[busStopViewController release];
		busStopViewController = nil;
		
		[navigationController setNavigationBarHidden:YES animated:YES];
	} else if (viewController == busStopViewController)
		[navigationController setNavigationBarHidden:NO animated:YES];
}


@end
