//
//  WishItem.h
//  WishList
//
//  Created by Marvin Galang on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WishItem : NSObject

@property(nonatomic, retain) NSString *wish;
@property(nonatomic, retain) NSDecimalNumber *priceTag;

+ (WishItem*) wishItemWithPrice:(NSString *) newWishName : (NSNumber *) newPriceTag;




@end
