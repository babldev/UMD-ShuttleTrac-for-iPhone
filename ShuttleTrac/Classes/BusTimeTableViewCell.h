//
//  BusTimeTableViewCell.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusArrival.h"

@interface BusTimeTableViewCell : UITableViewCell {
	BusArrival *busArrival;
}

@property (retain, readwrite) BusArrival *busArrival;

@end
