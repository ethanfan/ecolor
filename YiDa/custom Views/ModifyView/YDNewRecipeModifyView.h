
 /*
  Created by lizhang Dong on 12-11-20
  说明：lab用户组中在调方时，新增配方的弹出界面
  update：
 */



#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DataKit.h"
#import "DataMember.h"
#import "NumberKeyboard.h"

@protocol YDNewRecipeViewDelegate <NSObject>
    
//lab用户组的新建配方的回调，把这些值传回去，下一次点击新建时不需要再查询了。
- (void)labNewRecipeWith:(NSString *)_newUsage 
        withKeepWarnTime:(NSString *)_warnTime 
              withNA2SO4:(NSString *)_NA2SO4 
              withNA2CO3:(NSString *)_NA2CO3_;

- (void)labNewRecipeWith:(NSString *)_newUsage 
        withKeepWarnTime:(NSString *)_warnTime 
              withNA2SO4:(NSString *)_NA2SO4 
              withNA2CO3:(NSString *)_NA2CO3_ 
                withRato:(NSString *)_rato;

@end


@interface YDNewRecipeModifyView : UIView<UITextFieldDelegate>
{
   
    UITextField *yellowLabel_;
    UITextField *redLabel_;
    UITextField *blueLabel_;
    UITextField *moreField_;
    UIButton *recipeConfirmButton_;
    UIButton *recipeCancelButton_;
    
    UITextField *soltLabel_;          //盐
    UITextField *sodaLabel_;          //碱
    UITextField *warnTimeLabel_;     //保温
    UIButton *confirmButton_;
    UIButton *cancelButton_;
	
	
	UITextField *bathRate_;          //浴比  只有在bulk用户中才出现
	
	UITextField	*activedEditField;
	
	id keyboardShowObserver;
	id keyboardHideObserver;
	
	UIImageView  *backgroundImageView_;
	UIButton	 *detailButton_;
	
	
	 UIView *containerView_;
	
	YDUserType		userType_;
	NSInteger		containerHeight;
    
//    可以让用户修改的几个值
    NSString        *keepWarnTime_;
    NSString        *NA2SO4_;
	NSString        *NA2CO3_;
    
//    配方的几个值，用量
    Group_List      *recipeValues_;
//    助剂的值
    LAI_UIData     *addictives_;
    
//    如果是bulk用户组的话还有一个浴比
    NSString       *rato_;
//    如果保温时间／NA2SO4，不存在的时候就要用到这个染料串去获取
    NSString     *chemicalIds_;
    
    BOOL            checked;
    
    //    自定义键盘
    NumberKeyboard *keyboard;
}
@property (nonatomic ,retain)     UIView *containerView;
@property (nonatomic ,retain) UITextField *yellowLabel;
@property (nonatomic ,retain) UITextField *redLabel;
@property (nonatomic ,retain) UITextField *blueLabel;
@property (nonatomic ,retain) UITextField *moreField;
@property (nonatomic ,retain) UIButton *recipeConfirmButton;
@property (nonatomic ,retain) UIButton *recipeCancelButton;

@property (nonatomic ,retain) UITextField *soltLabel;          //盐
@property (nonatomic ,retain) UITextField *sodaLabel;          //碱
@property (nonatomic ,retain) UITextField *warnTimeLabel;     //保温
@property (nonatomic ,retain) UIButton *confirmButton;
@property (nonatomic ,retain) UIButton *cancelButton;

@property (nonatomic ,retain) UITextField *bathRate;

@property (nonatomic ,retain) UIImageView *backgroundImageView;
@property (nonatomic ,retain) UIButton *detailButton;

@property (nonatomic ,assign) YDUserType		userType;

@property (nonatomic ,copy) NSString *NA2CO3;
@property (nonatomic ,copy) NSString *NA2SO4;
@property (nonatomic ,copy) NSString *rato;

@property (nonatomic ,copy) NSString *keepWarnTime;
@property (nonatomic ,copy) Group_List *recipeValues;
@property (nonatomic ,copy) LAI_UIData *addictives;

@property (nonatomic ,copy) NSString     *chemicalIds;

//这些值用于查询计算助剂
@property (nonatomic ,copy) NSString *batchNo;
@property (nonatomic ,copy) NSString *xriteNO;
@property (nonatomic ,copy) NSString *firstDyeCotton;

- (void)setValue:(NSString *)_batchNo xriteNo:(NSString *)_xriteNo firstDyeCotton:(NSString *)_firstDyeCotton;

- (void)show:(BOOL)_animated;

- (id)initWithFrame:(CGRect)frame userType:(YDUserType )_userType;

- (void)initContentFieldWith:(NSInteger )_count;


@end
