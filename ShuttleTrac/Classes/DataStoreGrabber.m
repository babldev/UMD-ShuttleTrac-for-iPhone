//
//  ShuttleTracDataStoreGrabber.m
//  ShuttleTrac
//
//  Created by Brady Law on 4/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataStoreGrabber.h"

ShuttleTracAppDelegate *GetAppDelegate() 
{
	return (ShuttleTracAppDelegate*)[UIApplication sharedApplication].delegate; 
}

ShuttleTracDataStore* GetShuttleTracDataStore()
{
    return [GetAppDelegate() dataStore];
}

