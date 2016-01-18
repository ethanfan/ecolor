//
//  TotalProgressInfo.h
//  YiDa
//
//  Created by meson on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TotalProgressInfo : NSObject
{
    
    NSString *Final_LB_Delivery_Date;//交板期,
    NSString *Warp_Weft;//经/纬
    NSString *Machine_Model;//缸型
    NSString *Machine_ID;//机台
    NSString *Batch_NO;//缸号
    NSString *Color_Code;//色号
    NSString *Ratio;//浴比
    NSString *Recipe_OK_Time;//复板OK时间
    NSString *Dye_Time;//投染时间
    NSString *Put_Dye_Weight;//投染量
    NSString *Cone_Num;//筒子数
    NSString *Check_Time;//内对色
    NSString *Check_Result;//对色结论,
    NSString *GF_NO;//品名
    NSString *Yarn_Lot;//纱批
    NSString *QC_Time;//QC时间
    NSString *QC_Result;//QC结论
    
    NSString *Iden;//右边的索引

}

@property(nonatomic,retain)NSString * Final_LB_Delivery_Date;
@property(nonatomic,retain)NSString * Warp_Weft;
@property(nonatomic,retain)NSString *Machine_Model;
@property(nonatomic,retain)NSString *Machine_ID;
@property(nonatomic,retain)NSString *Batch_NO;
@property(nonatomic,retain)NSString *Color_Code;
@property(nonatomic,retain)NSString *Ratio;
@property(nonatomic,retain)NSString *Recipe_OK_Time;
@property(nonatomic,retain)NSString *Dye_Time;
@property(nonatomic,retain)NSString *Put_Dye_Weight;
@property(nonatomic,retain)NSString *Cone_Num;
@property(nonatomic,retain)NSString *Check_Time;
@property(nonatomic,retain)NSString *Check_Result;
@property(nonatomic,retain)NSString *GF_NO;
@property(nonatomic,retain)NSString *Yarn_Lot;
@property(nonatomic,retain)NSString *QC_Time;
@property(nonatomic,retain)NSString *QC_Result;
@property(nonatomic,retain)NSString *Iden;




@end
