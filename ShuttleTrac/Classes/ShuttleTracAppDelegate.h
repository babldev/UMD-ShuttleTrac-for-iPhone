//
//  ShuttleTracAppDelegate.h
//  ShuttleTrac
//
//  Created by Brady Law on 3/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShuttleTracDataStore.h"

@interface ShuttleTracAppDelegate : NSObject <UIApplicationDelegate, 
		UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	
	ShuttleTracDataStore *dataStore;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) ShuttleTracDataStore *dataStore;

@end
