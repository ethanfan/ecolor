//
//  Constants.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

 /*
  Created by lizhang.dong
  整个项目中可能用到的一些常量，结构体
 */

#import "YDPostNotificationName.h"

#define kCancelAlert  10001
#define kBackAlert    10002
#define kLogoutAlert  10003

#define kServerIPkey   @"ServerIP"

//可以输入小数点和负数
#define kInputNumberSet  @"0123456789.-"

//最底层的背景色
#define kColor       [UIColor colorWithRed:212/255.0 green:208/255.0 blue:199/255.0 alpha:1.0]

#define kInputFieldColor  [UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]
//212 208 199

//
#define kUpColor   [UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]

#ifndef YiDa_Constants_h
#define YiDa_Constants_h

typedef enum
{
    YDUserTypeNone=0,
     YDUserTypeBulk,    //bulk user group
    YDUserTypeLab,     //lab user group
    YDUserTypeUnknow,
} YDUserType;

//demes
typedef  enum
{
    YDNavigationBarButtonTypeNone = 0,
    YDNavigationBarButtonTitle,   //this type only show title,button will not respond touches
    YDNavigationBarButtonOutput,//output
    YDNavigationBarButtonCancel,//取消
    YDNavigationBarButtonBack,//返回
    YDNavigationBarButtonLogout,//注销
    YDNavigationBarButtonUnknow,
} YDNavigationBarButtonType;

//this struct decide the content YDNavigationBarButtonTitle display like:palettes,color,addction,search and tab
typedef enum
{
    YDNavigationBarViewTypeNone = 0,
    YDNavigationBarViewLabColor,          //lab选料
    YDNavigationBarViewLabPalettes,        //lab调方
    YDNavigationBarViewLabTab,             //lba标记
    YDNavigationBarViewLabQuery,           //lab查询
    YDNavigationBarViewBulkPalettes,        //bulk 调方
    YDNavigationBarViewBulkTab,             //bulk标记
    YDNavigationBarViewBulkAddiction,        //bulk加成
    YDNavigationBarViewBulkQuery,
	YDNavigationBarViewBulkRecipe,
	YDNavigationBarViewBulkVariety,
	YDNavigationBarViewBulkProgress,
    YDNavigationBarViewMore,
    YDNavigationBarViewUnknow,
} YDNavigationBarViewType;

typedef enum
{
	YDBulkQueryOptionNone= 0,
	YDBulkQueryOptionRecipe,    //配方进度查询  包括lab用户组中的查询
	YDBulkQueryOptionVariety,   //品种进度查询
	YDBulkQueryOptionProgress,  //进度跟踪查询
} YDBulkQueryOptionType;

typedef enum
{
	YDPopoverTargetTypeNone = 0,
	YDPopoverTargetKDNO ,     //开单号
	YDPopoverTargetColor,     //颜色
	YDPopoverTargetStep,      //步骤
	YDPopoverTargetCost,      //成本
	YDPopoverTargetSimpleColor,  //色系
	YDPopoverTargetType,        //分类
	YDPopoverTargetDeep,		//深浅
	YDPopoverTargetGanghao,
	YDPopoverTargetPinMing,
}YDPopoverTargetTypeOption;

//表明这个组合在那个界面出现
typedef enum
{
	YDGroupViewTypeNone = 0,
	YDGroupViewLabColor,       //lab用户组的选料组合
	YDGroupViewLabPalettes,    //lab用户组在调方的组合
	YDGroupViewLabTab,         //lab用户组在标记的组合
} YDGroupViewTypeOption;

//表明是新增色级和修改色级
typedef enum
{
	YDColorLevelModifyTypeNone= 0,
	YDColorLevelAddType,        //新增色级
	YDColorLevelModified,       //修改色级名称
}YDColorLevelModifyType;

//lab用户组；表明弹出的界面是哪种类型，1、有三个选项，2，一个选项；
typedef enum
{
	YDColorPopoverTypeNone = 0,
	YDColorPopoverMoreType,   //1
	YDColorPopoverSingleType,      //2
}YDColorPopoverType;

//lab用户组；表明弹出的界面是哪种类型，1、有两个选项，2，一个选项；
typedef enum
{
	YDTabPopoverTypeNone = 0,
	YDTabPopoverTwoType,       //1
	YDTabPopoverSingleType,     //2
}YDTabPopoverType;


//色级的几种状态
typedef enum
{
    YDLabTabColorNameRecipeStateNone = 0,
    YDLabTabColorNameRecipeStateOnlyColorName,    //只显示一个色级名字
    YDLabTabColorNameRecipeStateAddColorName,     //只显示一个加号，点击新增   改状态的色级永远只有一个
    YDLabTabColorNameRecipeStateSelect,           //被标记的配方，放在这里，现实配方值，色级名字，组合名字，配方号
} YDLabTabColorNameRecipeState;

//bulk用户组中调方和加成的配方的view 的类型，有newrecipe 、历史配方和新建未output的配方，最后的是可以删除的
typedef enum
{
    YDBulkPalettesRecipeTypeNone = 0,
    YDBulkPalettesRecipeTypeNew,
    YDbulkPalettesRecipeOld,
} YDBulkPalettesRecipeType;

//配方的操作 
typedef enum {
    YDRecipeViewOperationNoneType = 0,
    YDRecipeViewOperationSelectType,        //选择配方，左上方打勾
    YDRecipeViewOperationCancelType,        //取消选择配方，左上方的勾去掉
    YDRecipeViewOperationDeleteType,        //删除新建的配方，历史配方是不可以删除的
    YDRecipeViewOperationNewType,           //新建的配方，默认是已经选择的。
} YDRecipeViewOperationType;
#endif
