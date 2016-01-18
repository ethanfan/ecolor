//
//  TotalProgressInfo.m
//  YiDa
//
//  Created by meson on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TotalProgressInfo.h"

@implementation TotalProgressInfo

@synthesize 
Final_LB_Delivery_Date,
Warp_Weft,
Machine_Model,
Machine_ID,
Batch_NO,
Color_Code,
Ratio,
Recipe_OK_Time,
Dye_Time,
Put_Dye_Weight,
Cone_Num,
Check_Time,
Check_Result,
GF_NO,
Yarn_Lot,
QC_Time,
QC_Result,
Iden;


-(void)dealloc
{
    CARelease(Final_LB_Delivery_Date);
    CARelease(Warp_Weft);
    CARelease(Machine_Model);
    CARelease(Machine_ID);
    CARelease(Batch_NO);
    CARelease(Color_Code);
    CARelease(Ratio);
    CARelease(Recipe_OK_Time);
    CARelease(Dye_Time);
    CARelease(Put_Dye_Weight);
    CARelease(Cone_Num);
    CARelease(Check_Time);
    CARelease(Check_Result);
    CARelease(GF_NO);
    CARelease(Yarn_Lot);
    CARelease(QC_Time);
    CARelease(QC_Result);
    CARelease(Iden);
    
    
    [super dealloc];
}


@end
