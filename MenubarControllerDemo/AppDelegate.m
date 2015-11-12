//
//  AppDelegate.m
//  MenubarControllerDemo
//
//  Created by zuopengl on 11/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "AppDelegate.h"
#import "UIMenuBarController.h"
#import "ViewControllerItem1.h"
#import "ViewControllerItem2.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    UIView *superV1 = [[UIView alloc] init];
//    UIView *superV2 = [[UIView alloc] init];
//    UIView *superV3 = [[UIView alloc] init];
//    UIView *superV4 = [[UIView alloc] init];
//    UIView *view = [[UIView alloc] init];
//    [superV1 addSubview:view];
//    [superV2 addSubview:view];
//    [superV3 addSubview:view];
//    [superV4 addSubview:view];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ViewControllerItem1 *item1 = [[ViewControllerItem1 alloc] initWithMenuBarItemTitle:@"item1"];
    ViewControllerItem2 *item2 = [[ViewControllerItem2 alloc] initWithMenuBarItemTitle:@"item2"];
    UIMenuBarController *mbVC = [[UIMenuBarController alloc] initWithViewControllers:@[item1, item2]];
    
    
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = mbVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
