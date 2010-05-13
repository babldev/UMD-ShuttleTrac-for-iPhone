//
//  BusTimeTableViewCell.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStopArrivalsForRoute.h"

@interface BusTimeTableViewCell : UITableViewCell {
	IBOutlet UIView *timeUntilArrivalView;
	IBOutlet UILabel *timeUntilArrivalLabel;
	IBOutlet UILabel *busLabel;
	
	IBOutlet UILabel *time1;
	IBOutlet UILabel *time2;
	IBOutlet UILabel *time3;
	IBOutlet UILabel *time4;
	IBOutlet UILabel *time5;
	
	BusStopArrivalsForRoute *arrivals;
}

@property (retain, readwrite) BusStopArrivalsForRoute *arrivals;

@end
