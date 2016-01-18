//
//  GetBatchInfo.m
//  YiDa
//
//  Created by meson on 12-11-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BatchInfo.h"

@implementation BatchInfo
@synthesize 
GF_NO,
Color_Code,
Yarn_Type,
Yarn_Count,
Yarn_Lot,
WWeight,
FWeight,
RGB,
Machine_Model,
Na2Co3,
Ns2So4,
Ratio,
FinishMethod,
Customer,
Delivery_Date,
Batch_Delivery_Date,
Remark,
QAHints,
Hints,
Weight,
Final_LB_Delivery_Date;

-(void)dealloc
{
    
      CARelease(GF_NO);
      CARelease(Color_Code);
      CARelease(Yarn_Type);
      CARelease(Yarn_Count);
      CARelease(Yarn_Lot);
      CARelease(WWeight);
      CARelease(FWeight);
      CARelease(RGB);
      CARelease(Machine_Model);
      CARelease(Na2Co3);
      CARelease(Ns2So4);
      CARelease(Ratio);
      CARelease(FinishMethod);
      CARelease(Customer);
      CARelease(Delivery_Date);
      CARelease(Batch_Delivery_Date);
      CARelease(Remark);
      CARelease(QAHints);
      CARelease(Hints);
    CARelease(Weight);
    CARelease(Final_LB_Delivery_Date);
    
    [super dealloc];
}


@end





