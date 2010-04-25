//
//  ShuttleTracAppDelegate.m
//  ShuttleTrac
//
//  Created by Brady Law on 3/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ShuttleTracAppDelegate.h"
#import "LoadingViewController.h"

@implementation ShuttleTracAppDelegate

@synthesize window;
@synthesize tabBarController;

@synthesize dataStore;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	loadingViewController = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
	[window	addSubview:loadingViewController.view];
	[self performSelectorInBackground:@selector(loadDataStore) withObject:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[dataStore release];
}

-(void)loadDataStore {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	dataStore = [[ShuttleTracDataStore alloc] init];
	[self performSelectorOnMainThread:@selector(loadMainApp) withObject:nil waitUntilDone:YES];
	
	[pool release];
}

-(void)loadMainApp {
	[loadingViewController.view removeFromSuperview];
	[loadingViewController release];
	
	[window addSubview:tabBarController.view];
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
	[loadingViewController release];
    [window release];
    [super dealloc];
}

@end

