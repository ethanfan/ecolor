//
//  YDBulkQueryNavigationViewController.h
//  YiDa
//
//  Created by Ni on 12-11-15.
//  Copyright 2012 meson.com. All rights reserved.
//

 /*
  Created by lizhang Dong on 12-11-15
  说明：bulk用户组中配方、品种和进度的三个子查询菜单界面
 */

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface YDBulkQueryNavigationViewController : UIViewController {

    UIImageView *navigationBarImageView_;
    UIImageView *viewTypeImage_;
    UIImageView *userImageView_;
    UIButton    *outputButton_;
    UIButton    *cancelButton_;
    UIButton    *logoutButton_;
    UIButton    *backButton_;
    
	UIButton *recipeButton_;
	UIButton *varietyButton_;
	UIButton *progressButton_;
}

@property (nonatomic ,retain) IBOutlet  UIImageView *navigationBarImageView;
@property (nonatomic ,retain) IBOutlet  UIImageView *viewTypeImage;
@property (nonatomic ,retain) IBOutlet  UIImageView *userImageView;
@property (nonatomic ,retain) IBOutlet  UIButton    *outputButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *cancelButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *logoutButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *backButton;


@property (nonatomic ,retain) IBOutlet UIButton *recipeButton;
@property (nonatomic ,retain) IBOutlet UIButton *varietyButton;
@property (nonatomic ,retain) IBOutlet UIButton *progressButton;


- (IBAction)backButtonPress:(UIButton *)_sender;
- (IBAction)logoutButtonPress:(id)_sender;
- (IBAction)cancelButtonPress:(id)_sender;
- (IBAction)outputButtonPress:(id)_sender;

- (IBAction)queryOptionButtonPress:(UIButton *)_sender;

@end
