//
//  WishListDetailController.m
//  WishList
//
//  Created by Marvin Galang on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishListDetailController.h"
#import "WishListModel.h"
#import "WishItem.h"

#define numberOfEditableRows          2
#define kWishListNameTag              0
#define kWishListPriceTag             1
#define kLabelTag                     4096

@implementation WishListDetailController

@synthesize myWishList=myWishList_;
@synthesize fieldLabels=fieldLabels_;
@synthesize tmpWishName=tmpWishName_;
@synthesize tmpWishPrice=tmpWishPrice_;
@synthesize textFieldBeingEdited=textFieldBeingEdited_;



#pragma mark - Initializers/Destructors

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
    self.fieldLabels=nil;
    self.tmpWishName=nil;
    self.tmpWishPrice=nil;
    self.textFieldBeingEdited=nil;
    [super dealloc];
}


#pragma mark - Target Action Methods

- (void) hideKeyboard {
    [self.textFieldBeingEdited resignFirstResponder];
}

- (void)textFieldDone:(id)sender {
    //determine the tableview cell associated to the current text field
    UITableViewCell *cell =
	(UITableViewCell *)[[sender superview] superview];
    
    //determine the tag of the current text field
    UITextField *currentTextField = nil;
    for (UIView *oneView in cell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            currentTextField = (UITextField *)oneView;
    }
    
    NSUInteger tagID=currentTextField.tag;
    switch (tagID) {
        case kWishListNameTag:
            self.tmpWishName=currentTextField.text;
            self.title=self.tmpWishName;
            break;
        case kWishListPriceTag:
            self.tmpWishPrice=currentTextField.text;
			break;
        default:
            break;
    }
    
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    if (row >= numberOfEditableRows) {
        row = 0;
    }
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:row inSection:0];
    UITableViewCell *nextCell = [self.tableView
								 cellForRowAtIndexPath:newPath];
    
    UITextField *nextField = nil;
    for (UIView *oneView in nextCell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            nextField = (UITextField *)oneView;
    }
    [nextField becomeFirstResponder];
}


- (void) cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender {
    
    if (self.textFieldBeingEdited != nil) {
        NSUInteger tagID=self.textFieldBeingEdited.tag;
        switch (tagID) {
            case kWishListNameTag:
                self.tmpWishName=self.textFieldBeingEdited.text;
                break;
            case kWishListPriceTag:
                self.tmpWishPrice=self.textFieldBeingEdited.text;
                break;
            default:
                break;
        }
    }
    
    if ([self.tmpWishPrice length] > 0 && self.tmpWishPrice != nil && [self.tmpWishPrice isEqual:@""] == FALSE)
        {
        if (![[self.tmpWishPrice substringToIndex:1] isEqualToString:@"$"]) {
            self.tmpWishPrice=[NSString stringWithFormat:@"$%@",self.tmpWishPrice];
            }
        }
    
    static NSNumberFormatter *priceFormatter = nil;
    if (priceFormatter == nil) {
        priceFormatter = [[NSNumberFormatter alloc] init];
        priceFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    
    NSDecimalNumber *price = (NSDecimalNumber *)[priceFormatter numberFromString:self.tmpWishPrice];
    NSString *name=self.tmpWishName;    
    
    if (name.length==0) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Invalid Description!!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil]autorelease];
        [alert show];
        
        //Invalid Wish name
        return;
        }
    
    if (!price) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Invalid Price!!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil]autorelease];
        [alert show];
        
        //Invalid Price
        return;
    }
    
    
    WishItem *wishNew = [WishItem wishItemWithPrice:name:price];
    
    if (self.myWishList.isListNew) {
            [[self.myWishList mutableArrayValueForKey:@"wishList"] insertObject:wishNew atIndex:self.myWishList.currentlySelectedIndexForDetail];   
            }
        else
            {
            [[self.myWishList mutableArrayValueForKey:@"wishList"] removeObjectAtIndex:self.myWishList.currentlySelectedIndexForDetail];
            [[self.myWishList mutableArrayValueForKey:@"wishList"] insertObject:wishNew atIndex:self.myWishList.currentlySelectedIndexForDetail]; 
            }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
    
    self.fieldLabels=[[[NSArray alloc] initWithObjects:@"Description:", @"Price Tag:", nil]autorelease];
    
    UITapGestureRecognizer *gestureRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]autorelease];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    return numberOfEditableRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *wishListCellIdentifier = @"wishListCellIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             wishListCellIdentifier];
    if (cell == nil) {
		
        cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleValue1
				 reuseIdentifier:wishListCellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] initWithFrame:
						  CGRectMake(10, 10, 92, 25)];
        label.textAlignment = UITextAlignmentLeft;
        label.tag = kLabelTag;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.backgroundColor= [UIColor clearColor];
        
        [cell.contentView addSubview:label];
        [label release];
		
        UITextField *textField = [[UITextField alloc] initWithFrame:
                                  CGRectMake(100, 10, 200, 25)];
        
        textField.autocorrectionType=UITextAutocorrectionTypeNo;
        textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        textField.clearsOnBeginEditing = NO;
        [textField setDelegate:self];
        //textField.returnKeyType = UIReturnKeyDone;
        [textField addTarget:self
                      action:@selector(textFieldDone:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:textField];
        [textField release];
    }
    
    NSUInteger row = [indexPath row];
	
    UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];
    UITextField *textField = nil;
    
    for (UIView *oneView in cell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            textField = (UITextField *)oneView;
    }
    
    label.text = [self.fieldLabels objectAtIndex:row];
    if (self.myWishList.isListNew==NO) {
    
        static NSNumberFormatter *priceFormatter = nil;
        if (priceFormatter == nil) {
            priceFormatter = [[NSNumberFormatter alloc] init];
            priceFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        }
        
        switch (row) {
            case kWishListNameTag:
            textField.text=[[self.myWishList.wishList objectAtIndex:self.myWishList.currentlySelectedIndexForDetail] valueForKeyPath:@"wish"];
            self.tmpWishName=textField.text;
            break;
        case kWishListPriceTag:
            textField.text=[priceFormatter stringFromNumber:[[self.myWishList.wishList objectAtIndex:self.myWishList.currentlySelectedIndexForDetail] valueForKeyPath:@"priceTag"]];
            self.tmpWishPrice=[priceFormatter stringFromNumber:[[self.myWishList.wishList objectAtIndex:self.myWishList.currentlySelectedIndexForDetail] valueForKeyPath:@"priceTag"]];
			break;
        default:
            break;
        }
    }
    else {
        textField.text=nil;
        self.tmpWishName=nil;
        self.tmpWishPrice=nil;
        self.title=@"New Wish";
        }
    
    textField.tag = row;
    return cell;
}

#pragma mark - Text Field Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textFieldBeingEdited = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSUInteger tagID=textField.tag;
    switch (tagID) {
        case kWishListNameTag:
            self.tmpWishName=textField.text;
            self.title=self.tmpWishName;
            break;
        case kWishListPriceTag:
            self.tmpWishPrice=textField.text;
			break;
        default:
            break;
    }
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//	[textField resignFirstResponder];
//	return YES;
//}


@end
