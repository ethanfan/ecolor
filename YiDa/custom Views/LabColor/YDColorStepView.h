//
//  YDColorStepView.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

 /*
  Created by lizhang Dong on 12-11-13
  说明：lab用户组中五个步骤选择的界面，由于这里面的数据获取都不需要参数，只要进入这个界面就直接获取就行了。
  update：
  
 */


typedef enum 
{
    YDLabColorSelectItemNone= 0,
    YDLabColorStepItem,
    YDLabColorCostItem,
    YDLabColorColorItem,
    YDLabColorTypeItem,
    YDLabColorColorDeepItem,
} YDLabColorSelectItem;

#import <UIKit/UIKit.h>
#import "YDPopoverViewController.h"
#import "DataMember.h"

@class YDColorStepView;

@protocol YDStepSelectViewDelegate <NSObject>

@required
- (void)stepDidSelect:(NSString *)_step 
             withCost:(NSString *)_cost 
            withColor:(NSString *)_color 
             withType:(NSString *)_type 
        withColorDeep:(NSString *)_colorDeep;

@end

@interface YDColorStepView : UIView<UIPopoverControllerDelegate,YDPopoverViewDelegate>
{
    UIButton *stepButton_;   //步骤
    UIButton *costButton_;   //成本
    UIButton *colorButton_;//色系
    UIButton *typeButton_;//分类
    UIButton *colorDeepButton_;   //颜色深浅
    
    UILabel *stepLabel_;
    UILabel *costLabel_;
    UILabel *colorLabel_;
    UILabel *typeLabel_;
    UILabel *colorDeepLabel_;
    UIPopoverController *popover;
    
    
    NSString  *currentStep_;
    NSString  *currentCost_;
    NSString  *currentColor_;
    NSString  *currentType_;
    NSString  *currentColorDeep_;
    
    id <YDStepSelectViewDelegate> delegate;
    
//    完成状态：0表示还没有完全获取到数据;1、表示已经获取完数据
    NSInteger  finishState_;
    
    dispatch_queue_t stepsQueue;
@private
    NSInteger currentSelectedBUtton;
    NSMutableArray *stepsList;              //步骤列表
    NSMutableArray *costsList;             //成本列表
    NSMutableArray *colorsList;            //色系列表
    NSMutableArray *typesList;             //分类列表
    NSMutableArray *colorDeepsList;         //颜色深浅列表
}

@property (nonatomic ,retain)  UIButton *stepButton;
@property (nonatomic ,retain)  UIButton *costButton;
@property (nonatomic ,retain)  UIButton *colorButton;//色系
@property (nonatomic ,retain)  UIButton *typeButton;//分类
@property (nonatomic ,retain)  UIButton *colorDeepButton;

@property (nonatomic ,retain)  UILabel *stepLabel;
@property (nonatomic ,retain)  UILabel *costLabel;
@property (nonatomic ,retain)  UILabel *colorLabel;
@property (nonatomic ,retain)  UILabel *typeLabel;
@property (nonatomic ,retain)  UILabel *colorDeepLabel;

@property (nonatomic ,copy)  NSString  *currentStep;
@property (nonatomic ,copy)  NSString *currentCost;
@property (nonatomic ,copy)  NSString  *currentColor;
@property (nonatomic ,copy)  NSString  *currentType;
@property (nonatomic ,copy)  NSString  *currentColorDeep;

@property (nonatomic ,assign) NSInteger finishState;

@property (nonatomic ,assign) id<YDStepSelectViewDelegate> delegate;

//根据来样单信息中的色号去匹配当前色系中应该显示的值
- (NSString *)predicateColorType:(NSString *)_colorCode;
- (void)setFirstTitle;

//重新设置色系
- (void)resetSimpleColor:(NSString *)_simpleColor;
@end
