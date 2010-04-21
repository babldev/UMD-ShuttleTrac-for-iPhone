//
//  ShuttleTracAppDelegate.m
//  ShuttleTrac
//
//  Created by Brady Law on 3/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ShuttleTracAppDelegate.h"


@implementation ShuttleTracAppDelegate

@synthesize window;
@synthesize tabBarController;

@synthesize dataStore;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    dataStore = [[ShuttleTracDataStore alloc] init];
	[dataStore refreshAllBookmarkedStops];
	
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[dataStore release];
}

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

