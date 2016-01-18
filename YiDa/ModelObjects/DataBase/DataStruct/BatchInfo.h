//
//  GetBatchInfo.h
//  YiDa
//
//  Created by meson on 12-11-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BatchInfo : NSObject
{

   //品名列表
   NSString * GF_NO;
    //色号 
   NSString * Color_Code;
    //纱支类型
   NSString * Yarn_Type;
    //纱支
   NSString * Yarn_Count;
    //纱批
   NSString * Yarn_Lot;
    //经纱重
   NSString * WWeight;
    //纬纱重
   NSString * FWeight;
    //颜色值
   NSString * RGB;
    //缸型
   NSString * Machine_Model;
    //纯碱 
   NSString * Na2Co3;
    //元明粉
   NSString * Ns2So4;
    //浴比
   NSString * Ratio;
   NSString * FinishMethod;
   NSString * Customer;
   NSString * Delivery_Date;
   NSString * Batch_Delivery_Date;
   NSString * Remark;
   NSString * QAHints;
   NSString * Hints;
    
//    增加重量和复板交期（Final_LB_Delivery_Date）
//    BY Lizhang Dong 2013-01-08
    NSString *Weight;
    NSString *Final_LB_Delivery_Date;

}

@property(nonatomic,retain)NSString * GF_NO;
@property(nonatomic,retain)NSString * Color_Code;
@property(nonatomic,retain)NSString * Yarn_Type;
@property(nonatomic,retain)NSString * Yarn_Count;
@property(nonatomic,retain)NSString * Yarn_Lot;
@property(nonatomic,retain)NSString * WWeight;
@property(nonatomic,retain)NSString * FWeight;
@property(nonatomic,retain)NSString * RGB;
@property(nonatomic,retain)NSString * Machine_Model;
@property(nonatomic,retain)NSString * Na2Co3;
@property(nonatomic,retain)NSString * Ns2So4;
@property(nonatomic,retain)NSString * Ratio;
@property(nonatomic,retain)NSString * FinishMethod;
@property(nonatomic,retain)NSString * Customer;
@property(nonatomic,retain)NSString * Delivery_Date;
@property(nonatomic,retain)NSString * Batch_Delivery_Date;
@property(nonatomic,retain)NSString * Remark;
@property(nonatomic,retain)NSString * QAHints;
@property(nonatomic,retain)NSString * Hints;
@property (nonatomic ,copy) NSString *Weight;
@property (nonatomic ,copy) NSString *Final_LB_Delivery_Date;

@end
