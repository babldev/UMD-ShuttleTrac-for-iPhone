//
//  BusTimeTableViewCell.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusTimeTableViewCell.h"


@implementation BusTimeTableViewCell

@synthesize arrivals;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"h:mm"];
	
	busLabel.text = arrivals.route.routeName;
	NSArray *upcomingTimes = arrivals.upcomingArrivals;
	NSInteger count = [upcomingTimes count];
	
	time1.text = (count >= 1) ? [dateFormatter stringFromDate:[upcomingTimes objectAtIndex:0]] : nil;
	time2.text = (count >= 2) ? [dateFormatter stringFromDate:[upcomingTimes objectAtIndex:1]] : nil;
	time3.text = (count >= 3) ? [dateFormatter stringFromDate:[upcomingTimes objectAtIndex:2]] : nil;
	time4.text = (count >= 4) ? [dateFormatter stringFromDate:[upcomingTimes objectAtIndex:3]] : nil;
	time5.text = (count >= 5) ? [dateFormatter stringFromDate:[upcomingTimes objectAtIndex:4]] : nil;
	
	NSInteger nextBusIn = (int) ([[upcomingTimes objectAtIndex:0] timeIntervalSinceNow] / 60);
	timeUntilArrivalLabel.text = (nextBusIn >= 0 && nextBusIn < 100) ? [NSString stringWithFormat:@"%d", nextBusIn] : @"?";
	
	// Customize cell
	/*
	self.textLabel.text = [[busArrival route] routeName];
	
	// Format countodwn
	NSInteger minutes = (int) ([[busArrival arrivalTime] timeIntervalSinceNow] / 60); 
	NSString *countdown;
	
	if (minutes <= 0) {
		// Bus left, remove cell
		countdown = @"Now";
	} else if (minutes == 1) {
		countdown = @"1 minute";
	} else {
		countdown = [NSString stringWithFormat:@"%d minutes", minutes];
	}
	
	self.detailTextLabel.text = countdown;
	*/
	
	[dateFormatter release];
	
	[super layoutSubviews];
}

- (void)dealloc {
	[arrivals release];
	arrivals = nil;
	
    [super dealloc];
}


@end
