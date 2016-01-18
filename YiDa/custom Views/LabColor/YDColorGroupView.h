//
//  YDColorGroupView.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

 /*
  Created by lizhang dong on 12－11－10
  说明：lab用户组中选料的组合的view
 */
#import <UIKit/UIKit.h>
#import "Constants.h"
#import "YDGroupModifyView.h"

@class YDColorGroupView;

@protocol YDColorGroupViewViewDelegate <NSObject>

@optional

//回调通知是否选中改组合
- (void)colorGroupDidSelect:(BOOL)_selected colorGroup:(YDColorGroupView *)_colorGroupView;

@end

@interface YDColorGroupView : UIView<YDGroupModifyViewDelegate>
{
    UILabel *titleLabel_;
    UILabel *redColorLabel_;
    UILabel *yellowColorLabel_;
    UILabel *blueColorLabel_;
    UILabel *moreColorLabe_;       //最多有四个label
    
    UIButton *selectedButton_;
    UIButton *deleteButton_;//就是取消选择
	
	UIButton *touchButton_;  //选中后弹出一个新的组合的按钮
    
    BOOL selected;
//    这个组合是否被修改过
    BOOL modify;
	
	YDGroupViewTypeOption groupViewType_;
    id<YDColorGroupViewViewDelegate> delegate;
//    根据数组的长度决定显示多少个字段（就是表示有多少个化学颜料值）
    NSArray  *datasList_;
//     如果是修改过的组合，等待output，就会有这个值，这个值是用户输入的。
//    格式为“0.10,1.10,900”用逗号隔开
    NSString  *usages_;
}

@property (nonatomic ,retain) UILabel *titelLabel;
@property (nonatomic ,retain) UILabel *redColorLabel;
@property (nonatomic ,retain) UILabel *yellowColorLabel;
@property (nonatomic ,retain) UILabel *blueColorLabel;
@property (nonatomic ,retain) UILabel *moreColorLabel;
@property (nonatomic ,retain) UIButton *selectedButton;
@property (nonatomic ,retain) UIButton *deleteButton;
@property (nonatomic ,getter = isSelected,setter = setselectedWith:) BOOL selected;
@property (nonatomic ,getter = isModify) BOOL modify;
@property (nonatomic ,retain) UIButton *touchButton;
@property (nonatomic ,assign) YDGroupViewTypeOption groupViewType;

@property (nonatomic ,assign) id<YDColorGroupViewViewDelegate>delegate;
@property (nonatomic ,retain) NSArray  *datasList;

@property (nonatomic ,copy) NSString *usages;

- (id)initWithFrame:(CGRect)frame title:(NSString *)_viewTitle;

- (id)initWithFrame:(CGRect)frame datas:(NSArray *)_datas;

- (void)setContentLabels:(NSInteger)_count;

- (void)setColorImages:(NSInteger)_count;

- (void)setGroupTitle:(NSString *)_groupId;

- (void)setSelectButton:(BOOL)_selected;

- (void)setUpDeepestBackgroup;


//拿取该组合中的化学材料的id串
- (NSString *)chemicalIds;
//拿取该组合中的组合id
- (NSString *)groupId;

@end
