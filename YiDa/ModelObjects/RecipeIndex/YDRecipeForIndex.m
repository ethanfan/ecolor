//
//  YDRecipeForIndex.m
//  YiDa
//
//  Created by 罗 祖根 on 12-12-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDRecipeForIndex.h"

@implementation YDRecipeForIndex

@synthesize remark = remark_,recipeNO = recipeNo_;

- (id)initWith:(NSDictionary *)_recipes
{
    self = [super init];
    if (self)
    {
        NSString *contents = [_recipes objectForKey:@"Item_NO"];
        if (contents)
        {
            NSArray *recipe = [contents componentsSeparatedByString:@"  "];
            if ([recipe count])
            {
                self.recipeNO = (NSString *)[recipe objectAtIndex:0];
                NSLog(@"recipNO %@",recipeNo_);
                if ([recipe count]>=2)
                {
                    self.remark = (NSString *)[recipe objectAtIndex:1];
                    NSLog(@"remark %@",remark_);
                }
            }
        }
    }
    return  self;
}

- (id)copyWithZone:(NSZone *)zone
{
    YDRecipeForIndex *recipeIndex = [YDRecipeForIndex allocWithZone:zone];
    recipeIndex.recipeNO = self.recipeNO;
    recipeIndex.remark = self.remark;
    return recipeIndex;
}

- (void)dealloc
{
    [recipeNo_ release];recipeNo_ = nil;
    [remark_ release];remark_ = nil;
    [super dealloc];
}

@end
