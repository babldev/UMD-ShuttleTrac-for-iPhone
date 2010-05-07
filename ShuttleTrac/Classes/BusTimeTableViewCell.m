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

-(NSString *)minutesTillArrivalWithDate:(NSDate *)date {
	NSInteger nextBusIn = (int) ([date timeIntervalSinceNow] / 60);
	
	if (nextBusIn == 0)
		return @"Now";
	else if (nextBusIn < 100)
		return [NSString stringWithFormat:@"%dm", nextBusIn];
	else
		return @"?";
}

- (void)layoutSubviews {
	
	
	busLabel.text = arrivals.route.routeName;
	NSArray *upcomingTimes = arrivals.upcomingArrivals;
	NSInteger count = [upcomingTimes count];
	
	if (false) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"h:mm"];
		
		time1.text = (count >= 1) ? [dateFormatter stringFromDate:[upcomingTimes objectAtIndex:0]] : nil;
		time2.text = (count >= 2) ? [dateFormatter stringFromDate:[upcomingTimes objectAtIndex:1]] : nil;
		time3.text = (count >= 3) ? [dateFormatter stringFromDate:[upcomingTimes objectAtIndex:2]] : nil;
		time4.text = (count >= 4) ? [dateFormatter stringFromDate:[upcomingTimes objectAtIndex:3]] : nil;
		time5.text = (count >= 5) ? [dateFormatter stringFromDate:[upcomingTimes objectAtIndex:4]] : nil;
		
		[dateFormatter release];
	} else {
		time1.text = (count >= 1) ? [self minutesTillArrivalWithDate:[upcomingTimes objectAtIndex:0]] : nil;
		time2.text = (count >= 2) ? [self minutesTillArrivalWithDate:[upcomingTimes objectAtIndex:1]] : nil;
		time3.text = (count >= 3) ? [self minutesTillArrivalWithDate:[upcomingTimes objectAtIndex:2]] : nil;
		time4.text = (count >= 4) ? [self minutesTillArrivalWithDate:[upcomingTimes objectAtIndex:3]] : nil;
		time5.text = (count >= 5) ? [self minutesTillArrivalWithDate:[upcomingTimes objectAtIndex:4]] : nil;
	}
	
	
	NSInteger nextBusIn = (int) ([[upcomingTimes objectAtIndex:0] timeIntervalSinceNow] / 60);
	timeUntilArrivalLabel.text = (nextBusIn >= 0 && nextBusIn < 100) ? [NSString stringWithFormat:@"%d", nextBusIn] : @"?";
	
	[super layoutSubviews];
}

- (void)dealloc {
	[arrivals release];
	arrivals = nil;
	
    [super dealloc];
}


@end
