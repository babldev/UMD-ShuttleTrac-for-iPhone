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
	
	NSString *path = [self myArchivePath];

	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *archiveData = [NSData dataWithContentsOfFile:path];
        dataStore = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
    }
	
	[self performSelectorInBackground:@selector(loadDataStore) withObject:nil];
}

- (NSString *)myArchivePath {
    // Get a path to the sandbox'd documents directory
    NSString *documentsFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // Save / read from a file named "MyToDoEvent" in the documents directory
    NSString *path = [documentsFolderPath stringByAppendingPathComponent:@"MyArchive"];
    return path;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	NSString *path = [self myArchivePath];
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:dataStore];
    [archiveData writeToFile:path atomically:YES];
}

-(void)loadDataStore {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if(!dataStore) 
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
	[dataStore release];
    [super dealloc];
}

@end

