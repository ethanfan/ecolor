//
//  YDBulkPalettesRecipeView.h
//  YiDa
//
//  Created by Meson Networks on 12-12-9.
//
//
//bulk用户组中的调方和加成里面的配方的view
//

#import <UIKit/UIKit.h>
#import "YDPalettesRecipeView.h"
#import "DataKit.h"
#import "Constants.h"
#import "DataMember.h"


@interface YDBulkPalettesRecipeView : YDPalettesRecipeView
{
//    浴比
    NSString *rato_;
//    缸号
    NSString *batchNo_;
//    爱丽色缸号
    NSString *xriteNO_;
//    是否染棉
    NSString *firstDyeCotton_;
    
//    bulk 用户助剂的内容
//    BAI_UIData *addictives_;
    
    YDBulkPalettesRecipeType subViewType;
    
    
}

- (id)initWithFrame:(CGRect)frame viewType:(YDBulkPalettesRecipeType )_viewType;

- (void)setRecipeValueWith:(Group_List *)_recipeValue;
- (void)setUpSelectedButton;
- (void)setUpDeleteButton;

@property (nonatomic ,assign) YDBulkPalettesRecipeType subViewType;

@property (nonatomic ,copy) NSString *rato;
@property (nonatomic ,copy) NSString *batchNo;
@property (nonatomic ,copy) NSString *xriteNO;
@property (nonatomic ,copy) NSString *firstDyeCotton;

//@property (nonatomic ,retain) BAI_UIData *addictives;
@end
