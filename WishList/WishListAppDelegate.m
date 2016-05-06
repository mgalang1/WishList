//
//  WishListAppDelegate.m
//  WishList
//
//  Created by Marvin Galang on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishListAppDelegate.h"
#import "WishListViewController.h"

@implementation WishListAppDelegate

@synthesize momsController=momsController_;
@synthesize dadsController=dadsController_;
@synthesize window = _window;


#pragma mark - Destructors

- (void)dealloc
{
    self.window=nil;
    self.momsController=nil;
    self.dadsController=nil;
    [super dealloc];
}


#pragma mark - Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //Allocate and Initialize tab bar controller
	UITabBarController *tabController=[[[UITabBarController alloc] init]autorelease];

    self.momsController=[[[WishListViewController alloc] initWithCustomParameters:@"Mom's Wish List" iconName:@"momicon.png" fileName:@"momsWish.archive"]autorelease];
    
    self.dadsController=[[[WishListViewController alloc] initWithCustomParameters:@"Dad's Wish List" iconName:@"dadicon.png" fileName:@"dadsWish.archive"]autorelease];

    
	UINavigationController *tabViewController1 = [[[UINavigationController alloc] initWithRootViewController:self.momsController]autorelease];
	UINavigationController *tabViewController2 = [[[UINavigationController alloc] initWithRootViewController:self.dadsController]autorelease];
    
	NSMutableArray *viewControllersArray = [[[NSMutableArray alloc] init]autorelease];
	[viewControllersArray addObject:tabViewController1];
	[viewControllersArray addObject:tabViewController2];
    
    [tabController setViewControllers:viewControllersArray animated:YES];
    
    self.window.rootViewController = tabController; 

	[self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [self.momsController saveWishList];
    [self.dadsController saveWishList];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
