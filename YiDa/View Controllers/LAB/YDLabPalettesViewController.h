//
//  YDLabPalettesViewController.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

 /*
 Created by lizhang Dong on 12-11-13
  说明：lab用户组的调方界面
 */

#import <UIKit/UIKit.h>
#import "YDColorNumberSelectView.h"
#import "YDPalettesGroupView.h"
#import "DataKit.h"
#import "DataMember.h"
#import "YDPalettesRecipeView.h"

@interface YDLabPalettesViewController : UIViewController<YDColorNumberSelectViewDelegate,YDPalettesRecipeViewDelegate>
{
    UIImageView *navigationBarImageView_;
    UIImageView *viewTypeImage_;
    UIImageView *userImageView_;
    UIButton    *outputButton_;
    UIButton    *cancelButton_;
    UIButton    *logoutButton_;
    UIButton    *backButton_;
    
    UIScrollView  *recipeScrollView_;
	YDColorNumberSelectView *colorView_; 
	YDPalettesGroupView *palettesGroupView_;
    
    NSInteger recipeCount;                 //由服务器返回的数据的数量
    NSInteger recipeSelectedCount;         //选择后的配方数量
    NSInteger recipeUnSelectCount;         //新建但未被选择的数量   在一般情况下，如果用户在新建后都没有去取消选择，这个数量就是0的
    
//    这个其实就是lbno
    NSString  *scandedCode_;
    
//    用于output的参数
    NSString *colorCode_;
    NSString *weight_;
//    output的时候需要填的参数有：
//LB_NO              
//Color_Code 
//Weight 
//User_ID 
//Recipe_NO 
//NA2CO3 
//NA2SO4 
//Keep_Temperature_Time 
//Group_ID 
//ChemicalIDStr 
//UsageStr 
//OldUsageStr;
    
//    新建的配方并且是已经选择的
    NSMutableArray  *newSelectedRecipesList;
    
//    新建但未被选择的配方
    NSMutableArray  *newUnSelectedRecipesList;
    
//    这个值只要在完成了一次查询后就会得到，可以在后面的计算助剂中用到
    NSString *chemicalIds_;
    NSString *groupId_;
    
    //  记录output结果,当两者相等的时候完全output成功,就去更新界面
    NSInteger totalCount;
    NSInteger successCount;
    
    dispatch_queue_t networkProcessQueue;

}
@property (nonatomic ,retain) IBOutlet  UIImageView *navigationBarImageView;
@property (nonatomic ,retain) IBOutlet  UIImageView *viewTypeImage;
@property (nonatomic ,retain) IBOutlet  UIImageView *userImageView;
@property (nonatomic ,retain) IBOutlet  UIButton    *outputButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *cancelButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *logoutButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *backButton;

@property (nonatomic ,retain) UIScrollView *recipeScrollView;
@property (nonatomic ,retain) YDColorNumberSelectView *colorView; 
@property (nonatomic ,retain) YDPalettesGroupView *palettesGroupView;

@property (nonatomic ,copy) NSString *scandedCode;

@property (nonatomic ,copy) NSString *colorCode;
@property (nonatomic ,copy) NSString *weight;

@property (nonatomic ,copy) NSString *chemicalIds;

@property (nonatomic ,copy) NSString *groupId;



- (IBAction)backButtonPress:(id)_sender;

- (IBAction)logoutButtonPress:(id)_sender;
- (IBAction)cancelButtonPress:(id)_sender;
- (IBAction)outputButtonPress:(id)_sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode;

@end
