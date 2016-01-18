//
//  BatchTraceInfo.m
//  YiDa
//
//  Created by meson on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BatchTraceInfo.h"










@implementation BatchTraceInfo
@synthesize
Batch_NO,
Color_Code,
Machine_Model,
Machine_ID,
Yarn_Type,
Yarn_Count,
Weight,
Recipe_OK_Time,
Dye_Time,
Check_Time,
Send_QC_Time,
QC_Time,
First_Dye_Time,
Remark,
Art_Comment,
Finish_Time;



-(void)dealloc
{
   
    CARelease(Batch_NO);
    CARelease(Color_Code);
    CARelease(Machine_Model);
    CARelease(Machine_ID);
    CARelease(Yarn_Type);
    CARelease(Yarn_Count);
    CARelease(Weight);
    CARelease(Recipe_OK_Time);
    CARelease(Dye_Time);
    CARelease(Check_Time);
    CARelease(Send_QC_Time);
    CARelease(QC_Time);
    CARelease(First_Dye_Time);
    CARelease(Remark);
    CARelease(Art_Comment);
    CARelease(Finish_Time);

    
    [super dealloc];
}
@end
