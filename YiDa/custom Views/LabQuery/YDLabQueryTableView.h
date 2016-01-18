//
//  YDLabQueryTableView.h
//  YiDa
//
//  Created by Ni on 12-11-15.
//  Copyright 2012 meson.com. All rights reserved.
//
 
 /* Created by lizhang Dong on 12-11-15
  说明：查询界面中左侧的配方号的tableview
 */

#import <UIKit/UIKit.h>
#import "YDRecipeForIndex.h"

@class YDLabQueryTableView;

@protocol YDLabQueryTableViewDelegate <NSObject>

@optional

- (void)queryTabelView:(YDLabQueryTableView*)_tableView didSelectRow:(NSInteger)_row;

- (void)queryTabelView:(YDLabQueryTableView*)_tableView didSelectRow:(NSInteger)_row withRecipe:(NSString *)_recipe;

@end

@interface YDLabQueryTableView : UIView <UITableViewDataSource,UITableViewDelegate>{

	UITableView *recipeTableView_;
    id <YDLabQueryTableViewDelegate> delegate;
    
    BOOL        progress ;   //表明是否进度跟踪查询
    NSMutableArray *datas_;
}
@property (nonatomic ,retain) UITableView *recipeTableView;
@property (nonatomic ,assign) id<YDLabQueryTableViewDelegate>delegate;
@property (nonatomic ,getter = isprogess) BOOL        progress ; 

@property (nonatomic ,retain) NSMutableArray *datas;

- (void)reloadTableData:(NSMutableArray *)_datas;

@end
