//
//  YDLabTabView.h
//  YiDa
//
//  Created by Ni on 12-11-19.
//  Copyright 2012 meson.com. All rights reserved.
//


 /*
  Created by lizhang Dong on 12-11-19 
  说明：Lab用户组标记操作界面中的 组合和配方的view
  update:
        -------------  s
		|		|
		|-------|-----------------------
		|		|
		|-------|-------------------------
		|		|
		-------------
 */


#import <UIKit/UIKit.h>
#import "YDColorGroupView.h"
#import "YDPalettesRecipeView.h"
#import "DataKit.h"


@interface YDLabTabView : UIView 
{
	UIScrollView *recipeScrollView_;
	
	
	NSInteger   recipeCount_;
	
	YDPalettesRecipeType recipeViewType_;
	
	NSMutableArray	*colorLevelName;
    
//    配方的信息
    ChemicalInfo *recipeInfo_;
}

@property (nonatomic ,retain) UIScrollView *recipeScrollView;

@property (nonatomic ,assign) NSInteger   recipeCount;

@property (nonatomic ,assign) YDPalettesRecipeType recipeViewType;

@property (nonatomic ,retain)  ChemicalInfo *recipeInfo;

- (id)initWithFrame:(CGRect)frame recipeCount:(NSInteger )_recipeCount;

- (id)initWithFrame:(CGRect)frame recipeCount:(NSInteger )_recipeCount 
		 recipeType:(YDPalettesRecipeType)_recipeType;

- (id)initWithFrame:(CGRect)frame recipeCount:(NSInteger )_recipeCount 
		 recipeType:(YDPalettesRecipeType)_recipeType 
			  names:(NSMutableArray *)_names;

- (id)initWithFrame:(CGRect)frame recipeCount:(NSInteger )_recipeCount
		 recipeType:(YDPalettesRecipeType)_recipeType
              names:(NSMutableArray *)_names
         recipeInfo:(ChemicalInfo *)_recipeInfo;

@end
