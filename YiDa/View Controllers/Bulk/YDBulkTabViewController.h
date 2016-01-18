//
//  YDBulkTabViewController.h
//  YiDa
//
//  Created by Ni on 12-11-19.
//  Copyright 2012 meson.com. All rights reserved.
//

 /*
  Created by lizhang Dong on 12-11-19
  说明：Bulk用户组中标记的操作界面
  update：
  
 */

#import <UIKit/UIKit.h>
#import "YDPostNotificationName.h"
#import "YDBulkPalettesView.h"
#import "YDPalettesGroupView.h"
#import "YDPalettesRecipeView.h"
#import "Constants.h"

@interface YDBulkTabViewController : UIViewController <YDBulkPalettesViewDelegate,YDPalettesRecipeViewDelegate>{

    UIImageView *navigationBarImageView_;
    UIImageView *viewTypeImage_;
    UIImageView *userImageView_;
    UIButton    *outputButton_;
    UIButton    *cancelButton_;
    UIButton    *logoutButton_;
    UIButton    *backButton_;
    
	UIScrollView  *groupScrollView_;
	//放选择后的配方，可以左右滚动
	UIScrollView  *selectedRecipeScrollView_;
    YDBulkPalettesView *batchInfoView_;
	
	NSInteger	 selectedRecipeCount;
    
    NSString    *scanedCode_;
    
    NSMutableArray *tabedRecipesList;
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
@property (nonatomic ,retain) IBOutlet  UIScrollView *selectedRecipeScrollView;
@property (nonatomic ,retain) YDBulkPalettesView *batchInfoView;

@property (nonatomic ,copy) NSString    *scanedCode;
 
- (IBAction)backButtonPress:(id)_sender;

- (IBAction)logoutButtonPress:(id)_sender;
- (IBAction)cancelButtonPress:(id)_sender;
- (IBAction)outputButtonPress:(id)_sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode;

@end
