//
//  YDPalettesGroupView.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*
 Created by lizhang dong on 12－11－10
 说明：lab用户组中调方的组合的view   这个在界面显示中是比较长的
 */


#import <UIKit/UIKit.h>
#import "DataKit.h"

@interface YDPalettesGroupView : UIView
{
    UIImageView *colorImage_;   //三色
    UILabel     *groupTitleLabel_;  
    UILabel     *yellowColorLabel_;
    UILabel     *redColorLabel_;
    UILabel     *blueColorLabel_;
    
    Group_Head  *paletteGroup_;
    
    UIScrollView  *scrollView;
}


@property (nonatomic ,retain) UIImageView *colorImage;
@property (nonatomic ,retain) UILabel     *groupTitleLabel;
@property (nonatomic ,retain) UILabel     *yellowColorLabel;
@property (nonatomic ,retain) UILabel     *redColorLabel;
@property (nonatomic ,retain) UILabel     *blueColorLabel;

@property (nonatomic ,retain) Group_Head  *palettesGroup;

- (id)initWithFrame:(CGRect)frame withGroup:(Group_Head *)_groupContent;

@end
