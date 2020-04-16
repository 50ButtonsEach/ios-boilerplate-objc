//
//  AppDelegate.m
//  ios-boilerplate-objc
//
//  Created by Oskar Öberg on 2016-04-14.
//  Copyright © 2016 Shortcut Labs AB. All rights reserved.
//

#import "AppDelegate.h"

@ import fliclib;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;
{
	BOOL wasHandled = NO;
	wasHandled = [[SCLFlicManager sharedManager] handleOpenURL:url];
	return wasHandled;
}

@end
