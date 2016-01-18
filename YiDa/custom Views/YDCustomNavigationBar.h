//
//  YDCustomNavigationBar.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

 /*
   Created by lizhang.dong
  说明 ：实现各个界面中上面的导航栏，只响应界面，不处理逻辑
 */



#import <UIKit/UIKit.h>
#import "Constants.h"

@class YDCustomNavigationBar;
@protocol YDCustomNavigationBarButtonDelegate

- (void)buttonForNavigationBar:(YDCustomNavigationBar *)_customNavigationBar 
                    buttonType:(NSInteger)_buttonType;

@end

@interface YDCustomNavigationBar : UIView
{
    YDNavigationBarViewType navigationBarViewType_; 
    id<YDCustomNavigationBarButtonDelegate> delegate_;
    NSMutableArray *buttons_;
}

@property (nonatomic ,assign) YDNavigationBarViewType navigationBarViewType;
@property (nonatomic ,assign) SEL touchRespondAction;
@property (nonatomic ,retain) NSMutableArray *buttons;
@property (nonatomic ,assign) id<YDCustomNavigationBarButtonDelegate>delegate;
@property (nonatomic ,assign) NSInteger currentUserType;

//左边的按钮有两种情况，第一是四个，第二是一个（返回）
- (id)initWithLeftButtonNumber:(NSInteger )_numbers 
                      viewType:(NSInteger)_viewType 
                      userType:(NSInteger )_userType 
                      delegate:(id<YDCustomNavigationBarButtonDelegate>)_delegate;

@end
