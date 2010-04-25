//
//  RouteSelectorTableViewCell.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RouteSelectorTableViewCell.h"


@implementation RouteSelectorTableViewCell

@synthesize route;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

- (void)layoutSubviews {
	if (route == nil) {
		self.textLabel.text = @"All Stops";
	} else {
		self.textLabel.text = route.routeName;
		self.detailTextLabel.text = [NSString stringWithFormat:@"#%d", route.routeID];
	}
	
	[super layoutSubviews];
}


- (void)dealloc {
    [super dealloc];
}


@end
