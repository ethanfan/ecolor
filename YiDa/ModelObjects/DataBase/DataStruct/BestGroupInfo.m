//
//  BestGroupInfoData.m
//  YiDa
//
//  Created by meson on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BestGroupInfo.h"

@implementation BGI_Atr_BestGroupInfo
@synthesize  Group_ID,Chemical_ID,Chemical_Name;

-(void)dealloc
{
    CARelease(Group_ID);
    CARelease(Chemical_ID);
    CARelease(Chemical_Name);
    [super dealloc];
}
@end


@implementation BestGroupInfo
@synthesize bestGroupInfoAry;



-(NSArray *)getOneGroup
{
    //为了保证安全 需要按照grpID 来排序。－－－－－
    
    //元素 是：grpIDAry
    NSMutableArray *grpAry=[NSMutableArray arrayWithCapacity:5];
    //元素 是：bestGroupInfoAry

    NSMutableArray *grpIDAry=[NSMutableArray arrayWithCapacity:5];

    if (self.bestGroupInfoAry!=nil&&self.bestGroupInfoAry.count!=0) {
        int count=self.bestGroupInfoAry.count;
        NSString *preID=nil;

        for (int i=0; i<count; i++) {
           BGI_Atr_BestGroupInfo *bab=[bestGroupInfoAry objectAtIndex:i];
            if (![preID isEqualToString:bab.Group_ID]) {
                    [grpIDAry addObject:bab.Group_ID];
                }
             preID=bab.Group_ID;
        }
        
        //NSLog(@"bab.Group_ID %@",grpIDAry);
        
        if (grpIDAry!=nil&&grpIDAry.count!=0) {
            int count1=grpIDAry.count;
            for (int i=0; i<count1; i++) {
                //一个grpid 相同的集合
                NSMutableArray *oneGrpAry=[NSMutableArray arrayWithCapacity:5];
                for (int j=0; j<count; j++) {
                    BGI_Atr_BestGroupInfo *bab=[bestGroupInfoAry objectAtIndex:j];
                    if ([[grpIDAry objectAtIndex:i] isEqualToString:bab.Group_ID]) {
                        [oneGrpAry addObject:bab];
                    }
                }
                //NSLog(@"oneGrpAry11 %@",oneGrpAry);
                [grpAry addObject:oneGrpAry];
            }

        }
        
        
    }
    
    return [NSArray arrayWithArray:grpAry];
}


-(void)dealloc
{

    CARelease(bestGroupInfoAry);
    [super dealloc];
}

@end