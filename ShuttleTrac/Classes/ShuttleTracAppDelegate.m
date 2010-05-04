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
	NSString *path = [self myArchivePath];

	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *archiveData = [NSData dataWithContentsOfFile:path];
        dataStore = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
    }
		
	if(!dataStore) 
		dataStore = [[ShuttleTracDataStore alloc] init];
	
	[window addSubview:tabBarController.view];
	// [self performSelectorInBackground:@selector(loadDataStore) withObject:nil];
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
	[dataStore release];
    [super dealloc];
}

@end

