//
//  BulkAuxiliariesInfo.m
//  YiDa
//
//  Created by meson on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BulkAuxiliariesInfo.h"


@implementation BAI_Atrb_ArtInfo
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



@implementation BAI_Atrb_ChemicalInfo
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


@implementation BAI_UIData
@synthesize NA2CO3,NA2SO4,keepWarnTime;


- (id)copyWithZone:(NSZone *)zone
{
    BAI_UIData *group = [BAI_UIData allocWithZone:zone];
    group.keepWarnTime = self.keepWarnTime;
    group.NA2CO3 = self.NA2CO3;
    group.NA2SO4 = self.NA2SO4;
    return group;
}

-(void)dealloc
{   

    CARelease(NA2SO4);
    CARelease(NA2CO3);
    CARelease(keepWarnTime);
    
    [super dealloc];
}
@end




@implementation BulkAuxiliariesInfo
@synthesize ArtInfoAry,ChemicalInfoAry,baiUIData;



-(BAI_UIData *)getBAIUIData;
{
    
    BAI_UIData *buData=[[[BAI_UIData alloc]init]autorelease];
    if (ArtInfoAry.count==1&&ChemicalInfoAry!=nil) {
        
        BAI_Atrb_ArtInfo *laaInfo=[ArtInfoAry objectAtIndex:0];
        buData.keepWarnTime=laaInfo.KeepTime;
        int count=ChemicalInfoAry.count;
        for (int i=0; i<count; i++) {
            BAI_Atrb_ChemicalInfo *laChInf= [ChemicalInfoAry objectAtIndex:i];
            if ([laChInf.Chemical_Name isEqualToString:@"NA2SO4"]||[laChInf.Chemical_Name isEqualToString:@"Na2SO4"]) {
                buData.NA2SO4=laChInf.NewRecipe;
            }
            if ([laChInf.Chemical_Name isEqualToString:@"NA2CO3"]) {
                buData.NA2CO3=laChInf.NewRecipe;
            }
        }
        
        
    }
    
    
    
    return buData;
    

    
}

-(void)dealloc
{

    CARelease(ArtInfoAry);
    CARelease(ChemicalInfoAry);
    CARelease(baiUIData);
    [super dealloc];
}
@end
