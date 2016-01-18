//
//  YDTabPopoverView.h
//  YiDa
//
//  Created by Ni on 12-11-22.
//  Copyright 2012 meson.com. All rights reserved.
//

/*
 Created by lizhang Dong on 12-11-21 
 说明:bulk用户组 长按色级后弹出来的界面，都是在tab，标记这个界面
 */


#import <UIKit/UIKit.h>
#import "Constants.h"



@class YDTabPopoverView;

@protocol YDTabPopoverViewDelegate<NSObject>

@optional
- (void)tabPopover:(YDTabPopoverView *)_tabPopoverView normalSimple:(BOOL)_normal;
- (void)tabPopover:(YDTabPopoverView *)_tabPopoverView remodifySimple:(BOOL)_remodify;
- (void)tabPopover:(YDTabPopoverView *)_tabPopoverView cancelTab:(BOOL)_cancel;

@end

@interface YDTabPopoverView : UIView {
	YDTabPopoverType popoverType_;
	
	id<YDTabPopoverViewDelegate>delegate;
	
	//在这里只是一个中转
	id transferTarget_;
}

@property (nonatomic ,readonly) YDTabPopoverType popoverType;
@property (nonatomic ,assign) id <YDTabPopoverViewDelegate>delegate;

@property (nonatomic ,assign)id transferTarget;

- (id)initWithFrame:(CGRect)frame 
			   type:(YDTabPopoverType )_type 
		   delegate:(id<YDTabPopoverViewDelegate>)_delegate;

@end
