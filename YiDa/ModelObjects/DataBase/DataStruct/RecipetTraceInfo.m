//
//  GetRecipetTraceInfo.m
//  YiDa
//
//  Created by meson on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecipetTraceInfo.h"


@implementation RTI_atb_RecipeTrace
@synthesize     Recipe_NO,
Batch_NO,
Receive_Time,
Final_LB_Delivery_Date,
Color_Code,
Ratio,
Art_NO,
planyarn,
PlanYarnLot,
Yarn_Lot,
Handle_Time,
Worker_ID,
Suck_Plan_Date,
Suck_Worker,
Operate_Date,
Operator,
Dye_Time,
Dye_Opertor,
Add_alkali_Time,
Add_Alkali_Opertor,
Out_Time,
Out_Opertor,
Send_Sample_Time,
Send_Sample_Opertor,
Receive_Sample_Time,
Receive_Toner,
Recipe_Recorder,
Send_Toner,
Remark,
Delat_Value;

-(void)dealloc
{
       CARelease(Recipe_NO);
       CARelease(Batch_NO);
       CARelease(Receive_Time);
       CARelease(Final_LB_Delivery_Date);
       CARelease(Color_Code);
       CARelease(Ratio);
       CARelease(Art_NO);
       CARelease(planyarn);
       CARelease(PlanYarnLot);
       CARelease(Yarn_Lot);
       CARelease(Handle_Time);
       CARelease(Worker_ID);
       CARelease(Suck_Plan_Date);
       CARelease(Suck_Worker);
       CARelease(Operate_Date);
       CARelease(Operator);
       CARelease(Dye_Time);
       CARelease(Dye_Opertor);
       CARelease(Add_alkali_Time);
       CARelease(Add_Alkali_Opertor);
       CARelease(Out_Time);
       CARelease(Out_Opertor);
       CARelease(Send_Sample_Time);
       CARelease(Send_Sample_Opertor);
       CARelease(Receive_Sample_Time);
       CARelease(Receive_Toner);
       CARelease(Recipe_Recorder);
       CARelease(Send_Toner);
       CARelease(Remark);
       CARelease(Delat_Value);
    [super dealloc];
}
@end


@implementation RTI_atb_ChemicalInfo
@synthesize Chemical_ID,Chemical_Name,Unit_Usage,Unit;

-(void)dealloc
{
   
   CARelease(Chemical_Name);
   CARelease(Chemical_ID);
   CARelease(Unit_Usage);
   CARelease(Unit);
    
    [super dealloc];
}

@end







@implementation RecipetTraceInfo
@synthesize RecipeTraceAry,ChemicalInfoAry;
-(void)dealloc
{
    CARelease(RecipeTraceAry);
    CARelease(ChemicalInfoAry);
    
    [super dealloc];
}
@end
