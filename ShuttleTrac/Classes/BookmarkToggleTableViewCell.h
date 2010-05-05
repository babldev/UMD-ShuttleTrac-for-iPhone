//
//  BookmarkToggleTableViewCell.h
//  ShuttleTrac
//
//  Created by Brady Law on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookmarkToggleTableViewCell : UITableViewCell {
	IBOutlet UILabel *newTextLabel;
	BOOL bookmarked;
}

@property (assign, readwrite) BOOL bookmarked;

@end
