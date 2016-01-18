//
//  YDLabTabGroupView.h
//  YiDa
//
//  Created by Meson Networks on 12-12-8.
//
//

#import <Foundation/Foundation.h>

#import "YDColorGroupView.h"
#import "DataKit.h"

@interface YDLabTabGroupView : YDColorGroupView
{
    Group_Head *groupValue_;
}

@property (nonatomic ,retain) Group_Head *groupValue;

//使用组合的信息进行初始化
- (id)initWithFrame:(CGRect)frame with:(Group_Head *)_groupInfo;

//- (void)setUpDeepestBackgroup;

@end
