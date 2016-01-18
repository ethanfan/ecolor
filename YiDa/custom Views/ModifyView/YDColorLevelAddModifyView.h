//
//  YDColorLevelAddModifyView.h
//  YiDa
//
//  Created by Ni on 12-11-21.
//  Copyright 2012 meson.com. All rights reserved.
//

/*
 Created by lizhang Dong on 12-11-21
 说明：lab用户组中点击色级+，时弹出新增色级和长按色级时弹出修改色级名称
 update：
 
 */

#import <UIKit/UIKit.h>
#import "Constants.h"

@class YDColorLevelAddModifyView;

@protocol YDColorLevelAddModifyViewDelegate <NSObject>

//修改色级名字
- (void)didchooseModifyName:(YDColorLevelAddModifyView *)_modifyView name:(NSString *)_newColorName;

//新增色级
- (void)didchooseAddNewColorName:(YDColorLevelAddModifyView *)_modifyView name:(NSString *)_newColorName;

@end

@interface YDColorLevelAddModifyView : UIView <UITextFieldDelegate>
{
	
	UIButton *confirmButton_;
	UIButton *cancelButton_;
	UITextField *nameField_;
	UIView  *containerView_;
	YDColorLevelModifyType  modifyType_;        //操作的类型，修改或者新增
	
	//修改或新增后的响应者
	id recieveTarget_;
    
    id<YDColorLevelAddModifyViewDelegate>delegate;
}

@property (nonatomic ,retain) UIView *containerView;
@property (nonatomic ,retain) UIButton *confirmButton;
@property (nonatomic ,retain) UITextField  *nameField;
@property (nonatomic ,retain) UIButton *cancelButton;

@property (nonatomic ,assign) id recieveTarget;


@property (nonatomic ,readonly) YDColorLevelModifyType modifyType;

@property (nonatomic ,assign) id<YDColorLevelAddModifyViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame type:(YDColorLevelModifyType )_type;
- (id)initWithFrame:(CGRect)frame type:(YDColorLevelModifyType )_type delegate:(id<YDColorLevelAddModifyViewDelegate>)_delegate;

- (void)show:(BOOL)_animated;

@end
