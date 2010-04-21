//
//  Placemark.m
//  WebAndMapsDemo
//
//  Created by Chuck Pisula on 4/12/10.
//  Copyright 2010 Apple. All rights reserved.
//

#import "MKAddressDictionaryPlacemark.h"
#import <AddressBook/ABPerson.h>

@interface MKAddressDictionaryPlacemark : MKPlacemark {
    NSDictionary *dict_;
    NSString *title_;
}
@end


@implementation MKPlacemark ( OverreleaseBug_Workaround )

+ (MKPlacemark *)placemarkWithCoordinate:(CLLocationCoordinate2D)coord addressDictionary:(NSDictionary *)addressDictionary {
    return [[[MKAddressDictionaryPlacemark alloc] initWithCoordinate:coord addressDictionary:addressDictionary] autorelease];
}

@end

@implementation MKAddressDictionaryPlacemark

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord addressDictionary:(NSDictionary *)addressDictionary {
    if ((self = [super initWithCoordinate:coord addressDictionary:addressDictionary])) {
        title_ = [[addressDictionary objectForKey:(NSString *)kABPersonAddressCountryKey] retain];
    }
    return self;
}

- (NSString *)title {
    return title_;
}

@end
