//
//  ChemicalInfo.m
//  YiDa
//
//  Created by meson on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChemicalInfo.h"


@implementation CI_Atrb_GroupInfo
@synthesize GroupID;

-(void)dealloc
{
    CARelease(GroupID);
    [super dealloc];
}

@end



@implementation CI_Atrb_xriteItemNO

@synthesize xriteNO;


-(void)dealloc
{
    CARelease(xriteNO);
    [super dealloc];
}


@end




@implementation CI_Atrb_ChemicalInfo
@synthesize     Chemical_Name,
Chemical_ID,
Stuff_Bat,NewRecipe,rowItemAry,mutDic;

-(void)dealloc
{
    CARelease(Chemical_Name);
    CARelease(Chemical_ID);
    CARelease(NewRecipe);
    //CARelease(R210260040);
    //CARelease(R210253115);
    CARelease(rowItemAry);
    CARelease(mutDic);
    [super dealloc];
}

@end






@implementation ChemicalInfo
@synthesize groupInfoAry,chemicalInfoAry,group_Head,grouplistAry,xriteItemNO;


-(Group_Head *)getValueForGroup_Head
{
    Group_Head *grpHead=[[Group_Head alloc]autorelease];
    if (groupInfoAry!=nil&&groupInfoAry.count==1&&chemicalInfoAry!=nil) {
        CI_Atrb_GroupInfo *cIAtrbGroupInfo=[groupInfoAry objectAtIndex:0];
        grpHead.titleName=cIAtrbGroupInfo.GroupID;
        int count=chemicalInfoAry.count;
        NSMutableArray *myValueAry=[[[NSMutableArray alloc]initWithCapacity:5]autorelease];
        grpHead.valueAry=myValueAry;
     
        for (int i=0; i<count; i++) {
            CI_Atrb_ChemicalInfo *cci=[chemicalInfoAry objectAtIndex:i];
            NSString *chlName=cci.Chemical_Name;
            [grpHead.valueAry addObject:chlName]; 
        }
    }
    NSLog(@"group_Head11 %@  titleName :%@ ",grpHead.valueAry,grpHead.titleName );
    return grpHead;
}

-(NSArray *)getValueListForGroup_List
{
    NSMutableArray *grpListAry=[[[NSMutableArray alloc]initWithCapacity:5]autorelease];
    if (groupInfoAry!=nil&&chemicalInfoAry!=nil&&chemicalInfoAry.count!=0) {
       
        // 方块元素个数
        int count=chemicalInfoAry.count;
        CI_Atrb_ChemicalInfo *cciT=[chemicalInfoAry objectAtIndex:0];
        
        // 方块个数

        NSArray *dicAllkey=[cciT.mutDic allKeys];
        NSLog(@"dicAllKey  %@",dicAllkey);

        int cloCont= dicAllkey.count;
        NSMutableArray *myDicAllkey=nil;
        if ([dicAllkey containsObject:@"NewRecipe"]) {
            myDicAllkey=[NSMutableArray arrayWithCapacity:4];

            [myDicAllkey addObject:@"NewRecipe"];
            for (int t=0; t<cloCont; t++) {
                NSString *keyStirng=[dicAllkey objectAtIndex:t];
                if (![keyStirng isEqualToString:@"NewRecipe"]) {
                    [myDicAllkey addObject:keyStirng];
                }
            }
            
        }else {
            myDicAllkey= [NSMutableArray arrayWithArray:dicAllkey];
        }
        
        NSLog(@"myDicAllkey %@",myDicAllkey);
        //多少个key 多少个方块
        for (int i=0; i<cloCont; i++) {
            //一个方块
            Group_List *grpList=[[Group_List alloc]autorelease];
            //grpList.titleName==NewRecipe的时候是新建的那个元素没有顺序这里
            grpList.titleName=[myDicAllkey objectAtIndex:i]; 
        
            grpList.valueAry=[NSMutableArray arrayWithCapacity:5];
          
            //这里是、有三个key  R210260040 NewRecipe  R210253115
            
            for (int j=0; j<count; j++) {
               CI_Atrb_ChemicalInfo *cIAtrbChemicalInfo=[chemicalInfoAry objectAtIndex:j];
               NSString *valuString=[cIAtrbChemicalInfo.mutDic objectForKey:grpList.titleName];
                [grpList.valueAry addObject:valuString];

            }
            NSLog(@"cIAtrbChemicalInfo valuString %@ ",grpList.valueAry);

            [grpListAry addObject:grpList];
        }
    }
    

    return [NSArray arrayWithArray:grpListAry];
}

-(void)dealloc
{
    CARelease(groupInfoAry);
    CARelease(chemicalInfoAry);
    CARelease(group_Head);
    CARelease(grouplistAry);
    CARelease(xriteItemNO);
    [super dealloc];
    
}
@end



@implementation Group_Head
@synthesize titleName,valueAry;


-(void)dealloc
{
    CARelease(titleName);
    CARelease(valueAry);
    [super dealloc];
}

@end






@implementation Group_List
@synthesize titleName,valueAry;

- (id)copyWithZone:(NSZone *)zone
{
    Group_List *group = [Group_List allocWithZone:zone];
    group.titleName = self.titleName;
    group.valueAry = self.valueAry;
    return group;
}

-(void)dealloc
{

    CARelease(titleName);
    CARelease(valueAry);
    [super dealloc];
}


@end
