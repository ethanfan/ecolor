//
//  YDMainMenuViewController.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


 /*
  Created by author lizhang.dong on 12－11－10
  说明 首页的主菜单界面，分为tab和bulk
 */



#import <UIKit/UIKit.h>
#import "YDCustomNavigationBar.h"
#import "YDAppDelegate.h"

//main menu type: bulk and tab 
typedef  enum {
    MainMenuNone = 0,
    MainMenuBulk,
    MainMenuTab,
} MainMenuMode;

@interface YDMainMenuViewController : UIViewController
{
    UIButton *palettsButton_;
    UIButton *tabButton_;
    UIButton *addictionButton_;
    UIButton *searchButton_;
    
    UIButton *logoutButton_;
    
// @private
    UIImageView  *backgroundImageView_;
    UIImageView  *navigationBarBackgroundView_;
}

@property (nonatomic ,retain) UIButton *palettsButton;
@property (nonatomic ,retain) UIButton *tabButton;
@property (nonatomic ,retain) UIButton *addictionButton;
@property (nonatomic ,retain) UIButton *searchButton;
@property (nonatomic ,retain) UIButton *logoutButton;

@property (nonatomic ,retain) IBOutlet UIImageView  *backgroundImageView;
@property (nonatomic ,retain) UIImageView           *navigationBarBackgroundView;

@property (nonatomic,assign) MainMenuMode mainMenuMode;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
             userTpye:(NSInteger)_userType;

- (YDAppDelegate *)YDAppDelegate;

@end
