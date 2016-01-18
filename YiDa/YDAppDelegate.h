//
//  YDAppDelegate.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataMember.h"

@interface YDAppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) UIViewController *viewController;

@property (nonatomic ,assign) NSInteger currentUserType;

@property (nonatomic ,copy) NSString *currentUserName;
@property (nonatomic ,copy) NSString *userPassword;


//back from the login when user login
- (void)presentApplicationView:(NSInteger)_userType;
- (void)presentApplicationView:(NSInteger)_userType withName:(NSString *)_userName withPassword:(NSString *)_password;
- (void)presentLoginViewController;
- (YDAppDelegate *)YDAppDelegate;
- (void)logoutWithResultBlock:(void (^)(NSString *result))block;

- (void)logOut;

@end
