//
//  LBInfoData.h
//  YiDa
//
//  Created by meson on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define CARelease(obj) {if(obj!=nil) {[obj release]; obj = nil; }}

@interface LBInfo: NSObject
{
    //客户
    NSString *Customer;
    //光源 
    NSString *Light;
    //经纱重
    NSString *FWeight;
    //纬纱重
    NSString *WWeight;
    //总重量
    NSString *Weight;
    //颜色值
    NSString *RGB;
    //交期
    NSString *Delivery_Date;
    //颜色评语
    NSString *Color_Remarks;
    //整理方式ID
    NSString *FinishList;
    //整理方式
    NSString *FinishMethod;
    
}
@property(nonatomic,retain) NSString *Customer;
@property(nonatomic,retain) NSString *Light;
@property(nonatomic,retain) NSString *FWeight;
@property(nonatomic,retain) NSString *WWeight;
@property(nonatomic,retain) NSString *Weight;
@property(nonatomic,retain) NSString *RGB;
@property(nonatomic,retain) NSString *Delivery_Date;
@property(nonatomic,retain) NSString *Color_Remarks;
@property(nonatomic,retain) NSString *FinishList;
@property(nonatomic,retain) NSString *FinishMethod;

@end
