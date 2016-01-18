//
//  YDUserLoginViewController.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDUserLoginViewController.h"
#import "YDAppDelegate.h"
#import "MBProgressHUD.h"

@interface YDUserLoginViewController ()

- (void)processFieldEntries ;

- (YDAppDelegate *)YDAppDelegate;

- (void)presentBackApplication;
- (void)updateViewFrame:(CGFloat )_height;
- (void)getLoginUserTypeWiht:(NSString *)_name;
- (void)userLoginWith:(NSString *)_userName passWord:(NSString *)_password;

@end

@implementation YDUserLoginViewController

@synthesize userNameField = userNameField_;
@synthesize userPasswordField = userPasswordField_;
@synthesize loginButton = loginButton_;

@synthesize userName = userName_;
@synthesize userPassword = userPassword_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         networkDataMemberHandle = [DataMember shareInstance];
    }
    return self;
}

- (YDAppDelegate *)YDAppDelegate
{
    return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)presentBackApplication
{
//    UIViewController *wallViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
//    [(UINavigationController *)self.presentingViewController pushViewController:wallViewController animated:NO];
//    NSLog(@"presented %@",NSStringFromClass([self.presentedViewController class]));
//    NSLog(@"presenting %@",NSStringFromClass([self.presentingViewController class]));
    //    [self.presentingViewController dismissModalViewControllerAnimated:YES];
//    NSInteger t = [self.userPassword intValue];
//    [[self YDAppDelegate] presentApplicationView:t];
//    //    [self presentViewController:<#(UIViewController *)#> animated:<#(BOOL)#> completion:<#^(void)completion#>]
    
    [[self YDAppDelegate] presentApplicationView:userType withName:self.userName withPassword:self.userPassword];
}




- (void)awakeFromNib
{
    //    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)] autorelease];
    //    [self.view setBackgroundColor:[UIColor redColor]];
    //    NSLog(@"the frame %@",NSStringFromCGRect(self.view.bounds));
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    NSLog(@"background image frame %@",NSStringFromCGRect(backgroundImageView.frame));
    [backgroundImageView setImage:[UIImage imageNamed:@"BackgroundLogin.png"]];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    [backgroundImageView release];

    
    
    UIImageView  *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(319, 343, 400, 62)];
    [tempView setImage:[UIImage imageNamed:@"AccountBackground.png"]];
    [self.view addSubview:tempView];
    [tempView release];tempView = nil;
    
    tempView = [[UIImageView alloc] initWithFrame:CGRectMake(319, 423, 400, 62)];
    [tempView setImage:[UIImage imageNamed:@"PasswordBackground.png"]];
    [self.view addSubview:tempView];
    [tempView release];tempView = nil;
    
    
    
    UITextField *_userNameField = [[UITextField alloc] initWithFrame:CGRectMake(430, 350, 280, 55)];
    _userNameField.delegate = self;
    [_userNameField setFont:[UIFont systemFontOfSize:35]];
    _userNameField.returnKeyType = UIReturnKeyNext;
    [_userNameField setBackgroundColor:[UIColor clearColor]];
    _userNameField.borderStyle = UITextBorderStyleNone;
    _userNameField.placeholder = @"user name";
    self.userNameField = _userNameField;
    [_userNameField release];
    
    UITextField *_passwordField = [[UITextField alloc] initWithFrame:CGRectMake(430, 430, 280, 55)];
    [_passwordField setDelegate:self];
    [_passwordField setFont:[UIFont systemFontOfSize:35]];
    [_passwordField setBackgroundColor:[UIColor clearColor]];
    _passwordField.returnKeyType = UIReturnKeyDone;
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.secureTextEntry = YES;
    _passwordField.placeholder = @"password";
    self.userPasswordField = _passwordField;
    [_passwordField release];
    
    UIButton  *_loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setFrame:CGRectMake(398, 501, 244, 60)];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"ButtonLoginBackground.png"] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton = _loginButton;
    
    //    [self.view s]
    
    self.loginButton.enabled = [self enableLoginButton];
    
    [self.view addSubview:self.userNameField];
    [self.view addSubview:self.userPasswordField];
    [self.view addSubview:self.loginButton];
    
//    [networkDataMemberHandle GetBatchTraceInfo:@"C2103815"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//     self.view.autoresizingMask
    
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [self.view setFrame:CGRectMake(0, 0, 1024, 748)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [userNameField_ becomeFirstResponder];
    
//    dispatch_queue_t testQueue = dispatch_queue_create("test.queue", NULL);
//    dispatch_async(testQueue, ^{
//        NSString *resutl = [networkDataMemberHandle SaveLabRecipeInfo:@"LB2012-2809" Color_Code:@"50RDE0081" Weight:@"75.00" User_ID:@"sunyan" Recipe_NO:@"" NA2CO3:@"20,00000" NA2SO4:@"90,00000" Keep_Temperature_Time:@"90" Group_ID:@"99" ChemicalIDStr:@"205,195,187" UsageStr:@"1.5,3,0.7" OldUsageStr:@"1.5,3,0.7"];
//        
//        NSLog(@"测试 output    %@",resutl);
//        dispatch_async(dispatch_get_main_queue(), ^{
//   
//            NSLog(@"测试 output  main Thread   %@",resutl);
//        });
//    });
//    
//    dispatch_release(testQueue);
    
//    for (int i = 0; i<4; i++) {
//        
//    
//    NSString *resutl = [networkDataMemberHandle SaveLabRecipeInfo:@"LB2012-2809" Color_Code:@"50RDE0081" Weight:@"75.00" User_ID:@"sunyan" Recipe_NO:@"" NA2CO3:@"20,00000" NA2SO4:@"90,00000" Keep_Temperature_Time:@"90" Group_ID:@"99" ChemicalIDStr:@"205,195,187" UsageStr:@"1.5,3,0.7" OldUsageStr:@"1.5,3,0.7"];
//    
//    NSLog(@"测试 output    %@",resutl);
//    }
//    
 
    
//SaveLabRecipeInfo:@"LB2012-2809" 
//Color_Code:@"50RDE0081"
//Weight:@"75.00"
//User_ID:@"sunyan" 
//Recipe_NO:@""
//NA2CO3:@"20,00000"
//NA2SO4:@"90,00000" 
//Keep_Temperature_Time:@"90" 
//Group_ID:@"99"
//ChemicalIDStr:@"205,195,187" 
//UsageStr:@"1.5,3,0.7" 
//OldUsageStr:@"1.5,3,0.7"
    

}


- (void)updateViewFrame:(CGFloat )_height
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
//    NSLog(@"fjfjfjfjfjfjfjfjfj %@",NSStringFromCGRect(self.view.frame));
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,_height, self.view.frame.size.width, self.view.frame.size.height)];
//     NSLog(@"fjfjfjf2222222j %@",NSStringFromCGRect(self.view.frame));
    [UIView commitAnimations];
}

- (BOOL)enableLoginButton
{
    BOOL result = NO;
    if (self.userNameField.text != nil && self.userNameField.text.length
        && self.userPasswordField.text != nil && self.userPasswordField.text.length)
    {
        result = YES;
    }
    return result;
}

#pragma ----
#pragma notification

- (void)textFieldChanged:(NSNotification *)note
{
    self.loginButton.enabled = [self enableLoginButton];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [self updateViewFrame:0];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    CGFloat height = 0.0f;  
    
    NSDictionary *info = [note userInfo];
//    NSLog(@"view frame %@",NSStringFromCGRect(self.view.frame));
//    no matter what the orientation is,it always return keyboard's portrait frame
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;  
//    CGRect rect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    CGFloat distanceToMove = kbSize.height - height;  
    height = kbSize.height;
    
    height = height-150;
    height = (-1)*height;

    [self updateViewFrame:height];
}

- (void)loginButton:(UIButton *)_sender
{
//    [self presentBackApplication];
//    userType = 2;
    [userNameField_ resignFirstResponder];
    [userPasswordField_ resignFirstResponder];
    [self processFieldEntries];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == userNameField_) {
		[userPasswordField_ becomeFirstResponder];
	}
	if (textField == userPasswordField_) {
		[userPasswordField_ resignFirstResponder];
		[self processFieldEntries];
	}
    
	return YES;
}

- (void)processFieldEntries 
{
    // Get the username text, store it in the app delegate for now
    
    self.userPassword = nil;
    self.userName = nil;
    
	self.userName = userNameField_.text;
	self.userPassword = userPasswordField_.text;
    
//    NSLog(@"userName %@",self.userName);
//    NSLog(@"pass word %@",self.userPassword);
    
	BOOL textError = NO;
    
	// Messaging nil will return 0, so these checks implicitly check for nil text.
	if (userName_.length == 0 || userPassword_.length == 0) {
		textError = YES;
        
		// Set up the keyboard for the first field missing input:
		if (userName_.length == 0) {
			[userNameField_ becomeFirstResponder];
		}
		else if (userPassword_.length == 0) {
			[userPasswordField_ becomeFirstResponder];
		}
	}
//	if (!([userName_ isEqualToString:@"1"] || [userName_ isEqualToString:@"2"]))
//	{
//		textError = YES;
//	}

    
    
    
	if (textError) 
    {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please input password or user name!", nil) message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
		[alertView show];
        [alertView release];
		return;
	}
    
//    [self presentBackApplication];
    self.loginButton.enabled = NO;
    [self userLoginWith:self.userName passWord:self.userPassword];
}

- (void)getLoginUserTypeWiht:(NSString *)_name
{
    if ([_name isEqualToString:@"LABDIP"])
    {
        userType = 2;
        [self presentBackApplication];
        return;
    }
    else if([_name isEqualToString:@"BULK"])
    {
        userType = 1;
        [self presentBackApplication];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或者密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert show];
    [alert release];
    self.loginButton.enabled = YES;
    
}

- (void)userLoginWith:(NSString *)_userName passWord:(NSString *)_password
{
//    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [loadingView startAnimating];
//    loadingView.center = CGPointMake(512, 388);
//    [self.view addSubview:loadingView];
//    [loadingView release];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t logineQueue = dispatch_queue_create("YDUserLoginQueue", NULL);
    dispatch_async(logineQueue,^{
       NSString *result = [networkDataMemberHandle LoginIn:_userName password:_password];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getLoginUserTypeWiht:result];
//            [loadingView removeFromSuperview];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
    });
//    [loadingView removeFromSuperview];
//    [loadingView release];loadingView = nil;
    dispatch_release(logineQueue);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    NSLog(@"the frame autor %@",NSStringFromCGRect(self.view.frame));
//    [self.view setFrame:CGRectMake(0, 0, 1024, 748)];
	return interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
//    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [userNameField_ release];
    [userPasswordField_ release];
    
    [userPassword_ release];
    [userName_ release];
    [super dealloc];
}
@end
