//
//  BulkAuxiliariesInfo.h
//  YiDa
//
//  Created by meson on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


//ArtInfo key and value
/*
{
    "PreArt": "EP22",
    "DyeArt": "ED01",
    "KeepTime": "60",
    "LaterArt": "EA01",
    "OWF": "2,68600",
    "Remark": "染色加HAC 0.2G/L"
}*/


/*
"ChemicalInfo": [
                 {
                     "Chemical_Name": "NA2SO4",
                     "Chemical_ID": "56",
                     "Stuff_Bat": "N/A",
                     "NewRecipe": "60,00000"
                 },
                 {
                     "Chemical_Name": "NA2CO3",
                     "Chemical_ID": "54",
                     "Stuff_Bat": "N/A",
                     "NewRecipe": "20,00000"
                 },
                 {
                     "Chemical_Name": "DM-2518",
                     "Chemical_ID": "921",
                     "Stuff_Bat": "N/A",
                     "NewRecipe": "1,00000"
                 },
                 {
                     "Chemical_Name": "DM-1573A",
                     "Chemical_ID": "811",
                     "Stuff_Bat": "N/A",
                     "NewRecipe": "0,50000"
                 }
                 ]
}*/
#import <Foundation/Foundation.h>


@interface BAI_Atrb_ArtInfo : NSObject
{
    // 前处理工艺号
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






@interface BAI_Atrb_ChemicalInfo : NSObject
{
    //化工料名称 
    NSString *Chemical_Name;
    //化工料ID
    NSString *Chemical_ID;
    //:化工料批(暂时不用)
    NSString *Stuff_Bat;
    //化工料名称
    NSString *NewRecipe;
    
}

@property(nonatomic,retain)NSString *Chemical_Name;
@property(nonatomic,retain)NSString *Chemical_ID;
@property(nonatomic,retain)NSString *Stuff_Bat;
@property(nonatomic,retain)NSString *NewRecipe;

@end







//data for ui 
@interface BAI_UIData : NSObject
{
    NSString *NA2SO4;
    NSString *NA2CO3;
    NSString *keepWarnTime;
}
@property(nonatomic,retain) NSString *NA2SO4;
@property(nonatomic,retain) NSString *NA2CO3;
@property(nonatomic,retain) NSString *keepWarnTime;


@end







@interface BulkAuxiliariesInfo : NSObject
{
    @private
    ////数组元素：BAI_Atrb_ArtInfo
    NSArray * ArtInfoAry;
    ////数组元素：BAI_Atrb_ChemicalInfo
    @private
    NSArray * ChemicalInfoAry;
    
    // data struct for ui show
    BAI_UIData *baiUIData;

}

//数组元素：BAI_Atrb_ArtInfo
@property(nonatomic,retain)NSArray * ArtInfoAry;
//数组元素：BAI_Atrb_ChemicalInfo
@property(nonatomic,retain)NSArray * ChemicalInfoAry;
@property(nonatomic,retain)BAI_UIData *baiUIData;
-(BAI_UIData *)getBAIUIData;



@end
