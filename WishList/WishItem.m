//
//  WishItem.m
//  WishList
//
//  Created by Marvin Galang on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishItem.h"

@implementation WishItem


@synthesize wish=wish_;
@synthesize priceTag=priceTag_;


#pragma mark - Initializers/Destructors

+ (WishItem*) wishItemWithPrice:(NSString *) newWishName : (NSDecimalNumber *) newPriceTag
{
    WishItem *newWish=[[[WishItem alloc] init] autorelease];
    
    [newWish setWish:newWishName];
    [newWish setPriceTag:newPriceTag];
    return newWish;
}

- (void)dealloc 
{
    self.wish=nil;
    self.priceTag=nil;
    [super dealloc];
}

#pragma mark - Archieving

- (id)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [super init])) {
        self.wish = [decoder decodeObjectForKey:@"wish"];
        self.priceTag = [decoder decodeObjectForKey:@"priceTag"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.wish forKey:@"wish"];
    [coder encodeObject:self.priceTag forKey:@"priceTag"];
}

@end
