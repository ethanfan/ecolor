//
//  LabAuxiliariesInfo.m
//  YiDa
//
//  Created by meson on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LabAuxiliariesInfo.h"



@implementation LAI_Atrb_ArtInfo
@synthesize 
PreArt,
DyeArt,
KeepTime,
LaterArt,
OWF,
Remark;


-(void)dealloc
{
    
    CARelease(PreArt);
    CARelease(DyeArt);
    CARelease(KeepTime);
    CARelease(LaterArt);
    CARelease(OWF);
    CARelease(Remark);
    
    [super dealloc];
}
@end



@implementation LAI_Atrb_ChemicalInfo
@synthesize Chemical_ID,Chemical_Name,Stuff_Bat,NewRecipe;

-(void)dealloc
{
    CARelease(Chemical_ID);
    CARelease(Chemical_Name);
    CARelease(Stuff_Bat);
    CARelease(NewRecipe);
    
    [super dealloc];
}

@end






@implementation LAI_UIData
@synthesize keepWarnTime,NA2CO3,NA2SO4;

- (id)copyWithZone:(NSZone *)zone
{
    LAI_UIData *group = [LAI_UIData allocWithZone:zone];
    group.keepWarnTime = self.keepWarnTime;
    group.NA2CO3 = self.NA2CO3;
    group.NA2SO4 = self.NA2SO4;
    return group;
}

-(void)dealloc
{
    CARelease(keepWarnTime);
    CARelease(NA2SO4);
    CARelease(NA2CO3);
    [super dealloc];
}

@end


@implementation LabAuxiliariesInfo
@synthesize ArtInfoAry,ChemicalInfoAry;
@synthesize laiUIData=_laiUIData;


-(LAI_UIData *)getLAIUIData
{   
    LAI_UIData *luData=[[[LAI_UIData alloc]init]autorelease];
    if (ArtInfoAry.count==1&&ChemicalInfoAry!=nil) {
        
        LAI_Atrb_ArtInfo *laaInfo=[ArtInfoAry objectAtIndex:0];
        luData.keepWarnTime=laaInfo.KeepTime;
        int count=ChemicalInfoAry.count;
        for (int i=0; i<count; i++) {
            LAI_Atrb_ChemicalInfo *laChInf= [ChemicalInfoAry objectAtIndex:i];
//            if ([laChInf.Chemical_Name isEqualToString:@"NA2SO4"]) {
//            在外网连接时该值是:NA2SO4 内网连接时:是Na2SO4 ,现在修改为按内网为标准
//            by:Lizhang Dong 
            if ([laChInf.Chemical_Name isEqualToString:@"Na2SO4"]) {
                luData.NA2SO4=laChInf.NewRecipe;
            }
            if ([laChInf.Chemical_Name isEqualToString:@"NA2SO4"]) {
                luData.NA2SO4=laChInf.NewRecipe;
            }
            if ([laChInf.Chemical_Name isEqualToString:@"NA2CO3"]) {
                luData.NA2CO3=laChInf.NewRecipe;
            }
        }
        
        
    }
   
    return luData;
    
}
-(void)dealloc
{
    CARelease(ArtInfoAry);
    CARelease(ChemicalInfoAry);
    CARelease(laiUIData);
    [super dealloc];
}
@end

