//
//  WishListAppDelegate.h
//  WishList
//
//  Created by Marvin Galang on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WishListViewController;
@interface WishListAppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;
@property (nonatomic, retain) WishListViewController *momsController;
@property (nonatomic, retain) WishListViewController *dadsController;

@end
