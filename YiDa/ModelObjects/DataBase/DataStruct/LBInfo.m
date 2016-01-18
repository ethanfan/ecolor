//
//  LBInfoData.m
//  YiDa
//
//  Created by meson on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LBInfo.h"

@implementation LBInfo
@synthesize     Customer,
Light,
FWeight,
WWeight,
Weight,
RGB,
Delivery_Date,
Color_Remarks,
FinishList,
FinishMethod;

-(void)dealloc
{
    CARelease(Customer);
    CARelease(Light);
    CARelease(FWeight);
    CARelease(WWeight);
    CARelease(Weight);
    CARelease(RGB);
    CARelease(Delivery_Date);
    CARelease(Color_Remarks);
    CARelease(FinishList);
    CARelease(FinishMethod);
    
    [super dealloc];
}
@end
