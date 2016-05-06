//
//  WishListViewController.h
//  WishList
//
//  Created by Marvin Galang on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WishListModel;
@class WishListDetailController;
@interface WishListViewController : UITableViewController 

@property (nonatomic, retain) WishListModel * myWishList;
@property (nonatomic, retain) WishListDetailController * detailController;
@property (nonatomic, retain) NSString * savedFileName;

-(id) initWithCustomParameters: (NSString *)title iconName:(NSString *) iconName fileName:(NSString *) targetFileName;
-(void) loadWishList;
-(void)saveWishList;


@end
