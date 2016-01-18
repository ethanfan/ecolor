//
//  YDLabTabViewController.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

 /*
  Created by lizhang Dong on 12-11-14
  说明：lab用户组中的标记界面
 */

#import <UIKit/UIKit.h>
#import "YDColorNumberSelectView.h"
#import "YDColorLevelName.h"

@interface YDLabTabViewController : UIViewController<YDColorNumberSelectViewDelegate,YDPalettesRecipeViewDelegate>
{
    UIImageView *navigationBarImageView_;
    UIImageView *viewTypeImage_;
    UIImageView *userImageView_;
    UIButton    *outputButton_;
    UIButton    *cancelButton_;
    UIButton    *logoutButton_;
    UIButton    *backButton_;
    
   UIScrollView  *groupScrollView_;
//    色级这一个scrollView
    UIScrollView *colorNameScrollView_;
//    色级这一栏中的配方，全部存放在这里
    NSMutableArray  *colorRecipeSelectedList;
    
//    来样信息界面
    YDColorNumberSelectView *colorView_;
	
//    色级的名字
	NSMutableArray	 *namesArray;
    
//   组合的数量
    NSInteger   groupCount;
//    色级的个数
    NSInteger   colorNameCount;
//    被标记的配方的数目，这个数目不可能大于色级的个数
    NSInteger  tabRecipeCount;
    
//    扫描得来得lbnos
    NSString  *scanedCode_;
    
    dispatch_queue_t networkProcessQueue;
}

@property (nonatomic ,retain) IBOutlet  UIImageView *navigationBarImageView;
@property (nonatomic ,retain) IBOutlet  UIImageView *viewTypeImage;
@property (nonatomic ,retain) IBOutlet  UIImageView *userImageView;
@property (nonatomic ,retain) IBOutlet  UIButton    *outputButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *cancelButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *logoutButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *backButton;

@property (nonatomic ,retain) UIScrollView  *groupScrollView;
@property (nonatomic ,retain) UIScrollView  *colorNameScrollView;

@property (nonatomic ,retain)  YDColorNumberSelectView *colorView;

@property (nonatomic ,copy) NSString  *scanedCode;

- (IBAction)backButtonPress:(id)_sender;
- (IBAction)logoutButtonPress:(id)_sender;
- (IBAction)cancelButtonPress:(id)_sender;
- (IBAction)outputButtonPress:(id)_sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode;
@end
