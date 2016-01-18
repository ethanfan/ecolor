//
//  YDLabColorViewController.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


 /*
  Created by lizhang.dong on 12－11－10
  说明：实现lab的选料界面
 */

#import <UIKit/UIKit.h>
#import "YDColorNumberSelectView.h"
#import "YDColorStepView.h"
#import "DataMember.h"
#import "YDColorGroupView.h"

@interface YDLabColorViewController : UIViewController<YDColorNumberSelectViewDelegate,YDStepSelectViewDelegate,YDColorGroupViewViewDelegate>
{
    UIImageView *navigationBarImageView_;
    UIImageView *viewTypeImage_;
    UIImageView *userImageView_;
    UIButton    *outputButton_;
    UIButton    *cancelButton_;
    UIButton    *logoutButton_;
    UIButton    *backButton_;
    
    UIScrollView  *groupScrollView_;
	
	YDColorNumberSelectView *colorView_; 
    YDColorStepView *stepView_;	
    
    NSMutableArray    *groupViewsArray_;
    NSInteger        groupCounts;
    
    NSString   *scanedCode_;
    
//    用于查询最优组合信息的五个字段
    NSString  *type_;    //分类
    NSString  *simpleColor_;     //色系
    NSString  *colorDeep_;       //颜色深浅值
    NSString  *customer_;        //客户
    NSString  *finishList_;      //finishlist
    
//    用于output时的两个字段，接口处需要使用
    NSString   *weight_;
    NSString   *colorCode_;
    NSString   *stepString_;
    
//    这个是从网络获取过来的最优组合，是不能修改或删除的
    NSArray   *oldGroupList_;
    
//    新建的新的并且被选中的组合，用于output
    NSMutableArray *newSelectedGroups;
    
    dispatch_queue_t networkProcessQueue;
    
    
//  记录output结果
    NSInteger totalCount;
    NSInteger successCount;


}
@property (nonatomic ,retain) IBOutlet  UIImageView *navigationBarImageView;
@property (nonatomic ,retain) IBOutlet  UIImageView *viewTypeImage;
@property (nonatomic ,retain) IBOutlet  UIImageView *userImageView;
@property (nonatomic ,retain) IBOutlet  UIButton    *outputButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *cancelButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *logoutButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *backButton;

@property (nonatomic ,retain) UIScrollView  *groupScrollView;  
@property (nonatomic ,retain) YDColorNumberSelectView *colorView;
@property (nonatomic ,retain) YDColorStepView *stepView;

@property (nonatomic ,retain) NSMutableArray  *groupViewsArray;

@property (nonatomic ,copy) NSString *scanedCode;

@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *simpleColor;
@property (nonatomic ,copy) NSString *colorDeep;
@property (nonatomic ,copy) NSString *customer;
@property (nonatomic ,copy) NSString *finishList;

@property (nonatomic ,copy) NSString *weight;
@property (nonatomic ,copy) NSString *colorCode;
@property (nonatomic ,copy) NSString *stepString;

-(IBAction)backButtonPress:(id)_sender;

- (IBAction)logoutButtonPress:(id)_sender;
- (IBAction)cancelButtonPress:(id)_sender;
- (IBAction)outputButtonPress:(id)_sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode;

@end
