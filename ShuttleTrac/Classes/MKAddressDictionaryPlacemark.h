//
//  Placemark.h
//  WebAndMapsDemo
//
//  Created by Chuck Pisula on 4/12/10.
//  Copyright 2010 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKPlacemark ( OverreleaseBug_Workaround )
+ (MKPlacemark *)placemarkWithCoordinate:(CLLocationCoordinate2D)coord addressDictionary:(NSDictionary *)addressDictionary;
@end
