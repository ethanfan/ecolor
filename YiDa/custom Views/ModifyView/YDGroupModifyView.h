//
//  YDGroupModifyView.h
//  YiDa
//
//  Created by Ni on 12-11-20.
//  Copyright 2012 meson.com. All rights reserved.
//

 /*Created by lizhang Dong on 12-11-20
  说明:lab用户组中选料的修改组合配方的弹界面
  update:
  
 */

#import <UIKit/UIKit.h>
#import "NumberKeyboard.h"
@protocol YDGroupModifyViewDelegate <NSObject>

@optional
- (void)finishModifyGroupWith:(NSString *)_usages;

@end


@interface YDGroupModifyView : UIView <UITextFieldDelegate>
{
	UIView      *containerView_;
	UIImageView *backgroundImageView_;
	UILabel     *titleLabel_;
	UILabel		*yellowLabel_;
	UILabel     *redLabel_;
	UILabel		*blueLabel_;
	UITextField    *yellowField_;
	UITextField    *redField_;
	UITextField	   *blueField_;
    UITextField    *moreField_;
	
	UIButton	*confirmButton_;
	UIButton    *cancelButton_;
	
	id keyboardShowObserver;
	id keyboardHideObserver;
    
    NSArray  *chemicalList_;
    id<YDGroupModifyViewDelegate>delegate;
    
//    用户输入的配方值，被修改过的组合才有
    NSString *usages_;
    
//    自定义键盘
    NumberKeyboard *keyboard;
    
}

@property (nonatomic ,retain) UIImageView *backgroundImageView;
@property (nonatomic ,retain) UILabel	   *titleLabel;
@property (nonatomic ,retain) 	UILabel		*yellowLabel;
@property (nonatomic ,retain) UILabel     *redLabel;
@property (nonatomic ,retain) UILabel		*blueLabel;
@property (nonatomic ,retain) UITextField    *yellowField;
@property (nonatomic ,retain) UITextField    *redField;
@property (nonatomic ,retain) UITextField	   *blueField;
@property (nonatomic ,retain) UITextField       *moreField;
@property (nonatomic ,retain) UIButton			*confirmButton;
@property (nonatomic ,retain) UIButton          *cancelButton;

@property (nonatomic ,retain) UIView      *containerView;

@property (nonatomic ,retain) NSArray  *chemicalList;
@property (nonatomic ,assign) id<YDGroupModifyViewDelegate>delegate;

@property (nonatomic ,copy) NSString  *usages;
- (void)setChemicalListWith:(NSArray *)_list;

- (void)setInputFieldWith:(NSArray *)_list;

- (void)setColorImagesWith:(NSInteger )_count;
- (void)setUpChemicalNamesWith:(NSArray *)_names;



- (void)show:(BOOL)_animated;


@end
