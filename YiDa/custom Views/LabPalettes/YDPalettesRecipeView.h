//
//  YDPalettesRecipeView.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*
 Created by lizhang dong on 12－11－10
 说明：lab用户组中调方的配方的view
 
 */

typedef enum 
{
    YDPalettesRecipeTypeNone= 0,  //可以点击弹出来新建配方的情况 也就是空白的一个配方
    YDPalettesNewRecipeType,  //新建的配方，点击弹出界面  ，可以删除
    YDPalettesOldRecipeType,  //历史配方，点击弹出界面
    YDTabCandidateType,      //候选配方 这个是在tab的界面中出现，长按弹出，
	YDTabCandidateSelectedType, //候选配方被选中的状态， 依然存在候选配方里面，只不过背景颜色和状态改变了
    YDTabRecipeSelectedTyep,  //被选中的候选配方 在色级这一栏出现，长按弹出三个选项
    YDTabColorLevelType,   //色级 长按弹出g更改色级名称，这种状态的view跟    YDTabRecipeSelectedTyep 这种状态的view应该是可以转换的，被选中就是 YDTabRecipeSelectedTyep（现实配方值、组合名字，和配方名），未被选中就只显示色级名称
    YDTabColorLevelMoreType, //色级中增加的状态 点击弹出三个选项的
	YDTabCandidateLongPressType,  //在bulk用户中的标记界面长按会弹出界面，跟YDTabCandidateType 不同的是前者长按有相应，点击没有反映，后者相反
	YDBulkTabRecipeSelectedType,  //在bulk用户中的色级出现，表示已标记
}YDPalettesRecipeType;


#import <UIKit/UIKit.h>
#import "PopoverView.h"
#import "YDTabPopoverView.h"
#import "Constants.h"
#import "DataKit.h"
#import "YDColorPopoverView.h"
#import "YDColorLevelAddModifyView.h"
#import "YDColorLevelModifyView.h"

#import "YDColorLevelModifyView.h"

@class YDPalettesRecipeView;

@protocol YDPalettesRecipeViewDelegate <NSObject>

@optional
//配方选择或者取消选择
- (void)palettesRecipe:(YDPalettesRecipeView *)_recipeView didSelected:(BOOL)_selected;

//新建的配方删除
- (void)palettesRecipe:(YDPalettesRecipeView *)_recipeView didRemove:(BOOL)_removed;

//在bulk用户组中取消标记后的回调
- (void)tabRecipe:(YDPalettesRecipeView *)_recipeView didRemove:(BOOL)_removed;

- (void)recipeDidChangeColorLevelName:(NSString *)_colorName;

@end

@interface YDPalettesRecipeView : UIView<PopoverViewDelegate,YDTabPopoverViewDelegate,YDColorPopoverViewDelegate,YDColorLevelAddModifyViewDelegate>
{
    YDPalettesRecipeType recipeType_;
	YDUserType           userType_;
    
    UIButton *touchButton_;  //弹出新建配方界面或者修改历史配方界面
    
    
    UILabel     *recipeTitle_;//配方号
    UILabel     *yellowColorLabel_;
    UILabel     *redColorLabel_;
    UILabel     *blueColorLabel_;
    UILabel     *moreLabel_;
    
    UILabel     *colorLevelLabel_;
    UILabel     *groupNameLabel_;
    
    UIButton    *selectedButton_;
    UIButton    *deleteButton_;
	UIButton    *reModifyButton_;// 回修按钮
	
	BOOL        selected;          //是否被选中
	
	BOOL		remodified;      //是否是回修
	
	
	UIImageView	 *backgroundImageView_;
	
	
	
// data 
	NSString		*colorLevelNameString_;          //色级名称
	NSString		*recipeNameString_;          //配方名字
    NSString		*groupNameString_;        //组合名字
	NSString		*yellowString_;
	NSString		*redString_;
	NSString		*blueString_;
	
	
	NSMutableArray *colorLevelName;
    
    id<YDPalettesRecipeViewDelegate>delegate;
//    配方的内容
    Group_List *recipeVale_;
//    助剂的内容
    LAI_UIData *additives_;
    
//    在bulk用户中标记时回修或者正常小样ok方
    NSString  *tabName_;
    
//    标识是否会选中状态，在标记界面中，如果已经选中的话，是会变颜色的
//    0为未选中，1为选中
    NSInteger state;
    
//  被标记的配方的原配方，用于在取消标记后更新原来的配方的状态
    YDPalettesRecipeView  *originalRecipe;
}

@property (nonatomic ,assign) YDPalettesRecipeType recipeType;
@property (nonatomic ,assign) YDUserType           userType;
@property (nonatomic ,retain) UIButton    *touchButton;
@property (nonatomic ,retain) UILabel     *recipeTitle;
@property (nonatomic ,retain) UILabel     *yellowColorLabel;
@property (nonatomic ,retain) UILabel     *redColorLabel;
@property (nonatomic ,retain) UILabel     *blueColorLabel;

@property (nonatomic ,retain) UILabel     *moreLabel;

@property (nonatomic ,retain) UILabel     *colorLevelLabel;
@property (nonatomic ,retain) UILabel     *groupNameLabel;

@property (nonatomic ,retain) UIButton    *selectedButton;
@property (nonatomic ,retain) UIButton    *deleteButton;
@property (nonatomic ,retain) UIButton    *reModifyButton;

@property (nonatomic ,getter = isSelected,setter = setselectedWith:) BOOL selected;

@property (nonatomic ,getter =  isRemodified,setter = setremodifiedWith:) BOOL remodified;

@property (nonatomic ,retain) UIImageView	 *backgroundImageView;

@property (nonatomic ,copy) NSString		*colorLevelNameString;          //色级名称
@property (nonatomic ,copy) NSString		*recipeNameString;          //配方名字
@property (nonatomic ,copy) NSString		*groupNameString;        //组合名字
@property (nonatomic ,copy) NSString		*yellowString;
@property (nonatomic ,copy) NSString		*redString;
@property (nonatomic ,copy) NSString		*blueString;

@property (nonatomic ,assign) id<YDPalettesRecipeViewDelegate>delegate;


@property (nonatomic ,retain) Group_List *recipeVale;
@property (nonatomic ,retain) LAI_UIData *additives;

@property (nonatomic ,copy) NSString *tabName;

@property (nonatomic ,assign)  YDPalettesRecipeView  *originalRecipe;

//配方对应的组合的化学材料chemicalid ,用于在调用查询计算助剂的时候用到
@property (nonatomic,copy) NSString *chemicalIds;

//这个值即可以说是新值也可以说是旧值，当这个配方是在原来的历史配方中修改生成的，那么它就是这个配方的历史值
//这个是为了那些在原来的历史配方中修改的配方在output的时候可以拿取到历史配方值
@property (nonatomic ,copy) NSString  *oldAndNewUsages;

@property (nonatomic ,copy) NSString *oldUsages;






//修改或者新建的配方
//@property (nonatomic ,copy) NSString *newUsages;
@property (nonatomic ,copy) NSString  *usagesNew;
//配方所在的组合的id
@property (nonatomic ,copy) NSString *groupId;

@property (nonatomic ,assign) NSInteger state;

- (void)setupNoneRecipeBackground;
- (void)setUpOldRecipeBackground;
- (void)setUpBackgroundWith:(NSInteger)_recipeType;
- (UIImage *)backgroundImageWith:(NSInteger)_recipeType;
- (void)setUpDeepBackgroundWith:(NSInteger)_recipeType;
- (NSString *)generateOldUsage:(Group_List *)_recipeValue;

//为bulk用户组在标记界面中标记某一个配方时，设置在界面要显示的值
- (void)setGroupId:(NSString *)groupId tabName:(NSString *)_name;

- (void)transformToSelect;

- (void)transformToUnSelect;



//@property (nonatomic ,copy) NSString  *oldUsages;

//取出配方相应的数据，用于output
- (NSString *)getOldUsages;
//如果是从服务器取回来的配方，新的值跟旧的值是一样的
- (NSString *)getNewUsage;

- (NSString *)getRecipeNo;

- (NSString *)getNa2Co3;

- (NSString *)getNa2So4;

- (NSString *)getKeepWarnTime;


//用于lab用户组的调方
- (void)setRecipeValueWith:(Group_List *)_recipeValue;

//- (void)updateViewState:(NSInteger)_state;




- (id)initWithFrame:(CGRect)frame 
		 recipeType:(NSInteger )_recipeType;

- (id)initWithFrame:(CGRect)frame 
		 recipeType:(NSInteger )_recipeType userType:(YDUserType)_userType;

//只为lab用户的候选配方
- (id)initWithFrame:(CGRect)frame 
		 recipeType:(NSInteger )_recipeType 
			  names:(NSMutableArray *)_colorLevelNames;
//只为lab用户的色级
- (id)initWithFrame:(CGRect)frame 
		 recipeType:(NSInteger )_recipeType 
			  colorNames:(NSMutableArray *)_colorLevelNames;

- (void)setColorLevelName:(NSString *)_name;

- (void)updateBackgroundImage:(NSInteger )_recipeType;


@end
