//
//  ChemicalInfo.h
//  YiDa
//
//  Created by meson on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CI_Atrb_GroupInfo : NSObject
{
    //组合ID
    NSString *GroupID;
}
@property(nonatomic,retain)  NSString *GroupID;

@end


@interface CI_Atrb_xriteItemNO : NSObject
{
    //组合ID
    NSString *xriteNO;
}
@property(nonatomic,retain)  NSString *xriteNO;

@end



@interface CI_Atrb_ChemicalInfo : NSObject
{
    //化工料名称
    NSString *Chemical_Name;
    //化工料ID
    NSString *Chemical_ID;
    //化工料批次(暂时不用) 
    NSString *Stuff_Bat;
    
    //可能会有这个字段，，如果返回值没有这个字段，表示为空，这里的值为空；有就有没有就没有！！！
    NSString *NewRecipe;//放弃用
    //rowItemAry 的数组元素个数表示后面多少个方块
    NSMutableArray *rowItemAry;//放弃用
    /* NewRecipe = "0,7";
     R210253115 = "0,76";
     R210260040 = "0,7";*/
    NSMutableDictionary *mutDic;
}

@property(nonatomic,retain)NSString *Chemical_Name;
@property(nonatomic,retain)NSString *Chemical_ID;
@property(nonatomic,retain)NSString *Stuff_Bat;
@property(nonatomic,retain)NSString *NewRecipe;
@property(nonatomic,retain)NSMutableArray *rowItemAry;
@property(nonatomic,retain)NSMutableDictionary *mutDic;

//@property(nonatomic,retain)NSString *R210260040;
//@property(nonatomic,retain)NSString *R210253115;

@end


//for ui
@interface Group_Head: NSObject
{
    //左边的组合，的名称
    NSString *titleName;
    //这个方块中的值
    NSMutableArray * valueAry;
}
@property(nonatomic,retain) NSString *titleName;
@property(nonatomic,retain) NSMutableArray *valueAry;

@end





@interface Group_List: NSObject
{
    //小方块标题，也就是dic的key
    NSString *titleName;
    //一个方块会有多少个数值，
    NSMutableArray *valueAry;
}
@property(nonatomic,retain) NSString *titleName;
@property(nonatomic,retain) NSMutableArray *valueAry;



@end


@interface ChemicalInfo : NSObject
{
@private
    //数组元素：CI_Atrb_GroupInfo
    NSArray *groupInfoAry;
    //type==2或者type==4的时候用到这个字段
    //"xriteNO" 的value ，eg："加成"
    CI_Atrb_xriteItemNO *xriteItemNO;
@private

    //数组元素：CI_Atrb_ChemicalInfo,对应网络数据为由改变过结构的
    NSArray *chemicalInfoAry;
    //左边界面只有一个组合信息
    Group_Head *group_Head;
    //元素Group_List
    NSArray *grouplistAry;
    
}
@property(nonatomic,retain) NSArray *groupInfoAry;
@property(nonatomic,retain) NSArray *chemicalInfoAry;
@property(nonatomic,retain) Group_Head *group_Head;
@property(nonatomic,retain) NSArray *grouplistAry;
@property(nonatomic,retain) CI_Atrb_xriteItemNO *xriteItemNO;



-(Group_Head *)getValueForGroup_Head;
-(NSArray *)getValueListForGroup_List;
@end

