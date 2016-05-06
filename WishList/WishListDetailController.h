//
//  WishListDetailController.h
//  WishList
//
//  Created by Marvin Galang on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WishListModel;


@interface WishListDetailController : UITableViewController <UITextFieldDelegate>


@property (nonatomic, retain) WishListModel *myWishList;
@property (nonatomic, retain) NSArray *fieldLabels;
@property (nonatomic, retain) NSString *tmpWishName;
@property (nonatomic, retain) NSString *tmpWishPrice;
@property (nonatomic, retain) UITextField *textFieldBeingEdited;


@end
