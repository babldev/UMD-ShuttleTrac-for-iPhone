//
//  BusMapViewController.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataStoreGrabber.h"
#import "BusMapViewController.h"
#import "DataStoreGrabber.h"
#import "BusStop.h"

#define ZOOM_OVERSIZE	1.1

@interface BusMapViewController ( )
-(void)zoomToFitMapAnnotations;
@end


@implementation BusMapViewController

@synthesize dataStore, delegate;
//
//// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//- (void)viewDidLoad {
//    [super viewDidLoad];
//}


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

- (void)reloadMap {
	[dataStore loadStopsForActiveRoute];
	
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
		if (annotation == [mapView userLocation])
			continue; // skip user location
		
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
		
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
	
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * ZOOM_OVERSIZE;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * ZOOM_OVERSIZE;
	
    region = [mapView regionThatFits:region];
    [mapView setRegion:region];
}

#pragma mark -
#pragma mark Actions

- (IBAction)cancelSearch:(UIBarButtonItem *)sender {
	[delegate busStopSelected:nil];
}

- (IBAction)findMe:(UIBarButtonItem *)sender {
	if (mapView.userLocation.location) {
		float spanMultiplier = 0.5f;
		
		MKCoordinateRegion newRegion = mapView.region;
		newRegion.span.longitudeDelta *= spanMultiplier;
		newRegion.span.latitudeDelta *= spanMultiplier;
		newRegion.center = mapView.userLocation.location.coordinate;
		
		NSLog(@"Old: %f %f, New: %f %f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta, newRegion.span.latitudeDelta, newRegion.span.longitudeDelta);
		
		[mapView setRegion:newRegion animated:YES];
	}
}

- (IBAction)changeType:(UISegmentedControl *)sender {
	NSInteger index = sender.selectedSegmentIndex;
	mapView.mapType = (MKMapType)index;
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
	[delegate busStopSelected:(BusStop *) view.annotation];
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
		[self reloadMap];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}


@end
