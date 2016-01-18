//
//  YDUserLoginViewController.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


 /*
  Created by lizhang.dong
  @说明 ：实现登录界面功能
 */

//测试帐号  lab用户组： 帐号：sunyan  密码：002
//        bulk用户组：帐号：jiajm   密码：002


#import <UIKit/UIKit.h>
#import "DataMember.h"

@interface YDUserLoginViewController : UIViewController<UITextFieldDelegate>
{
    UITextField  *userNameField_;
    UITextField  *userPasswordField_;
    UIButton     *loginButton_;
    
    DataMember  *networkDataMemberHandle;
@private
    NSString  *userName_;
    NSString  *userPassword_;
    
    NSInteger userType;
}


@property (nonatomic,retain) UITextField  *userNameField;
@property (nonatomic,retain) UITextField  *userPasswordField;
@property (nonatomic,retain) UIButton     *loginButton;

@property (nonatomic,copy) NSString  *userName;
@property (nonatomic,copy) NSString  *userPassword;


@end
