//
//  RouteSelectorTableViewCell.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusRoute.h"

@interface RouteSelectorTableViewCell : UITableViewCell {
	BusRoute *route;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (retain, readwrite) BusRoute *route;

@end
