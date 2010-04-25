//
//  BookmarksEditorController.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStop.h"

@protocol BookmarksEditorControllerDelegate

-(void)bookmarkEditingCompleted:(NSArray *)bookmarks;
-(void)bookmarkEditingCancelled;

@end


@interface BookmarksEditorController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *tableView;
	NSMutableArray *bookmarkedStops;
	
	id <BookmarksEditorControllerDelegate> delegate;
}

-(IBAction)editingDone:(UIBarButtonItem *)sender;
-(IBAction)editingCancelled:(UIBarButtonItem *)sender;

@property (retain, readwrite) NSMutableArray *bookmarkedStops;
@property (assign, readwrite) id <BookmarksEditorControllerDelegate> delegate;

@end
