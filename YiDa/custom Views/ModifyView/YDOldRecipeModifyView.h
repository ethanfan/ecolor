
/*
 Created by lizhang Dong on 12-11-20
 说明：lab用户组中在调方时，修改历史配方的弹出界面
 update：
 */


#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DataKit.h"
#import "NumberKeyboard.h"

@interface YDOldRecipeModifyView : UIView<UITextFieldDelegate>
{
//    z原配方值
    UILabel *titleLabel_;
    UILabel *yellowLabel_;
    UILabel *redLabel_;
    UILabel *blueLabel_;
    UILabel *moreLabe_;
//    百分 比输入
    UITextField *yellowInputField_;
    UITextField *redInputField_;
    UITextField *blueInputField_;
    UITextField *moreInputField_;
//    新配方值，通过输入百分比或者直接输入结果
    UITextField *yellowResultField_;
    UITextField *redResultField_;
    UITextField *blueResultField_;
    UITextField *moreResultField_;
    UIButton *recipeConfirmButton_;
    UIButton *recipeCancelButton_;
    
    UITextField *soltInputField_;
    UITextField *sodaInputField_;
    UITextField *warnInputField_;
    UIButton *confirmButton_;
    UIButton *cancelButton_;
    
	UITextField *bathRate_;      //浴比
	
	id keyboardShowObserver;
	id keyboardHideObserver;
	
	UITextField *activeField;
	
    UIButton     *remodifyButton_;
    BOOL     modify;//回修
    
	UIImageView *backgroundImageView_;
	UIButton    *detailButton_;
	
	YDUserType		userType_;
    UIView  *containerView_;
	
	NSInteger		containerHeight;
    
    NSString       *rato_;
//    助剂的历史值
    LAI_UIData  *addictives_;
//    配方的历史值
    Group_List  *recipeValue_;

    //    自定义键盘
    NumberKeyboard *keyboard;
}

@property (nonatomic ,retain)     UILabel *titleLabel;
@property (nonatomic ,retain)     UILabel *yellowLabel;
@property (nonatomic ,retain)     UILabel *redLabel;
@property (nonatomic ,retain)     UILabel *blueLabel;
@property (nonatomic ,retain)     UILabel *moreLabel;

@property (nonatomic ,retain)     UITextField *yellowInputField;
@property (nonatomic ,retain)     UITextField *redInputField;
@property (nonatomic ,retain)     UITextField *blueInputField;
@property (nonatomic ,retain)     UITextField *moreInputField;

@property (nonatomic ,retain)     UITextField *yellowResultField;
@property (nonatomic ,retain)     UITextField *redResultField;
@property (nonatomic ,retain)     UITextField *blueResultField;
@property (nonatomic ,retain)     UITextField *moreResultField;

@property (nonatomic ,retain)     UIButton *recipeConfirmButton;
@property (nonatomic ,retain)     UIButton *recipeCancelButton;

@property (nonatomic ,retain)     UITextField *soltInputField;
@property (nonatomic ,retain)     UITextField *sodaInputField;
@property (nonatomic ,retain)     UITextField *warnInputField;
@property (nonatomic ,retain)     UIButton *confirmButton;
@property (nonatomic ,retain)     UIButton *cancelButton;

@property (nonatomic ,retain)     UIButton *remodifyButton;

@property (nonatomic ,retain)     UIImageView *backgroundImageView;
@property (nonatomic ,retain)     UIButton    *detailButton;
@property (nonatomic ,retain)     UITextField *bathRate;

@property (nonatomic ,assign)    YDUserType		userType;
@property (nonatomic ,retain)     UIView   *containerView;


@property (nonatomic ,copy)   LAI_UIData  *addictives;
@property (nonatomic ,copy)   Group_List  *recipeValue;
@property (nonatomic ,copy)     NSString       *rato;



//这些值用于查询计算助剂
@property (nonatomic ,copy) NSString *batchNo;
@property (nonatomic ,copy) NSString *xriteNO;
@property (nonatomic ,copy) NSString *firstDyeCotton;
@property (nonatomic ,copy) NSString *chemicalIds;

- (void)setValue:(NSString *)_batchNo xriteNo:(NSString *)_xriteNo firstDyeCotton:(NSString *)_firstDyeCotton;

- (void)show:(BOOL)_animated;

- (id)initWithFrame:(CGRect)frame userType:(YDUserType )_userType;

@end
