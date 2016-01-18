//
//  YDColorPopoverView.h
//  YiDa
//
//  Created by Ni on 12-11-21.
//  Copyright 2012 meson.com. All rights reserved.
//

 /*
  Created by lizhang Dong on 12-11-21 
  说明:lab用户组 长按色级后弹出来的界面，都是在tab，标记这个界面
 */


#import <UIKit/UIKit.h>
#import "Constants.h"

@class YDColorPopoverView;

@protocol YDColorPopoverViewDelegate<NSObject>

@optional
- (void)colorPopoverView:(YDColorPopoverView *)_colorPopoverView didSelectedType:(NSInteger )_popoverType;

//更改色级名字
- (void)tabColorPopover:(YDColorPopoverView *)_colorPopoverView modifyColorName:(BOOL )_modifyName;
//取消标记
- (void)tabColorPopover:(YDColorPopoverView *)_colorPopoverView cancelTab:(BOOL)_cancelTab;
//更改色级
- (void)tabColorPopover:(YDColorPopoverView *)_colorPopoverView changeColorName:(BOOL )_changeName;

@end






@interface YDColorPopoverView : UIView 
{
	YDColorPopoverType popoverType_;
	NSString   *buttonTitle_;
	
	id<YDColorPopoverViewDelegate>delegate;
	
	//在这里只是一个中转
	id transferTarget_;
}
@property (nonatomic ,readonly) YDColorPopoverType popoverType;
@property (nonatomic ,copy) NSString  *buttonTitle;
@property (nonatomic ,assign) id <YDColorPopoverViewDelegate>delegate;

@property (nonatomic ,assign)id transferTarget;

- (id)initWithFrame:(CGRect)frame type:(YDColorPopoverType )_type;
- (id)initWithFrame:(CGRect)frame type:(YDColorPopoverType )_type title:(NSString *)_pTitle;

@end
