//
//  YDPostNotificationName.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

NSString *const YDLabColorAddGroupNotification = @"YDLabColorAddNewGroup" ;
NSString *const YDLabPalettesAddRecipeNotification = @"YDLabPalettesAddNewRecipe";
NSString *const YDLabPalettesRemoveRecipeNotification = @"YDLabPalettesRemoveNewRecipe";

NSString *const YDBulkPalettesAddRecipeNotification = @"YDBulkPalettesAddRecipe";
NSString *const YDBulkPalettesRemoveRecipeNotification = @"YDBulkPalettesRemoveRecipe";
NSString *const YDBulkAddictionAddRecipeNotification = @"YDBulkAddictionAddRecipe";
NSString *const YDBulkAddictionRemoveRecipeNotification = @"YDBulkAddictionRemoveRecipe";

NSString *const YDBulkTabAddSelectedRecipeNotification = @"YDBulkTabAddSelectedRecipe";
NSString *const YDBulkTabCancelSelectedRecipeNotification = @"YDBulkTabCancleSelectedRecipe";

NSString *const YDLabTabColorNameNotification = @"YDLabTabColorNameWithRecipe";

//回修
NSString *const YDBulkRemodifyKey = @"YDBulkRemodifyKey";

NSString *const YDLabColorNewGroupKey = @"YDLabColorCreateNewGroupKey";

NSString *const YDLabColorGroupIdKey  = @"YDLabColorGroupId";

NSString *const YDLabColorChemicalIdKey = @"YDLabColorChemicalId";

NSString *const YDLabColorUsageKey = @"YDLabColorChemicalUsage";


NSString *const YDColorGroupYellowKey = @"yellowChemical";

NSString *const YDColorGroupRedKey = @"RedChemical";

NSString *const YDColorGroupBlueKey = @"BlueChemical";

//新配方中新的使用量
NSString *const YDNewRecipeNewUsageKey = @"YDNewRecipeNewUsages";
//旧配方中旧的使用量
NSString *const YDNewRecipeOldUsageKey = @"YDNewRecipeOldUsage";
//新配方的辅助工艺值
 NSString *const YDNewRecipeArtworkKey = @"YDNewRecipeArtwork";

//原来配方的值
NSString  *const YDNewAndOldUsageKey = @"YDNewAndOldUsageKey";


//色级的key
NSString *const YDLabTabColorNameKey = @"YDLabTabColorNameKey";

//被标记的配方的值的key
NSString *const YDLabTabColorRecipeValueKey  = @"YDLabTabColorRecipeValueKey";

//标记为回修或者正常小样OK方的名字
//正常或者回修
 NSString *const YDBulkTabRecipeOKNameKey = @"YDBulkTabRecipeOKorModifyNameKey";

//在bulk用户中被标记的配方的来源配方，用于更改原配方的背景以及状态
NSString *const YDBulkTabOriginalRecipeKey = @"YDBulkTabOriginalRecipeViewKeys";
