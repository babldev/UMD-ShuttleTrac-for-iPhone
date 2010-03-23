//
//  FirstViewController.h
//  ShuttleTrac
//
//  Created by Brady Law on 3/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NearMeViewController : UIViewController {
	IBOutlet UITextField *busNumber;
	IBOutlet UIActivityIndicatorView *loadingIndicator;
}

-(IBAction)loadBusTimes:(UIButton *)loadButton;

@end
