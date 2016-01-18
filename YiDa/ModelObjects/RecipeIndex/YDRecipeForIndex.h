//
//  YDRecipeForIndex.h
//  YiDa
  

/*
 Created by lizhang Dong on 2012-12-5
 说明：配方号，用于在查询的时候的一个索引，根据配方号取查询配方信息（只在查询的界面中用到）
 因为接口返回来的数据格式中，配方号和配方的描述都在同一个字段“Item_NO”里面类似“R3232323   YD小样ok方录入”这种格式，因此要分开
*/



#import <Foundation/Foundation.h>

@interface YDRecipeForIndex : NSObject

{
    NSString  *recipeNo_;      //配方号
    NSString  *remark_;        //配方的描述  在进度跟踪查询里面的左边的列表的第二行里面显示
}

@property (nonatomic ,copy) NSString *recipeNO;
@property (nonatomic ,copy) NSString *remark;

- (id)initWith:(NSDictionary *)_recipes;

@end
