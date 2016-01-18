//
//  LabAuxiliariesInfo.h
//  YiDa
//
//  Created by meson on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface  LAI_Atrb_ArtInfo : NSObject
{
    //前处理工艺号
    NSString * PreArt;
    //染色工艺号
    NSString * DyeArt;
    //保温时间
    NSString * KeepTime;
    //后处理工艺号
    NSString * LaterArt;
    //染料总用量
    NSString * OWF;
    //备注
    NSString * Remark;
}



@property(nonatomic,retain)NSString * PreArt;
@property(nonatomic,retain)NSString * DyeArt;
@property(nonatomic,retain)NSString * KeepTime;
@property(nonatomic,retain)NSString * LaterArt;
@property(nonatomic,retain)NSString * OWF;
@property(nonatomic,retain)NSString * Remark;
@end


@interface LAI_Atrb_ChemicalInfo : NSObject
{
    //化工料名称(保存了工艺 助计 名称)
    NSString *Chemical_Name;
    //化工料ID
    NSString *Chemical_ID;
    //化工料批(暂时不用)
    NSString *Stuff_Bat;
    //化料用量
    NSString *NewRecipe;
    
}

@property(nonatomic,retain)NSString *Chemical_Name;
@property(nonatomic,retain)NSString *Chemical_ID;
@property(nonatomic,retain)NSString *Stuff_Bat;
@property(nonatomic,retain)NSString *NewRecipe;

@end

//data for ui 
@interface LAI_UIData : NSObject
{
    NSString *NA2SO4;
    NSString *NA2CO3;
    NSString *keepWarnTime;
}
@property(nonatomic,retain) NSString *NA2SO4;
@property(nonatomic,retain) NSString *NA2CO3;
@property(nonatomic,retain) NSString *keepWarnTime;


@end


@interface LabAuxiliariesInfo : NSObject
{
    
    @private
    //数组元素：LAI_Atrb_ArtInfo
    NSArray *  ArtInfoAry;
    //数组元素： LAI_Atrb_ChemicalInfo
    NSArray *  ChemicalInfoAry;
    
    LAI_UIData *laiUIData;
}
//数组元素：LAI_Atrb_ArtInfo
@property(nonatomic,retain)NSArray *  ArtInfoAry;
//数组元素： LAI_Atrb_ChemicalInfo
@property(nonatomic,retain)NSArray *  ChemicalInfoAry;
@property(nonatomic,retain)LAI_UIData *laiUIData;



-(LAI_UIData *)getLAIUIData;

@end





