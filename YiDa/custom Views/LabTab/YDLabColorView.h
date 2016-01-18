//
//  YDLabColorView.h
//  YiDa
//
//  Created by Ni on 12-11-19.
//  Copyright 2012 meson.com. All rights reserved.
//

 /*
  Created by lizhang Dong on 12-11-19
  说明：色级这一栏的选择框
 */

#import <UIKit/UIKit.h>


@interface YDLabColorView : UIView {

	UIScrollView *backgroundScrollView_;
	NSInteger  colorLevelCount;  //色级的数量，包括后面的+
	
	NSMutableArray  *colorsArray;
	
	NSMutableArray	*colorNamesArray;
}

@property (nonatomic ,retain) UIScrollView *backgroundScrollView;
//@property (nonatomic ,retain) NSMutableArray *colorNamesArray;
 
- (id)initWithFrame:(CGRect)frame levelCount:(NSInteger )_count;
- (id)initWithFrame:(CGRect)frame levelCount:(NSInteger )_count levelName:(NSMutableArray *)_names;

@end
