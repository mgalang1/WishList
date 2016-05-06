//
//  WishListModel.m
//  WishList
//
//  Created by Marvin Galang on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishListModel.h"
#import "WishItem.h"

@implementation WishListModel

@synthesize wishList=wishList_;
@synthesize listNew=listNew_;
@synthesize currentlySelectedIndexForDetail=currentlySelectedIndexForDetail_;


#pragma mark - Initializers/Destructors

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

- (void)dealloc 
{
    self.wishList=nil;
    [super dealloc];
}

#pragma mark - Archieving

- (id)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [super init])) {
        self.wishList = [decoder decodeObjectForKey:@"wishList"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.wishList forKey:@"wishList"];
}


#pragma mark - Loading & Saving

+ (id)loadSavedWishList: (NSString*) fileName
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *wishListURL = [documentsURL URLByAppendingPathComponent:fileName];
    
    NSData *wishListData = [NSData dataWithContentsOfURL:wishListURL];
    
    WishListModel *wishModel = nil;
    
    if (wishListData) {
        wishModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfURL:wishListURL]];
    }
    return wishModel.wishList;
}

- (void)saveWishList: (NSString *) fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSError *error = nil;
    if ([fileManager createDirectoryAtURL:documentsURL withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
        // Some more consideration should be given to error handling in this case
        NSLog(@"%s Unable to create documents directory: %@", __PRETTY_FUNCTION__, error);
        return;
    }
    
    NSURL *wishListURL = [documentsURL URLByAppendingPathComponent:fileName];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [data writeToURL:wishListURL atomically:YES];
}


#pragma mark - Wish Items Object Management

-(void) insertObject:(WishItem *)p inWishListAtIndex:(int)row
{
	[self.wishList insertObject:p atIndex:row];
}



-(void) removeObjectFromWishListAtIndex:(int)row

{
	[self.wishList removeObjectAtIndex:row];
}



-(NSArray *) loadInitialWishItem {
    
    NSArray *wishItems = [[[NSArray alloc] initWithObjects:
                      [WishItem wishItemWithPrice:@"Trip to Bangkok":[NSNumber numberWithFloat:5000]],
                      [WishItem wishItemWithPrice:@"Necklace":[NSNumber numberWithFloat:4600]],
                      [WishItem wishItemWithPrice:@"GPS Trex":[NSNumber numberWithFloat:200]],
                      [WishItem wishItemWithPrice:@"New Car":[NSNumber numberWithFloat:16000]],nil]autorelease];
    
    return wishItems;
    
}



@end
