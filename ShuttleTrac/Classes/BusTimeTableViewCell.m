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
	busLabel.text = arrivals.route.routeName;
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
	
	[super layoutSubviews];
}

- (void)dealloc {
	[arrivals release];
	arrivals = nil;
	
    [super dealloc];
}


@end
