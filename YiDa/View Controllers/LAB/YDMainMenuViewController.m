//
//  YDMainMenuViewController.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDMainMenuViewController.h"
#import "YDCustomNavigationBar.h"
#import "Constants.h"
#import "YDScanViewController.h"
#import "YDBulkQueryNavigationViewController.h"
#import "PopoverView.h"
#import "YDColorPopoverView.h"

@interface YDMainMenuViewController ()

- (void)setUpAppearance;
- (void)setUpAppearance:(NSInteger )_userType;

- (void)setUpInterface:(NSInteger)_userType;

- (void)setUpBulkInterface;

- (void)setUpLabInterface;

- (void)logoutButtonPress:(UIButton *)_sender;
- (void)menuButtonPress:(UIButton *)_sender;

@end

@implementation YDMainMenuViewController

@synthesize mainMenuMode;

@synthesize palettsButton = palettsButton_;
@synthesize tabButton = tabButton_;
@synthesize addictionButton = addictionButton_;
@synthesize searchButton = searchButton_;
@synthesize logoutButton = logoutButton_;
@synthesize backgroundImageView = backgroundImageView_;
@synthesize navigationBarBackgroundView = navigationBarBackgroundView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        mainMenuMode = MainMenuNone;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
             userTpye:(NSInteger)_userType
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        mainMenuMode = _userType;
        [self setUpAppearance];
        [self setUpInterface:mainMenuMode];
    }
    return self;
}


- (void)dealloc
{
    [palettsButton_ release];palettsButton_ = nil;
    [tabButton_ release];tabButton_ = nil;
    [addictionButton_ release];addictionButton_ = nil;
    [searchButton_ release];searchButton_ = nil;
    [backgroundImageView_ release];backgroundImageView_ = nil;
    [navigationBarBackgroundView_ release];navigationBarBackgroundView_= nil;
    [logoutButton_ release];logoutButton_ = nil;
    [super dealloc];
}


- (YDAppDelegate *)YDAppDelegate
{
    return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)setUpAppearance
{
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BackgroundMenu" ofType:@"png"]];
    [background setImage:image];
    [background setBackgroundColor:[UIColor redColor]];
    self.backgroundImageView = background;
    [background release];background = nil;
    image = nil;
//    navigationbackground imageVIE
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 39)];
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NavigationBackground" ofType:@"png"]];
    [background setImage:image];
    self.navigationBarBackgroundView = background;
    [background release];background = nil;
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 53, 33)];
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ButtonNavigationBarLogout" ofType:@"png"]];
    [background setImage:image];
//    self.navigationBarBackgroundView = background;
    [self.view addSubview:background];
    [background release];background = nil;
    
    
//    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    logoutBtn.tag = YDNavigationBarButtonLogout;
//    [logoutBtn setFrame:CGRectMake(0, 1, 53, 33)];
//    [logoutBtn addTarget:self action:@selector(navigationButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
//    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"ButtonNavigationBarLogout.png"] forState:UIControlStateNormal];
//    self.logoutButton = logoutBtn;
    
    
    
    
//    [self.view addSubview:logoutButton_];

    
    [self.view addSubview:backgroundImageView_];
    [self.view addSubview:navigationBarBackgroundView_];
}

- (void)setUpInterface:(NSInteger)_userType
{
    if (_userType == MainMenuBulk) {
        [self setUpBulkInterface];
        [self setUpAppearance:_userType];
    }
    else if (_userType == MainMenuTab)
    {
        [self setUpLabInterface];
        [self setUpAppearance:_userType];
    }
    
//    注销按钮
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.tag = YDNavigationBarButtonLogout;
    [logoutBtn setFrame:CGRectMake(967, 1, 53, 33)];
    [logoutBtn addTarget:self action:@selector(logoutButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"ButtonNavigationBarLogout.png"] forState:UIControlStateNormal];
    self.logoutButton = logoutBtn;
    [self.view addSubview:logoutButton_];
}

- (void)setUpAppearance:(NSInteger )_userType
{
    if (_userType == YDUserTypeLab) 
    {
        UIImageView *userGroupImage = [[UIImageView alloc] initWithFrame:CGRectMake(861, 1, 106, 33)];
        [userGroupImage setImage:[UIImage imageNamed:@"ButtonNavigationBarLabUser.png"]];
        [self.view addSubview:userGroupImage];
        [userGroupImage release];
        
        
    }
    else if (_userType == YDUserTypeBulk)
    {
        UIImageView *userGroupImage = [[UIImageView alloc] initWithFrame:CGRectMake(861, 1, 106, 33)];
        [userGroupImage setImage:[UIImage imageNamed:@"ButtonNavigationBarBulkUser.png"]];
        [self.view addSubview:userGroupImage];
        [userGroupImage release];
    }
    

}


- (void)setUpBulkInterface
{
    [self setUpAppearance];
    
//    调方
    UIButton *tPalettsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tPalettsButton.tag = YDNavigationBarViewBulkPalettes;
    [tPalettsButton setFrame:CGRectMake(186, 156, 326, 246)];
       [tPalettsButton addTarget:self action:@selector(menuButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonBulkPalettes.png"] forState:UIControlStateNormal];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonBulkPalettesSelected.png"] forState:UIControlStateHighlighted];
    self.palettsButton = tPalettsButton;
    tPalettsButton = nil;
    
//    标记
    tPalettsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tPalettsButton.tag = YDNavigationBarViewBulkTab;
    [tPalettsButton setFrame:CGRectMake(516, 156, 326, 246)];
       [tPalettsButton addTarget:self action:@selector(menuButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonBulkTab.png"] forState:UIControlStateNormal];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonBulkTabSelected.png"] forState:UIControlStateHighlighted];
    self.tabButton = tPalettsButton;
    tPalettsButton = nil;
//    加成
    tPalettsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tPalettsButton.tag = YDNavigationBarViewBulkAddiction;
    [tPalettsButton setFrame:CGRectMake(186, 406, 326, 246)];
       [tPalettsButton addTarget:self action:@selector(menuButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonBulkAddition.png"] forState:UIControlStateNormal];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonBulkAdditionSelected.png"] forState:UIControlStateHighlighted];
    self.addictionButton = tPalettsButton;
    tPalettsButton = nil;
    
//    查询
    tPalettsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tPalettsButton.tag = YDNavigationBarViewBulkQuery;
    [tPalettsButton setFrame:CGRectMake(516, 406, 326, 246)];
       [tPalettsButton addTarget:self action:@selector(menuButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonQuery.png"] forState:UIControlStateNormal];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonQuerySelected.png"] forState:UIControlStateHighlighted];
    
    self.searchButton = tPalettsButton;
    tPalettsButton = nil;
    
    
    [self.view addSubview:palettsButton_];
    [self.view addSubview:tabButton_];
    [self.view addSubview:addictionButton_];
    [self.view addSubview:searchButton_];
}

- (void)setUpLabInterface
{
    [self setUpAppearance];
    
//    选料
    UIButton *tPalettsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tPalettsButton.tag = YDNavigationBarViewLabColor;
    [tPalettsButton setFrame:CGRectMake(186, 156, 326, 246)];
    [tPalettsButton addTarget:self action:@selector(menuButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonColor.png"] forState:UIControlStateNormal];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonColorSelected.png"] forState:UIControlStateHighlighted];
    self.palettsButton = tPalettsButton;
    tPalettsButton = nil;
    
//    调方
    tPalettsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tPalettsButton.tag = YDNavigationBarViewLabPalettes;
    [tPalettsButton setFrame:CGRectMake(516, 156, 326, 246)];
       [tPalettsButton addTarget:self action:@selector(menuButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonLabPalettes.png"] forState:UIControlStateNormal];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonLabPalettesSelected.png"] forState:UIControlStateHighlighted];
    self.tabButton = tPalettsButton;
    tPalettsButton = nil;
    
    
//    标记
    tPalettsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tPalettsButton.tag = YDNavigationBarViewLabTab;
    [tPalettsButton setFrame:CGRectMake(186, 406, 326, 246)];
       [tPalettsButton addTarget:self action:@selector(menuButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonLabTab.png"] forState:UIControlStateNormal];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonLabTabSelected.png"] forState:UIControlStateHighlighted];
    self.addictionButton = tPalettsButton;
    tPalettsButton = nil;
    
//    查询
    tPalettsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tPalettsButton.tag = YDNavigationBarViewLabQuery;
    [tPalettsButton setFrame:CGRectMake(516, 406, 326, 246)];
       [tPalettsButton addTarget:self action:@selector(menuButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonQuery.png"] forState:UIControlStateNormal];
    [tPalettsButton setBackgroundImage:[UIImage imageNamed:@"ButtonQuerySelected.png"] forState:UIControlStateHighlighted];
    
    self.searchButton = tPalettsButton;
    tPalettsButton = nil;
    
    
    [self.view addSubview:palettsButton_];
    [self.view addSubview:tabButton_];
    [self.view addSubview:addictionButton_];
    [self.view addSubview:searchButton_];
}



#pragma ---
#pragma button action

- (void)logoutButtonPress:(UIButton *)_sender
{
//    [[self YDAppDelegate] presentLoginViewController];
//    [[self YDAppDelegate] logoutWithResultBlock:^(NSString *result)
//    {
//        if ([result isEqualToString:@"OK"])
//        {
//            [self didLogout];
//        }
//    }];
    [[self YDAppDelegate] logOut];
}

- (void)didLogout
{
    [[self YDAppDelegate] presentLoginViewController];
}

- (void)menuButtonPress:(UIButton *)_sender
{
    NSInteger viewType = _sender.tag;
	
	if (viewType == YDNavigationBarViewBulkQuery)
	{
		YDBulkQueryNavigationViewController *controller = [[YDBulkQueryNavigationViewController alloc] initWithNibName:@"YDBulkQueryNavigationViewController" bundle:nil];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];controller = nil;
        return;
	}
    
    YDScanViewController    *scanViewController = [[YDScanViewController alloc] initWithNibName:@"YDScanViewController" bundle:nil view:viewType];
    scanViewController.currentUserType = self.mainMenuMode;
	[self.navigationController pushViewController:scanViewController animated:YES];
    [scanViewController release];
    scanViewController = nil;
	
//	YDColorPopoverView *popover = [[YDColorPopoverView alloc] 
//								   initWithFrame:CGRectMake(0, 0, 164, 142) 
//								   type:YDColorPopoverMoreType];
//	
//	[PopoverView showPopoverAtPoint:CGPointMake(50, 50) inView:self.view withContentView:popover delegate:self];
//
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    YDCustomNavigationBar   *temp = [[YDCustomNavigationBar alloc] initWithLeftButtonNumber:4 viewType:YDNavigationBarViewColor userType:mainMenuMode delegate:nil];
//    [self.view addSubview:temp];
//    [temp release];
	[self.view setBackgroundColor:kColor];
    
    
//    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
////    dispatch_queue_t testQueue = dispatch_queue_create("test.queue", NULL);
////    dispatch_async(testQueue, ^{
//     if ([NSThread mainThread])
//     {
//         NSLog(@"main Thread call!");
//        NSString *resutl = [networkDataMemberHandle SaveLabRecipeInfo:@"LB2012-2809" Color_Code:@"50RDE0081" Weight:@"75.00" User_ID:@"sunyan" Recipe_NO:@"" NA2CO3:@"20,00000" NA2SO4:@"90,00000" Keep_Temperature_Time:@"90" Group_ID:@"99" ChemicalIDStr:@"205,195,187" UsageStr:@"1.5,3,0.7" OldUsageStr:@"1.5,3,0.7"];
//        
//        NSLog(@"测试 output    %@",resutl);
////        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            NSLog(@"测试 output  main Thread   %@",resutl);
//     }
//        });
//    });
    
//    dispatch_release(testQueue);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation==UIInterfaceOrientationLandscapeLeft || 
	interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end
