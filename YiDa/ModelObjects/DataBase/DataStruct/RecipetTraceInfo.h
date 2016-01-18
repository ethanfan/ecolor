//
//  GetRecipetTraceInfo.h
//  YiDa
//
//  Created by meson on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//RecipeTrace key and value
/*
 "Recipe_NO": "R907130598",
 "Batch_NO": "C9071792",
 "Receive_Time": "",
 "Final_LB_Delivery_Date": "",
 "Color_Code": "40YW23388",
 "Ratio": "10,00",
 "Art_NO": "EP02-ED12-60-EA02",
 "planyarn": "",
 "PlanYarnLot": "",
 "Yarn_Lot": "",
 "Handle_Time": "13/07/2009 08:58:00",
 "Worker_ID": "严慧霞",
 "Suck_Plan_Date": "",
 "Suck_Worker": "",
 "Operate_Date": "",
 "Operator": "",
 "Dye_Time": "",
 "Dye_Opertor": "",
 "Add_alkali_Time": "",
 "Add_Alkali_Opertor": "",
 "Out_Time": "",
 "Out_Opertor": "",
 "Send_Sample_Time": "",
 "Send_Sample_Opertor": "",
 "Receive_Sample_Time": "",
 "Receive_Toner": "",
 "Recipe_Recorder": "Xiong, Yan Yun",
 "Send_Toner": "-",
 "Remark": "源配方:R907120574,复板纱:,纱重:5         ,来样单:,打样机台: ,配方类型:YD一次OK大货配方,吸料机台:,开单备注:/前处理复板,吸料组号:          ,小样工艺:,颜色评语:,跟踪备注: ",
 "Delat_Value": ""
 
 */


//ChemicalInfo key and value
/*
"Chemical_Name": "2518固色剂",
"Chemical_ID": "921",
"Unit_Usage": "1",
"Unit": "%"*/

@interface RTI_atb_RecipeTrace :NSObject 
{
    
  
    //配方号
    NSString * Recipe_NO;
    //缸号
    NSString * Batch_NO;
    // 接受计划
    NSString * Receive_Time;
    //复版交期
    NSString * Final_LB_Delivery_Date;
    //色号
    NSString * Color_Code;
    //浴比
    NSString * Ratio;
    //工艺号
    NSString * Art_NO;
    //计划纱支
    NSString * planyarn;
    //计划纱批
    NSString * PlanYarnLot;
    //复版纱支
    NSString * Yarn_Lot;
    NSString * Handle_Time;
    NSString * Worker_ID;
    NSString * Suck_Plan_Date;
    NSString * Suck_Worker;
    NSString * Operate_Date;
    NSString * Operator;
    NSString * Dye_Time;
    NSString * Dye_Opertor;
    NSString * Add_alkali_Time;
    NSString * Add_Alkali_Opertor;
    NSString * Out_Time;
    NSString * Out_Opertor;
    NSString * Send_Sample_Time;
    NSString * Send_Sample_Opertor;
    NSString * Receive_Sample_Time;
    NSString * Receive_Toner;
    NSString * Recipe_Recorder;
    NSString * Send_Toner;
    NSString * Remark;
    NSString * Delat_Value;
}


@property(nonatomic,retain)NSString *Recipe_NO;
@property(nonatomic,retain)NSString *Batch_NO;
@property(nonatomic,retain)NSString *Receive_Time;
@property(nonatomic,retain)NSString *Final_LB_Delivery_Date;
@property(nonatomic,retain)NSString *Color_Code;
@property(nonatomic,retain)NSString * Ratio;
@property(nonatomic,retain)NSString * Art_NO;
@property(nonatomic,retain)NSString * planyarn;
@property(nonatomic,retain)NSString * PlanYarnLot;
@property(nonatomic,retain)NSString * Yarn_Lot;
@property(nonatomic,retain)NSString * Handle_Time;
@property(nonatomic,retain)NSString * Worker_ID;
@property(nonatomic,retain)NSString * Suck_Plan_Date;
@property(nonatomic,retain)NSString * Suck_Worker;
@property(nonatomic,retain)NSString * Operate_Date;
@property(nonatomic,retain)NSString * Operator;
@property(nonatomic,retain)NSString * Dye_Time;
@property(nonatomic,retain)NSString * Dye_Opertor;
@property(nonatomic,retain)NSString * Add_alkali_Time;
@property(nonatomic,retain)NSString * Add_Alkali_Opertor;
@property(nonatomic,retain)NSString * Out_Time;
@property(nonatomic,retain)NSString * Out_Opertor;
@property(nonatomic,retain)NSString * Send_Sample_Time;
@property(nonatomic,retain)NSString * Send_Sample_Opertor;
@property(nonatomic,retain)NSString * Receive_Sample_Time;
@property(nonatomic,retain)NSString * Receive_Toner;
@property(nonatomic,retain)NSString * Recipe_Recorder;
@property(nonatomic,retain)NSString * Send_Toner;
@property(nonatomic,retain)NSString * Remark;
@property(nonatomic,retain)NSString * Delat_Value;

@end


@interface RTI_atb_ChemicalInfo :NSObject 
{
    NSString * Chemical_Name;
    NSString * Chemical_ID;
    NSString * Unit_Usage;
    NSString * Unit;
}
@property(nonatomic,retain)NSString * Chemical_Name;
@property(nonatomic,retain)NSString * Chemical_ID;
@property(nonatomic,retain)NSString * Unit_Usage;
@property(nonatomic,retain)NSString * Unit;
@end



@interface RecipetTraceInfo : NSObject


//数组元素：RTI_atb_RecipeTrace
@property(nonatomic,retain)NSArray * RecipeTraceAry;
//数组元素：RTI_atb_ChemicalInfo
@property(nonatomic,retain)NSArray * ChemicalInfoAry;

@end
