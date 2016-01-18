//
//  YDPopoverViewController.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

 /*
  Created by lizhang Dong on 12－11－10
  说明：选择时的弹出界面
 */

#import <UIKit/UIKit.h>
#import "Constants.h"

@class YDPopoverViewController;
@protocol YDPopoverViewDelegate<NSObject>

@optional
- (void)targetForPopoverView:(YDPopoverViewController *)_popoverViewController 
									content:(NSString *)_content 
									buttonType:(NSInteger )_buttonType;

@end


@interface YDPopoverViewController : UITableViewController
{
	id<YDPopoverViewDelegate> delegate;
	NSInteger    currentTargetType;
	
	NSArray		*datas;
}
@property (nonatomic ,assign) id<YDPopoverViewDelegate> delegate;

@property (nonatomic ,retain) NSArray *datas;

- (id)initWithStyle:(UITableViewStyle)style 
              title:(NSString *)_viewTitle 
		 buttonType:(NSInteger )_buttonType
             delegate:(id<YDPopoverViewDelegate>)_delegate;

@property (nonatomic ,assign) id target;


@end
