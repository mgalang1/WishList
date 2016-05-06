//
//  WishListViewController.m
//  WishList
//
//  Created by Marvin Galang on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "WishListViewController.h"
#import "WishListDetailController.h"
#import "WishListModel.h"
#import "WishItem.h"

@implementation WishListViewController

@synthesize myWishList=myWishList_;
@synthesize detailController=detailController_;
@synthesize savedFileName;





#pragma mark - Initializers/Destructors

-(id) initWithCustomParameters: (NSString *)title iconName:(NSString *) iconName fileName:(NSString *) targetFileName  {
    
    self = [super init];
    if (self) {
        // Initialization code here.
        self.title=title;
        self.tabBarItem.image=[UIImage imageNamed:iconName];
        self.tabBarItem.title=title;
        
        self.detailController = [[[WishListDetailController alloc] initWithStyle:UITableViewStyleGrouped]autorelease];
        self.savedFileName=targetFileName;
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.myWishList=nil;
    self.detailController=nil;
    self.savedFileName=nil;
    [super dealloc];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    
    self.tableView=[[[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
                                                 style:UITableViewStylePlain]autorelease];
    
    self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.delegate = self;
	self.tableView.dataSource = self;
    
    //self.view is the same as self.tableView for UITableViewController
    
}

-(void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewWish)] autorelease];
    
    if (!self.myWishList) 
        {
            self.myWishList=[[[WishListModel alloc]init]autorelease];
            [self loadWishList];
        }
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    //myWishList needs to be created first before observing it. Previously this is being called 
    //in loadview method. Since myWishList is not created yet it wont work
    [self.myWishList addObserver:self forKeyPath:@"wishList" options:NSKeyValueObservingOptionNew context:NULL];

}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.myWishList.wishList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleValue1
				 reuseIdentifier:cellIdentifier] autorelease];
        //cell.showsReorderControl = YES;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [[self.myWishList.wishList objectAtIndex:row] valueForKeyPath:@"wish"];
    
    static NSNumberFormatter *priceFormatter = nil;
    if (priceFormatter == nil) {
        priceFormatter = [[NSNumberFormatter alloc] init];
        priceFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    
    cell.detailTextLabel.text=[priceFormatter stringFromNumber:[[self.myWishList.wishList objectAtIndex:row] valueForKeyPath:@"priceTag"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSUInteger row = [indexPath row];
    //[self.myWishList removeObjectFromWishListAtIndex:row];
    [[self.myWishList mutableArrayValueForKey:@"wishList"] removeObjectAtIndex:row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
      withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath {
    
    NSUInteger fromRow = [fromIndexPath row];
    NSUInteger toRow = [toIndexPath row];

    WishItem *object = [[self.myWishList.wishList objectAtIndex:fromRow] retain];
//    [self.myWishList removeObjectFromWishListAtIndex:fromRow];
//    [self.myWishList insertObject:object inWishLisAtIndex:toRow];
    [[self.myWishList mutableArrayValueForKey:@"wishList"] removeObjectAtIndex:fromRow];
    [[self.myWishList mutableArrayValueForKey:@"wishList"] insertObject:object atIndex:toRow]; 
    
    [object release];
    
}

- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Table View Delegate Methods

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
	
    self.detailController.title = [[self.myWishList.wishList objectAtIndex:row] valueForKeyPath:@"wish"];
    
    self.myWishList.currentlySelectedIndexForDetail=row;
    self.myWishList.listNew=NO;
    
    self.detailController.myWishList= self.myWishList;
    
    [self.navigationController pushViewController:self.detailController
										 animated:YES];
    [self.detailController.tableView reloadData];
    
}


#pragma mark - Wish List Management Methods

-(void) loadWishList {
    
    self.myWishList.wishList = [WishListModel loadSavedWishList:savedFileName];
    
    if (!self.myWishList.wishList) {
    
        self.myWishList.wishList = [[[NSMutableArray alloc] initWithArray:self.myWishList.loadInitialWishItem]autorelease];
    }
}

- (void)saveWishList
{
    [self.myWishList saveWishList:savedFileName];
}

- (void) addNewWish {
    self.detailController.title = @"New Wish";    
    
    self.myWishList.currentlySelectedIndexForDetail=self.myWishList.wishList.count;
    self.myWishList.listNew=YES;
    self.detailController.myWishList= self.myWishList;
    
    [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    //UINavigationController *test=self.detailController;
    
    //[self.navigationController presentModalViewController:self.detailController
	//									 animated:YES];
    
    
    [self.navigationController pushViewController:self.detailController
										 animated:YES];
    
    [self.detailController.tableView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"Test");
}


@end
