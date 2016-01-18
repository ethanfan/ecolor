//
//  YDLabTabColorNameRecipe.h
//  YiDa
//
//  Created by Meson Networks on 12-12-8.
//
//

//色级这一栏，包括只有一个色级名字，有一个“+”的情况，还有已经被选择了现实色级名字，配方号，配方值和组合名字
//配方值是不固定的，有三个或者四个

#import <UIKit/UIKit.h>
#import "YDPalettesRecipeView.h"
#import "Constants.h"

//YDLabTabColorNameRecipeStateNone = 0,
//YDLabTabColorNameRecipeStateOnlyColorName,  1  //只显示一个色级名字
//YDLabTabColorNameRecipeStateAddColorName,    2 //只显示一个加号，点击新增
//YDLabTabColorNameRecipeStateSelect,          3
//转换情况，由1到3，和由3到1

@interface YDLabTabColorNameRecipe : UIView
{

//    记录view的类型，用户转换
    YDLabTabColorNameRecipeState  colorViewType_;
//    决定是否可以output
//    0就不output ，1就output
    NSInteger outputState_;
//    色级的名称,加入这个是为了,用户修改色级名称,更改色级名做一个判断,这个色级名字是否有效
    NSMutableArray *colorLevelName;
//    配方的内容，需要从外部传递过来，根据不同的类型，这个可以选择释放
    Group_List *recipeVale_;
}

@property (nonatomic ,assign) NSInteger outputState;
@property (nonatomic ,assign) YDLabTabColorNameRecipeState  colorViewType;

@property (nonatomic ,retain)     Group_List *recipeVale;

//每一个类型的转换需要把之前add到上面的view全部清空
- (void)reloadDataWith:(YDLabTabColorNameRecipeState)_viewType;

@end
