//
//  BestGroupInfoData.h
//  YiDa
//
//  Created by meson on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGI_Atr_BestGroupInfo : NSObject
{
  //组合ID
   NSString *Group_ID;
  //化工料ID
   NSString *Chemical_ID;
  //化工料名称
   NSString *Chemical_Name;
}
@property(nonatomic,retain)NSString *Group_ID;
@property(nonatomic,retain)NSString *Chemical_ID;
@property(nonatomic,retain)NSString *Chemical_Name;


@end

@interface BestGroupInfo : NSObject
{
 @protected
    //元素：BGI_Atr_BestGroupInfo 
    NSArray *bestGroupInfoAry;
    
}
@property(nonatomic,retain) NSArray *bestGroupInfoAry;

//Group_ID 相同的一个组合，作为数组元素
-(NSArray *)getOneGroup;

@end