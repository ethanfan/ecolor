//
//  YDColorNumberSelectView.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

 /*
  Created by lizhang Dong on 12－11－10
  说明：labz用户组中的颜色／kdno选择界面
 */

#import <UIKit/UIKit.h>
#import "YDPopoverViewController.h"
#import "DataMember.h"
#import "Constants.h"
#import "DataKit.h"


typedef enum 
{
	YDColorViewStateNone = 0,
	YDColorViewStateKDNO,    //已选开单号，但未选颜色
	YDColorViewStateColor,   //已选开单号，和颜色
} YDColorViewState;

@class YDColorNumberSelectView;


@protocol YDColorNumberSelectViewDelegate<NSObject>

@optional

- (void)colorNumberSelectDidFinish;
//如果再次选择开单号就会调用这个delegate，这个只用于更新界面
- (void)reloadKDNOWith:(BOOL)_yesOrNo;
//在网络借口返回数据后才回去调用这个delegate
// 把获取到的来样信息中的client和finish list 返回去
//_client 和finishlist是实在lab选料界面中用到，用于去获取最优组合信息
//_weight和_colorcode传回去是为了在后面output的时候接口需要填的参数
- (void)didFinishSelectInfo:(YDColorNumberSelectView *)_selectView 
                     client:(NSString *)_client 
                 finishList:(NSString *)_finishList 
                     weight:(NSString *)_weight 
                  colorCode:(NSString *)_colorCode;

@end

@interface YDColorNumberSelectView : UIView<UIPopoverControllerDelegate,YDPopoverViewDelegate>
{
    UIImageView  *LBNOimageView_;
    UIImageView  *colorImageView_;
    UIImageView  *loWeightImageView_;//经向重量
    UIImageView  *laWeightImageView_;//纬向重量
    UIImageView  *dateImageView_;
    UIImageView  *clearImageView_;//整理
    UIImageView  *clientImageView_;
    
    UILabel  *LBNOlabel_;
    UILabel  *colorLabel_;
    UILabel  *loWeightLabel_;
    UILabel  *laWeightLabel_;
    UILabel  *dateLabel_;
    UILabel  *clearLabel_;
    UILabel  *clientLabel_;
    
    UILabel  *LBNOContentlabel_;
    UILabel  *colorContentLabel_;
    UILabel  *loWeightContentLabel_;
    UILabel  *laWeightContentLabel_;
    UILabel  *dateContentLabel_;
    UILabel  *clearContentLabel_;
    UILabel  *clientContentLabel_;
    
    UIButton *KDNObutton_;
    UIButton *colorButton_;
    
    
    UIPopoverController *popover;
	YDPopoverTargetTypeOption popoverTargetType_;
	
	YDColorViewState colorViewState_;
	id<YDColorNumberSelectViewDelegate> delegate;
    
    
    DataMember *networkDataHanlder;
    
    NSMutableArray *KDNOLists;    //开单号列表
    NSMutableArray *colorsLists;   //颜色值列表
    
    //当前来样信息中的客户和finishilist 用于查询最优来样组合
    NSString  *LBClient_;        
    NSString  *LBFinishList_;
    NSString  *currentColorCode_;     //当前选择的颜色块
    NSString  *currentWeight_;        //当前来样信息中的重量
    
    dispatch_queue_t kdnoQueue;
    
@private 
    BOOL reselectKDNO;
    NSString *LBNO_;           //拍码的来的
    NSString  *KDNO_;          //开单号
   
    LBInfo   *LBInformationDetail_;    //当前查询到的来样单信息
    
}

@property (nonatomic ,retain) UIImageView  *LBNOimageView;
@property (nonatomic ,retain) UIImageView  *colorImageView;
@property (nonatomic ,retain) UIImageView  *loWeightImageView;//经向重量
@property (nonatomic ,retain) UIImageView  *laWeightImageView;//纬向重量
@property (nonatomic ,retain) UIImageView  *dateImageView;
@property (nonatomic ,retain) UIImageView  *clearImageView;//整理
@property (nonatomic ,retain) UIImageView  *clientImageView;

@property (nonatomic ,retain) UILabel  *LBNOlabel;
@property (nonatomic ,retain) UILabel  *colorLabel;
@property (nonatomic ,retain) UILabel  *loWeightLabel;
@property (nonatomic ,retain) UILabel  *laWeightLabel;
@property (nonatomic ,retain) UILabel  *dateLabel;
@property (nonatomic ,retain) UILabel  *clearLabel;
@property (nonatomic ,retain) UILabel  *clientLabel;

@property (nonatomic ,retain) UIButton *KDNObutton;
@property (nonatomic ,retain) UIButton *colorButton;


@property (nonatomic ,retain) UILabel  *LBNOContentlabel;
@property (nonatomic ,retain) UILabel  *colorContentLabel;
@property (nonatomic ,retain) UILabel  *loWeightContentLabel;
@property (nonatomic ,retain) UILabel  *laWeightContentLabel;
@property (nonatomic ,retain) UILabel  *dateContentLabel;
@property (nonatomic ,retain) UILabel  *clearContentLabel;
@property (nonatomic ,retain) UILabel  *clientContentLabel;

@property (nonatomic ,readonly) YDPopoverTargetTypeOption popoverTargetType;

@property (nonatomic ,readonly) YDColorViewState colorViewState;

@property (nonatomic ,assign) id<YDColorNumberSelectViewDelegate> delegate;

@property (nonatomic ,copy) NSString *LBClient;
@property (nonatomic ,copy) NSString *LBFinishList;

@property (nonatomic ,copy) NSString *currentWeight;

//private
@property (nonatomic ,copy) NSString *LBNO;
@property (nonatomic ,copy) NSString *KDNO;
@property (nonatomic ,copy) NSString *currentColorCode;

@property (nonatomic ,retain) LBInfo *LBInformationDetail;


- (id)initWithFrame:(CGRect)frame popoverTargetType:(YDPopoverTargetTypeOption )_targetType;
- (id)initWithFrame:(CGRect)frame popoverTargetType:(YDPopoverTargetTypeOption )_targetType withLBNO:(NSString *)_LBNO;

//返回最初始的状态，开单号没有选择，颜色块没有选择
//但是获取的开单号列表依然存在，因为开单号只需根据lbno获取，而lbno不变
- (void)reloadDatas;



@end
