//
//  WishListModel.h
//  WishList
//
//  Created by Marvin Galang on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WishItem;
@interface WishListModel : NSObject 

@property (nonatomic, retain) NSMutableArray *wishList;
@property (nonatomic, assign, getter=isListNew) BOOL listNew;
@property (nonatomic, assign) NSUInteger currentlySelectedIndexForDetail;

-(void) insertObject:(WishItem *)object inWishListAtIndex:(int)index;
-(void) removeObjectFromWishListAtIndex:(int)index;
-(NSArray *) loadInitialWishItem;
+(id)loadSavedWishList: (NSString*) fileName;
-(void)saveWishList: (NSString *) fileName;

@end
