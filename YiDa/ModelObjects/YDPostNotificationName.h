

//Notification Name ***********************************/
//新增一个组合在lab用户的选料界面
UIKIT_EXTERN NSString *const YDLabColorAddGroupNotification ;
//新增一个配方在lab用户的调方界面
UIKIT_EXTERN NSString *const YDLabPalettesAddRecipeNotification;
//删除一个配方在lab用户的调方界面
UIKIT_EXTERN NSString *const YDLabPalettesRemoveRecipeNotification;
//新增一个配方在bulk的调方界面
UIKIT_EXTERN NSString *const YDBulkPalettesAddRecipeNotification;
//删除一个配方在bulk的调方界面
UIKIT_EXTERN NSString *const YDBulkPalettesRemoveRecipeNotification;
//新增/删除一个配方在bulk的加成界面
UIKIT_EXTERN NSString *const YDBulkAddictionAddRecipeNotification;
UIKIT_EXTERN NSString *const YDBulkAddictionRemoveRecipeNotification;
//标记一个配方在bulk的标记界面
UIKIT_EXTERN NSString *const YDBulkTabAddSelectedRecipeNotification;
//取消标记一个配方在bulk的标记界面
UIKIT_EXTERN NSString *const YDBulkTabCancelSelectedRecipeNotification;

//把配方标记到一个色级中去
UIKIT_EXTERN NSString *const YDLabTabColorNameNotification;


/********************************************************/

UIKIT_EXTERN NSString *const YDBulkRemodifyKey;

UIKIT_EXTERN NSString  *const YDNewAndOldUsageKey;

UIKIT_EXTERN NSString *const YDLabColorNewGroupKey;
//lab用户在选料中组合id的
UIKIT_EXTERN NSString *const YDLabColorGroupIdKey;
//lab用户在选料界面中化学材料的id
UIKIT_EXTERN NSString *const YDLabColorChemicalIdKey;
//lab用户在选料界面中新增组合的化学材料的使用量
UIKIT_EXTERN NSString *const YDLabColorUsageKey;

UIKIT_EXTERN NSString *const YDColorGroupYellowKey;

UIKIT_EXTERN NSString *const YDColorGroupRedKey;

UIKIT_EXTERN NSString *const YDColorGroupBlueKey;

//新配方中新的使用量
UIKIT_EXTERN NSString *const YDNewRecipeNewUsageKey;
//旧配方中旧的使用量
UIKIT_EXTERN NSString *const YDNewRecipeOldUsageKey;
//新配方的辅助工艺值
UIKIT_EXTERN NSString *const YDNewRecipeArtworkKey;

//色级的key
UIKIT_EXTERN NSString *const YDLabTabColorNameKey;

//被标记的配方的值的key
UIKIT_EXTERN NSString *const YDLabTabColorRecipeValueKey;

UIKIT_EXTERN NSString *const YDBulkTabRecipeOKNameKey;

UIKIT_EXTERN NSString *const YDBulkTabOriginalRecipeKey;

