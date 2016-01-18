    //
//  YDBulkQueryNavigationViewController.m
//  YiDa
//
//  Created by Ni on 12-11-15.
//  Copyright 2012 meson.com. All rights reserved.
//

#import "YDBulkQueryNavigationViewController.h"
#import "YDScanViewController.h"
#import "YDAppDelegate.h"


@implementation YDBulkQueryNavigationViewController

@synthesize  navigationBarImageView = navigationBarImageView_;
@synthesize  viewTypeImage = viewTypeImage_;
@synthesize  userImageView = userImageView_;
@synthesize  outputButton = outputButton_;
@synthesize  cancelButton = cancelButton_;
@synthesize  logoutButton = logoutButton_;
@synthesize backButton = backButton_;

@synthesize recipeButton = recipeButton_;
@synthesize varietyButton = varietyButton_;
@synthesize progressButton = progressButton_;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor colorWithRed:222/255.0 green:218/255.0 blue:209/255.0 alpha:1.0]];
	recipeButton_.tag = YDNavigationBarViewBulkRecipe;
	[recipeButton_ setBackgroundColor:[UIColor colorWithRed:222/255.0 green:218/255.0 blue:209/255.0 alpha:1.0]];
	varietyButton_.tag = YDNavigationBarViewBulkVariety;
	[varietyButton_ setBackgroundColor:[UIColor colorWithRed:222/255.0 green:218/255.0 blue:209/255.0 alpha:1.0]];
	[progressButton_ setBackgroundColor:[UIColor colorWithRed:222/255.0 green:218/255.0 blue:209/255.0 alpha:1.0]];
	progressButton_.tag = YDNavigationBarViewBulkProgress;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return interfaceOrientation==UIInterfaceOrientationLandscapeLeft || 
	interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)dealloc 
{
	[navigationBarImageView_ release];navigationBarImageView_ = nil;
    [viewTypeImage_ release];viewTypeImage_ = nil;
    [userImageView_ release];userImageView_ = nil;
    [outputButton_ release];outputButton_ = nil;
    [cancelButton_ release];cancelButton_= nil;
    [logoutButton_ release];logoutButton_ = nil;
    [backButton_ release];backButton_ = nil;
    
	[recipeButton_ release];recipeButton_ = nil;
	[varietyButton_ release];varietyButton_ = nil;
	[progressButton_ release];progressButton_ = nil;
	
    [super dealloc];
}

- (YDAppDelegate *)YDAppDelegate
{
    return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (IBAction)backButtonPress:(UIButton *)_sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutButtonPress:(id)_sender
{
    [[self YDAppDelegate] logOut];

}
- (IBAction)cancelButtonPress:(id)_sender;
{
    
}
- (IBAction)outputButtonPress:(id)_sender
{
    
}

- (IBAction)queryOptionButtonPress:(UIButton *)_sender
{
	NSInteger viewType = _sender.tag;

    
    YDScanViewController    *scanViewController = [[YDScanViewController alloc] initWithNibName:@"YDScanViewController" bundle:nil view:viewType];
    [self.navigationController pushViewController:scanViewController animated:YES];
    [scanViewController release];
    scanViewController = nil;
	
//    switch (viewType) 
//    {
//        case YDBulkQueryOptionRecipe: 
////            image = [UIImage imageNamed:@"ButtonColorSelected.png"];
//            break;
//            //
//        case YDBulkQueryOptionVariety:
////            image = [UIImage imageNamed:@"ButtonLabPalettesSelected.png"];
//            break;
//            //
//        case YDBulkQueryOptionProgress:
////            image = [UIImage imageNamed:@"ButtonLabTabSelected.png"];
//			
//            break;
// 
//			
//        default:
//            break;
//    }
	
}


@end
