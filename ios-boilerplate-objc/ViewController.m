//
//  ViewController.m
//  ios-boilerplate-objc
//
//  Created by Oskar Öberg on 2016-04-14.
//  Copyright © 2016 Shortcut Labs AB. All rights reserved.
//

#import "ViewController.h"
#import <fliclib/fliclib.h>


// These are demo keys, you must replace these with your own credentials before deploying to the App Store
// Get your API Keys here: https://flic.io/partners/developers/credentials

#warning Get your own API keys at https://flic.io/partners/developers/credentials
#define FLIC_APP_ID @"cfe4b5bb-ba39-4e51-808a-f9dcaad86341"
#define FLIC_APP_SECRET @"bf6b88da-3c46-46be-bfdb-b3135819183a"

@interface ViewController () <SCLFlicManagerDelegate, SCLFlicButtonDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[SCLFlicManager configureWithDelegate:self defaultButtonDelegate:self appID:FLIC_APP_ID appSecret:FLIC_APP_SECRET backgroundExecution:NO];
	self.imageView.layer.magnificationFilter = kCAFilterNearest;
	[self updateUI];
}

- (void)updateUI;
{
	if ([SCLFlicManager sharedManager].knownButtons.count > 0)
	{
		self.imageView.image = [UIImage imageNamed:@"flic"];
		[self.button setTitle:@"Forget button" forState:UIControlStateNormal];
	}
	else
	{
		self.imageView.image = [UIImage imageNamed:@"no-flic"];
		[self.button setTitle:@"Grab button" forState:UIControlStateNormal];
	}
}

- (IBAction)buttonPressed:(id)sender;
{
	if ([SCLFlicManager sharedManager].knownButtons.count > 0) // button exists
	{
		[[SCLFlicManager sharedManager] forgetButton:[SCLFlicManager sharedManager].knownButtons.allValues.firstObject];
	}
	else
	{
		[[SCLFlicManager sharedManager] grabFlicFromFlicAppWithCallbackUrlScheme:@"flic-boilerplate-objc"];
	}
}

#pragma mark - SCLFlicManagerDelegate

- (void)flicManagerDidRestoreState:(SCLFlicManager *)manager;
{
	// this happens after app boot to notify that your previously grabbed buttons has ben restored
	[self updateUI];
}

- (void)flicManager:(SCLFlicManager *)manager didGrabFlicButton:(SCLFlicButton *)button withError:(NSError *)error;
{
	if(error)
	{
		NSLog(@"Could not grab: %@", error);
	}

	// un-comment the following line if you need lower click latency for your application
	// this will consume more battery so don't over use it
	// button.lowLatency = YES;
	[self updateUI];
}

- (void)flicManager:(SCLFlicManager *)manager didForgetButton:(NSUUID *)buttonIdentifier error:(NSError *)error;
{
	[self updateUI];
}

#pragma mark - SCLFlicButtonDelegate

- (void)flicButton:(SCLFlicButton *)button didReceiveButtonDown:(BOOL)queued age:(NSInteger)age;
{
	self.imageView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.0);
	
	[UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
		self.imageView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
	} completion:nil];
}

@end