//
//  YDPopoverViewController.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDPopoverViewController.h"

@interface YDPopoverViewController ()
-(void)updateTargetStateWith:(NSInteger )_index;

//test
- (void)dataContentsWith:(NSInteger )_type;

@end

@implementation YDPopoverViewController

@synthesize target;

@synthesize delegate;

@synthesize datas;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style 
              title:(NSString *)_viewTitle 
		 buttonType:(NSInteger )_buttonType
		   delegate:(id<YDPopoverViewDelegate>)_delegate
{
	self = [super initWithStyle:style];
    if (self)
    {
//		[self dataContentsWith:_buttonType];
        self.title = _viewTitle;
//        self.target = _target;
		delegate = _delegate;
		currentTargetType = _buttonType;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style 
              title:(NSString *)_viewTitle 
             target:(id)_target
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = _viewTitle;
        self.target = _target;
    }
    return self;
}
-(void)updateTargetStateWith:(NSInteger )_index
{
//    if ([self.target isKindOfClass:([UIButton class])])
//    {
//        UIButton *button = (UIButton *)(self.target);
//        button.selected = NO;
//    }
	NSString *content = [datas objectAtIndex:_index];
	if ([delegate respondsToSelector:@selector(targetForPopoverView:content:buttonType:)]) 
	{
		[delegate targetForPopoverView:self content:content buttonType:currentTargetType];
	}
}




- (void)dealloc
{
	[datas release];datas = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[cell.textLabel setTextAlignment:UITextAlignmentCenter];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[datas objectAtIndex:indexPath.row]];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
	[self updateTargetStateWith:indexPath.row];
}

- (void)dataContentsWith:(NSInteger )_type
{
	switch (_type)
	{
		case YDPopoverTargetKDNO:
			datas = [[NSArray arrayWithObjects:@"R154245",@"R15422",@"R151256",@"R154561",@"R154111",@"R154112",nil] retain];
			break;
		case YDPopoverTargetColor:
			datas = [[NSArray arrayWithObjects:@"50NYE0057",@"50RDE0081",@"50RW001",@"50NYE0047",@"50NYE0053",nil] retain];
			break;
		case YDPopoverTargetStep:
			datas = [[NSArray arrayWithObjects:@"一步法",@"二步法",@"三步法",@"四步法",nil] retain];
			break;
		case YDPopoverTargetCost:
			datas = [[NSArray arrayWithObjects:@"L",@"M",@"H",nil] retain];
			break;
		case YDPopoverTargetSimpleColor:
			datas = [[NSArray arrayWithObjects:@"WH",@"RW",@"YW",@"OR",@"BG",@"KK",@"NY",nil] retain];

			break;
		case YDPopoverTargetType:
			datas = [[NSArray arrayWithObjects:@"活性",@"分散",@"硫化",@"还原",nil] retain];

			break;
		case YDPopoverTargetDeep:
			datas = [[NSArray arrayWithObjects:@"低",@"中",@"高",nil] retain];
			break;
		case YDPopoverTargetGanghao:
			datas = [[NSArray arrayWithObjects:@"G154245",@"G15422",@"G151256",@"G154561",@"G154111",@"G154112",nil] retain];
			break;
		case YDPopoverTargetPinMing:
			datas = [[NSArray arrayWithObjects:@"P154245",@"P15422",@"P151256",@"P154561",@"P154111",@"P154112",nil] retain];
			break;



		default:
			break;
	}

}

@end
