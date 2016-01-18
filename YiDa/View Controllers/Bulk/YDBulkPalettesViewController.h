//
//  YDBulkPalettesViewController.h
//  YiDa
//
//  Created by Ni on 12-11-19.
//  Copyright 2012 meson.com. All rights reserved.
//

 /*
  Created by lizhang Dong on 12-11-19
  说明:Bulk用户组的调方操作界面
  update:
 */

#import <UIKit/UIKit.h>
#import "YDBulkPalettesView.h"
#import "YDPalettesGroupView.h"
#import "YDPalettesRecipeView.h"


@interface YDBulkPalettesViewController : UIViewController <YDBulkPalettesViewDelegate,YDPalettesRecipeViewDelegate>
{
    UIImageView *navigationBarImageView_;
    UIImageView *viewTypeImage_;
    UIImageView *userImageView_;
    UIButton    *outputButton_;
    UIButton    *cancelButton_;
    UIButton    *logoutButton_;
    UIButton    *backButton_;
    
	UIScrollView  *recipeScrollView_;
    
    
    YDBulkPalettesView *batchInfoView_;
	YDPalettesGroupView *palettesGroupView_;
    
    
    
    
    NSInteger  recipeCount;
    
    NSString   *scanedCode_;
//    化学燃料id串
    NSString  *chemicalIds_;
//    组合id
    NSString  *groupId_;
//    配方的浴比
    NSString  *ratio_;
    
    NSString  *firstDye_;
//    爱丽色缸号
    NSString  *xriteNO_;
    
    
    NSInteger recipeSelectedCount;
    NSInteger recipeUnSelectCount;
    
    
    NSInteger successCount;
    NSInteger totalCount;

    NSMutableArray *newSelectRecipesList;
    NSMutableArray *newUnSelectRecipesList;
    
    dispatch_queue_t networkProcessQueue;
    
    
// output时需要填的参数，，这些数值都可以在一个配方中获取到
//Repair
//xriteNO
//FirstDyeCotton
//Batch_NO
//User_ID
//Recipe_NO
//NA2CO3
//NA2SO4
//Keep_Temperature_Time
//Group_ID
// ChemicalIDStr
//UsageStr
//OldUsageStr;
    
    


}

@property (nonatomic ,retain) IBOutlet  UIImageView *navigationBarImageView;
@property (nonatomic ,retain) IBOutlet  UIImageView *viewTypeImage;
@property (nonatomic ,retain) IBOutlet  UIImageView *userImageView;
@property (nonatomic ,retain) IBOutlet  UIButton    *outputButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *cancelButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *logoutButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *backButton;

@property (nonatomic ,retain) UIScrollView *recipeScrollView;
@property (nonatomic ,retain)   YDBulkPalettesView *batchInfoView;
@property (nonatomic ,retain)  YDPalettesGroupView *palettesGroupView;

@property (nonatomic ,copy) NSString *scanedCode;

@property (nonatomic ,copy ) NSString *chemicalIds;
@property (nonatomic ,copy) NSString *groupId;
@property (nonatomic ,copy) NSString  *ratio;
@property (nonatomic ,copy) NSString *firstDye;
@property (nonatomic ,copy)  NSString  *xriteNO;

- (IBAction)backButtonPress:(id)_sender;

- (IBAction)logoutButtonPress:(id)_sender;
- (IBAction)cancelButtonPress:(id)_sender;
- (IBAction)outputButtonPress:(id)_sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode;

@end
