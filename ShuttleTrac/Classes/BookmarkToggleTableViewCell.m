//
//  BookmarkToggleTableViewCell.m
//  ShuttleTrac
//
//  Created by Brady Law on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BookmarkToggleTableViewCell.h"


@implementation BookmarkToggleTableViewCell

@synthesize bookmarked;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        bookmarked = NO;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
	if (!bookmarked)
		newTextLabel.text = @"Add to Favorites";
	else
		newTextLabel.text = @"Remove from Favorites";
	
	[super layoutSubviews];
}

- (void)dealloc {
    [super dealloc];
}


@end
