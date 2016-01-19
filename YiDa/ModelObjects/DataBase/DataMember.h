//
//  DataMember.h
//  YiDa
//
//  Created by meson on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//process all the net interface.

#import "BulkAuxiliariesInfo.h"
#import "ChemicalInfo.h"
#import "LabAuxiliariesInfo.h"
#import "RecipetTraceInfo.h"
#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "DataKit.h"


#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}


@interface  NSString(DecodingXMLString)
- (NSString *)stringByDecodingXMLEntities;
@end




@interface DataMember : NSObject
{
    TBXML * tbxml;
}
@property(retain,nonatomic)TBXML * tbxml;

//NSString *PsearchOneElementWithName(NSString *_elementName ,NSString *_content); 


+(DataMember*)shareInstance;
//系统
////////////////////////////////////////////////////////////////////

//系统登录
//string LoginIn(string User_ID,string Password)
//**
//@返回值说明，类型:nsstring  类似值:LABDIP
//@statue: ok
//@解析模型：一
//@param: User_ID:用户名  Password: 密码
//@eg:[dataMemberHandle LoginIn:@"sunyan" password:@"1"];
//**
-(NSString *)LoginIn:(NSString *)User_ID password:(NSString *)Password;

//系统注销
//string LoginOut(string User_ID)
//**
//@返回值说明，类型:nsstring  类似值:OK 
//@解析模型：一
//**
-(NSString *)LoginOut:(NSString *)User_ID;


//-------------------------------------------------------------------
//LAB-DIP
//-------------------------------------------------------------------
//LAB-DIP 选料 
////////////////////////////////////////////////////////////////////
//获取步骤列表
//string GetStepList().
//**
//@返回值说明，类型:nsarry  类似值:{"Item_NO":"一步法"} {"Item_NO":"二步法"} 类似使用方法:[ary objectAtIndex:0] objectForKey:@"Item_NO"];
//@statue: error ,后台返回数据不标准，缺少分号。
//@解析模型:二
//@key:Item_NO
//ary element:dic;key : Item_NO , value : 一步法
//**
-(NSArray *)GetStepList;

//获取分类列表
//string GetTypeList()
//**
//@返回值说明，类型:nsarry  类似值:{"Item_NO":"活性"},{"Item_NO":"分散"} 类似使用方法:[ary objectAtIndex:0] objectForKey:@"Item_NO"];
//@statue: error ,后台返回数据不标准，缺少分号。
//@解析模型:二
//@key:Item_NO
//ary element:dic
//**
-(NSArray *)GetTypeList;

//获取色系列表
//string GetSimpleColorList()
-(NSArray *)GetSimpleColorList;

//获取深浅列表
//string GetColorDeepList()
-(NSArray *)GetColorDeepList;

//获取成本列表
//string GetCostList()
-(NSArray *)GetCostList;

//获取开单号列表
//string GetKDNOList("LB2012-2809")
//LB_NO: 来样编号
-(NSArray *)GetKDNOList:(NSString*)LB_NO;

//获取颜色列表
//string GetColorCodeList(string LB_NO,string KD_NO)
//LB_NO: 来样编号，KD_NO：开单号
-(NSArray *)GetColorCodeList:(NSString *)LB_NO KD_NO:(NSString *)KD_NO;

//获取来样单信息
////KDNO:来样编号
//string GetLBInfo(string LB_NO,string Color_Code)
//LB_NO: 来样编号，Color_Code：色号
-(LBInfo *)GetLBInfo:(NSString *)LB_NO Color_Code:(NSString *)Color_Code;

//获取最优的组合信息
//string GetBestGroupInfo(string Step,string Type,string Simple_Color,string Color_Deep,string Customer,string FinishList)
//Type：选料类型，Simple_Color: 色系,Color_Deep 色深，
-(NSArray *)GetBestGroupInfo:(NSString *)Type 
                Simple_Color:(NSString *)Simple_Color
                  Color_Deep:(NSString *)Color_Deep 
                    Customer:(NSString *)Customer
                  FinishList:(NSString *)FinishList;

//保存配方信息
//string SaveRecipeInfo(string LB_NO,string Color_Code,float Weight,string Customer,string User_ID,string Step,string ChemicalIDStr,string UsageStr)
//LB_NO:来样编号，Color_Code:色号，Weight: 重量，Customer:客户，User_ID: 调色师ID，Step: 选料步骤，ChemicalIDStr: 化工料ID,用英文豆号串起来，UsageStr:单位用量,用英文豆号串起来
-(NSString *)SaveRecipeInfo:(NSString *)LB_NO
                 Color_Code:(NSString *)Color_Code
                     Weight:(NSString *)Weight
                    User_ID:(NSString *)User_ID
                       Step:(NSString *)Step
                   Group_ID:(NSString *)Group_ID
              ChemicalIDStr:(NSString *)ChemicalIDStr
                   UsageStr:(NSString *)UsageStr;

/*
 新增一个接口在lab调方和bulk调方/加成的保存配方前调用，用作提示，所有的操作逻辑在服务器中进行操作
 _ChemicalIDStr:化工料ID,用英文豆号串起来
 _NewUsageStr:新的化料用量，用英文豆号串起来
 _OldUsageStr：最近一次的化料用量，用英文豆号串起来
*/

- (NSString *)CheckPercent:(NSString *)_ChemicalIDStr
               newUsageStr:(NSString *)_NewUsageStr
               oldUsageStr:(NSString *)_OldUsageStr;

/*
    新增一个接口用于在LAB用户组的选料和调方的保存配方前调用，用作于提示，如果返回有内容就提示，没有内容就不提示
    _LBNO： 开单号
    _colorCode :色号
    _chemicalIds:化工料ID,用英文豆号串起来
    _usagesStr : 单位用量,用英文豆号串起来
*/
- (NSString *)CheckIsNeedFixing:(NSString *)_LBNO
                      colorCode:(NSString *)_colorCode
                    chemicalStr:(NSString *)_chemicalIds
                       usageStr:(NSString *)_usagesStr;



//LAB-DIP 调方 
////////////////////////////////////////////////////////////////////


//获取色号的配方信息
//string GetChemicalInfo(string BatchNO_OR_ColorCode,int Type)
//BatchNO_OR_ColorCode:缸号或色号,Type:类型 0 获取色号调方信息,Type 有若干中0-3

//LAB-DIP调方 type==0  获取色号的配方信息 
//LAB-DIP标记OK方 type==1   获取色号的配方信息
//BULK调方中 type==3 获取缸的配方信息
//BULK标记OK方 type=4  获取缸的配方信息
-(ChemicalInfo *)GetChemicalInfo:(NSString *)BatchNO_OR_ColorCode Type:(NSString *)Type;

//计算助剂
//string GetLabAuxiliariesInfo(string ChemicalIDStr, string UsageStr)
//ChemicalIDStr: 化工料ID,用英文豆号串起来，UsageStr:新单位用量
-(LabAuxiliariesInfo *)GetLabAuxiliariesInfo:(NSString *)ChemicalIDStr UsageStr:(NSString *)UsageStr;


//保存LAB-DIP调方配方信息
//string SaveLabRecipeInfo(string Color_Code,string User_ID,string Recipe_NO,string Dye_Art_NO,int Keep_Temperature_Time，string ChemicalIDStr,string UsageStr,string StuffBatStr)
//  //LB_NO Color_Code Weight User_ID Recipe_NO NA2CO3 NA2SO4 Keep_Temperature_Time Group_ID ChemicalIDStr UsageStr OldUsageStr
-(NSString *)SaveLabRecipeInfo:(NSString *)LB_NO 
                    Color_Code:(NSString *)Color_Code
                        Weight:(NSString *)Weight
                       User_ID:(NSString *)User_ID 
                     Recipe_NO:(NSString *)Recipe_NO
                        NA2CO3:(NSString *)NA2CO3 
                        NA2SO4:(NSString *)NA2SO4 
         Keep_Temperature_Time:(NSString *)Keep_Temperature_Time 
                      Group_ID:(NSString *)Group_ID 
                 ChemicalIDStr:(NSString *)ChemicalIDStr 
                      UsageStr:(NSString *)UsageStr OldUsageStr:(NSString *)OldUsageStr;



//LAB-DIP 标记OK方
////////////////////////////////////////////////////////////////////
//标记OK方


//获取色号的配方信息
//string GetChemicalInfo(string BatchNO_OR_ColorCode,int Type)
//if Type==0 ==>类型 0 获取色号调方信息;if Type==1 ==>类型 1 获取色号标记OK方信息; 
//共用函数 GetChemicalInfo


//标记LAP-DIP OK方
//string CheckLabRecipeInfo(string RecipeNOStr,string GradeStr,string User_ID)
//Recipe_NO:配方号,User_ID: 调色师ID
-(NSString *)CheckLabRecipeInfo:(NSString *)RecipeNOStr GradeStr:(NSString *)GradeStr User_ID:(NSString *)User_ID;




//LAB-DIP 查询
////////////////////////////////////////////////////////////////////
//配方列表

//string GetRecipeNOList(string BatchNO_OR_ColorCode
//BatchNO_OR_ColorCode;缸号或色号
-(NSArray *)GetRecipeNOList:(NSString *)BatchNO_OR_ColorCode;


//配方进度查询.
//string GetRecipetTraceInfo(string GetRecipetTraceInfo)
-(RecipetTraceInfo *) GetRecipetTraceInfo:(NSString *)Recipe_NO;










//-------------------------------------------------------------------
//BULK
//-------------------------------------------------------------------

//BULK 调方 
////////////////////////////////////////////////////////////////////
//获取缸的信息
//string GetBatchInfo(string Batch_NO)
//Batch_NO;缸号
-(NSArray *)GetBatchInfo:(NSString *)Batch_NO;

//获取缸的配方信息
//string GetChemicalInfo(string BatchNO_OR_ColorCode,int Type)
//备注，这个函数 和和上面的一样 只是 type＝＝3



//计算助剂
//string GetBulkAuxiliariesInfo (string xriteNO,string Batch_NO,string FirstDyeCotton, string ChemicalIDStr, string UsageStr)
//ChemicalIDStr: 化工料ID,用英文豆号串起来，UsageStr:新单位用量
-(BulkAuxiliariesInfo *)GetBulkAuxiliariesInfostring:(NSString *)xriteNO
                                            Batch_NO:(NSString *)Batch_NO 
                                      FirstDyeCotton:(NSString *)FirstDyeCotton
                                       ChemicalIDStr:(NSString *)ChemicalIDStr
                                            UsageStr:(NSString *)UsageStr;

#pragma mark---
#pragma mark SaveLog 保存日志信息
#pragma mark--
//requestMethod->要调用的接口名，requestTime->请求时间，responseTime->响应时间，runTime->逻辑处理时间
-(void)SaveLog:(NSString *)requestMethod
   requestTime:(NSDate *)requestTime
  responseTime:(NSDate *)responseTime
       runTime:(NSDate *)runTime;

//保存Bulk调方配方信息
//string SaveBulkRecipeInfo(int Repair,string xriteNO,int FirstDyeCotton,string Batch_NO, string User_ID, string Recipe_NO, double NA2CO3, double NA2SO4, int Keep_Temperature_Time, string Group_ID, string ChemicalIDStr, string UsageStr, string OldUsageStr)

-(NSString *)SaveBulkRecipeInfo:(NSString *)Repair 
                        xriteNO:(NSString *)xriteNO 
                 FirstDyeCotton:(NSString *)FirstDyeCotton
                       Batch_NO:(NSString *)Batch_NO 
                        User_ID:(NSString *)User_ID 
                      Recipe_NO:(NSString *)Recipe_NO 
                         NA2CO3:(NSString *)NA2CO3
                         NA2SO4:(NSString *)NA2SO4
          Keep_Temperature_Time:(NSString *)Keep_Temperature_Time 
                       Group_ID:(NSString *)Group_ID ChemicalIDStr:(NSString *)ChemicalIDStr 
                       UsageStr:(NSString *)UsageStr
                    OldUsageStr:(NSString *)OldUsageStr;


//Bulk 标记OK方
////////////////////////////////////////////////////////////////////



//获取缸的配方信息
//string GetChemicalInfo(string BatchNO_OR_ColorCode,int Type)
//备注，这个函数 和和上面的一样 只是 type＝＝3



//标记OK方
//string CheckBulkRecipeInfo(string Recipe_NO,string User_ID)
//
-(NSString *)CheckBulkRecipeInfo:(NSString *)RecipeNOStr GradeStr:(NSString *)GradeStr User_ID:(NSString *)User_ID;


//Bulk 加成
////////////////////////////////////////////////////////////////////




//获取缸的信息
//string GetBatchInfo(string Batch_NO)
//备注，这个函数 和和上面的一样 @end



//获取缸的配方信息
//string GetChemicalInfo(string BatchNO_OR_ColorCode,int Type)
//备注，这个函数 和和上面的一样 只是 type＝＝4


//保存Bulk加成配方信息
//string SaveBulkRecipeInfo(int Repair,string xriteNO,int FirstDyeCotton,string Batch_NO, string User_ID, string Recipe_NO, double NA2CO3, double NA2SO4, int Keep_Temperature_Time, string Group_ID, string ChemicalID

//-(NSString *)SaveBulkRecipeInfo:(NSString *)Repair xriteNO:(NSString *)xriteNO FirstDyeCotton:(NSString *)FirstDyeCotton Batch_NO:(NSString *)Batch_NO User_ID:(NSString *)User_ID Recipe_NO:(NSString *)Recipe_NO NA2CO3:(NSString *)NA2CO3 NA2SO4:(NSString *)NA2SO4 Keep_Temperature_Time:(NSString *)Keep_Temperature_Time Group_ID:(NSString *)Group_ID ChemicalIDStr:(NSString *)ChemicalIDStr UsageStr:(NSString *)UsageStr OldUsageStr:(NSString *)OldUsageStr;
//备注，这个函数 和和上面的一样 



//Bulk  查询
////////////////////////////////////////////////////////////////////

//进度跟踪查询
//string GetBatchTraceInfo(string Batch_NO)
-(NSArray*)GetBatchTraceInfo:(NSString *)Batch_NO;

//品种进度查询
//string GetTotalProgressInfo(string BatchNO_OR_GFNO)
//BatchNO_OR_GFNO;缸号或品名
-(NSArray *)GetTotalProgressInfo:(NSString *)BatchNO_OR_GFNO;


@end
