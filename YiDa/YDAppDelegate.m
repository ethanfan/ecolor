//
//  YDAppDelegate.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDAppDelegate.h"
#import "YDUserLoginViewController.h"
#import "YDMainMenuViewController.h"
#import "DataKit.h"
#import "MBProgressHUD.h"

@interface YDAppDelegate()
{
    NSString *currentUserName_;
    NSString *userPassword_;
}
void uncaughtExceptionHandler(NSException *exception) ;

- (void)presentLoginViewController:(BOOL)_animated;

- (void)logOutFailWith:(NSString *)_messages;
- (void)logOutSuccess;

@end



@implementation YDAppDelegate

@synthesize window = _window;

@synthesize viewController =_viewController;

@synthesize currentUserType = _currentUserType;


@synthesize currentUserName = currentUserName_;
@synthesize userPassword = userPassword_;

- (void)dealloc
{
    self.currentUserName = nil;
    self.userPassword = nil;
    [_viewController release];
    [_window release];
    [super dealloc];
}

- (NSInteger)currentUserType
{
    return _currentUserType;
}
- (YDAppDelegate *)YDAppDelegate
{
    return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)presentApplicationView:(NSInteger)_userType
{
//    UIViewController  *tempViewController = [[UIViewController alloc] init];
    
    YDMainMenuViewController *tempViewController = [[YDMainMenuViewController alloc] initWithNibName:@"YDMainMenuViewController" bundle:nil userTpye:_userType];
    _currentUserType = _userType;
    
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tempViewController];
	navController.navigationBarHidden = YES;

    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBackground.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.viewController = navController;
    self.window.rootViewController = self.viewController;
    [tempViewController release];
    [navController release];
}

//登录成功
- (void)presentApplicationView:(NSInteger)_userType withName:(NSString *)_userName withPassword:(NSString *)_password
{
    self.currentUserName = _userName;
    self.userPassword = _password;
    
    YDMainMenuViewController *tempViewController = [[YDMainMenuViewController alloc] initWithNibName:@"YDMainMenuViewController" bundle:nil userTpye:_userType];
    _currentUserType = _userType;
    
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tempViewController];
	navController.navigationBarHidden = YES;
    
    
    //    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBackground.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.viewController = navController;
    self.window.rootViewController = self.viewController;
    
    [tempViewController release];
    [navController release];
}

- (void)presentLoginViewController:(BOOL)_animated
{
    // Go to the welcome screen and have them log in.
	YDUserLoginViewController *welcomeViewController = [[YDUserLoginViewController alloc] initWithNibName:@"YDUserLoginViewController" bundle:nil];
    
//    YDLoginViewController *welcomeViewController = [[YDLoginViewController alloc] initWithNibName:@"YDLoginViewController" bundle:nil];
//	welcomeViewController.title = @"Welcome to AnyWall";
	
//	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
//	navController.navigationBarHidden = YES;
    
	self.viewController = welcomeViewController;
	self.window.rootViewController = self.viewController;
	[welcomeViewController release];
//    [self.window addSubview:self.viewController.view];
}
- (void)presentLoginViewController
{
    [self presentLoginViewController:YES];
}

- (void)logoutWithResultBlock:(void (^)(NSString *result))block;
{
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    dispatch_queue_t logineQueue = dispatch_queue_create("YDUserLogoutQueue", NULL);
    dispatch_async(logineQueue,^{
        NSString *result = [networkDataMemberHandle LoginOut:userPassword_];
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"logout result %@  retainCount %d",result,[result retainCount]);
            block(result);
        });
        
    });
    dispatch_release(logineQueue);
}

- (void)didChooseLogout
{
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    dispatch_queue_t logineQueue = dispatch_queue_create("YDUserLogoutQueue", NULL);
    dispatch_async(logineQueue,^{
        NSString *result = [networkDataMemberHandle LoginOut:userPassword_];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.window animated:YES];
            if ([result isEqualToString:@"OK"]) {
                [self logOutSuccess];
            }
            else{
                [self logOutFailWith:result];
            }
        });
        
    });
    dispatch_release(logineQueue);
}

- (void)logOut
{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定注销本次登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
    
    
   
}

- (void)logOutFailWith:(NSString *)_messages
{
    NSString *message = _messages;
    if (![message length]) {
        message = @"网络连接错误，登出失败";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
- (void)logOutSuccess
{
    self.userPassword = nil;
    self.currentUserName = nil;
    [self presentLoginViewController];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    if (buttonIndex == 1)
    {
//        NSLog(@" tag  %d  index %d",tag,buttonIndex);
        [self didChooseLogout];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"ServerIP"]) {
        NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"http://192.168.7.71/wmis/wcfcolor/"
                                                                forKey:@"ServerIP"];
//        NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"http://www.esquel.cn/wmis/WcfColor/Color.svc"
//                                                                forKey:@"ServerIP"];
        
        [defaults registerDefaults:appDefaults];
        [defaults synchronize];
    }
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];

    [self presentLoginViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma ---
#pragma error handler
void uncaughtExceptionHandler(NSException *exception) {
//    NSLog(@"CRASH: %@", exception);
//    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

@end
