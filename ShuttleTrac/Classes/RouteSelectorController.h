//
//  RouteSelectorController.h
//  ShuttleTrac
//
//  Created by Brady Law on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusRoute.h"

@protocol RouteSelectorControllerDelegate

-(void)routeSelected:(BusRoute *)route;

@end


@interface RouteSelectorController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *tableView;
	
	NSArray *busRoutes;
	BusRoute *selectedRoute;
	
	id <RouteSelectorControllerDelegate> delegate;
}

-(IBAction)goBack:(UIBarButtonItem *)sender;

@property (assign, readwrite) NSArray *busRoutes;
@property (assign, readwrite) BusRoute *selectedRoute;
@property (assign, readwrite) id <RouteSelectorControllerDelegate> delegate;

@end
