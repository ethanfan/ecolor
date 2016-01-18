//
//  BatchTraceInfo.h
//  YiDa
//
//  Created by meson on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface BatchTraceInfo : NSObject
{
    

     NSString * Batch_NO;//缸号
     NSString * Color_Code;//色号
     NSString * Machine_Model;//缸型
     NSString * Machine_ID;//机台
     NSString * Yarn_Type;//纱类
     NSString * Yarn_Count;//纱支
     NSString * Weight;//本缸重
     NSString * Recipe_OK_Time;//复板OK时间
     NSString * Dye_Time;//进缸时间
     NSString * Check_Time;//对色时间
     NSString * Send_QC_Time;//送QC时间
     NSString * QC_Time;//QCOK时间
     NSString * First_Dye_Time;//第一次进缸时间
     NSString * Remark;//备注
     NSString * Art_Comment;//工艺评审 
    NSString *Finish_Time;//出缸时间
     
    
    

}

@property(nonatomic,retain)NSString * Batch_NO;
@property(nonatomic,retain)NSString * Color_Code;
@property(nonatomic,retain)NSString * Machine_Model;
@property(nonatomic,retain)NSString * Machine_ID;
@property(nonatomic,retain)NSString * Yarn_Type;
@property(nonatomic,retain)NSString * Yarn_Count;
@property(nonatomic,retain)NSString * Weight;
@property(nonatomic,retain)NSString * Recipe_OK_Time;
@property(nonatomic,retain)NSString * Dye_Time;
@property(nonatomic,retain)NSString * Check_Time;
@property(nonatomic,retain)NSString * Send_QC_Time;
@property(nonatomic,retain)NSString * QC_Time;
@property(nonatomic,retain)NSString * First_Dye_Time;
@property(nonatomic,retain)NSString * Remark;
@property(nonatomic,retain)NSString * Art_Comment;
@property(nonatomic,retain)NSString *Finish_Time;


@end
