//
//  YDColorLevelModifyView.h
//  YiDa
//
//  Created by Ni on 12-11-21.
//  Copyright 2012 meson.com. All rights reserved.
//

 /*
  Created by lizhang Dong on 12-11-21
  说明：lab用户组中长按候选配方时弹出来的标记色级界面
  update：
  
 */

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "YDColorLevelName.h"
#import "DataKit.h"
#import "YDPalettesRecipeView.h"


@class YDColorLevelModifyView;

//标记为色级
@protocol YDColorLevelModifyViewDelegate <NSObject>

//标记为色级
@optional
- (void)didTabColorName:(YDColorLevelModifyView *)_modifyView name:(NSString *)_tabedName;

@end

@interface YDColorLevelModifyView : UIView 
{
	UIView		*containerView_;
    UIScrollView *colorNameScrollView_;
	
	id receiveTarget_;
	
	NSMutableArray *names;
    
//    标记时要传递的数据
//    配方的值
    Group_List *recipeValue_;
//    组合的id
    NSString   *groupId_;
    
//    YDPalettesRecipeView *caller_;
    
    id<YDColorLevelModifyViewDelegate>delegate;
}
@property (nonatomic ,retain) UIView  *containerView;
@property (nonatomic ,retain) UIScrollView *colorNameScrollView;
@property (nonatomic ,assign) id receiveTarget;

@property (nonatomic ,retain) Group_List *recipeValue;
@property (nonatomic ,copy) NSString *groupId;

//@property (nonatomic ,assign) YDPalettesRecipeView *caller;

@property (nonatomic ,assign) id<YDColorLevelModifyViewDelegate>delegate;


- (id)initWithFrame:(CGRect)frame names:(NSMutableArray *)_namesArray;

- (id)initWithFrame:(CGRect)frame names:(NSMutableArray *)_namesArray
           delegate:(id<YDColorLevelModifyViewDelegate>)_delegate;

- (void)show:(BOOL)_animated;


@end
