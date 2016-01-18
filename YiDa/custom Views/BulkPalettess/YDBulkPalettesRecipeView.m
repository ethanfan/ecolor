//
//  YDBulkPalettesRecipeView.m
//  YiDa
//
//  Created by Meson Networks on 12-12-9.
//
//

#import "YDBulkPalettesRecipeView.h"
#import "YDNewRecipeModifyView.h"
#import "YDOldRecipeModifyView.h"

@interface YDBulkPalettesRecipeView ()

- (void)setBackgroundWithViewType:(YDBulkPalettesRecipeType)_viewType;

- (void)setUpButton:(YDBulkPalettesRecipeType )_viewType;

- (void)queryBulkAuxiliariesWith:(NSString *)xriteNO
                     withBatchNo:(NSString *)_batchNo
                  firstDyeCotton:(NSString *)_firstDyeCotton
                 withChemicalIds:(NSString *)_chemicalIds
                       withUsage:(NSString *)_usages;

- (void)queryBulkAuxiliariesWith:(NSString *)xriteNO
                     withBatchNo:(NSString *)_batchNo
                  firstDyeCotton:(NSString *)_firstDyeCotton
                 withChemicalIds:(NSString *)_chemicalIds
                       withUsage:(NSString *)_usages
                           block:(void (^)(BulkAuxiliariesInfo *))block;



@end

@implementation YDBulkPalettesRecipeView

@synthesize rato = rato_;
@synthesize batchNo = batchNo_;
@synthesize xriteNO = xriteNO_;
@synthesize firstDyeCotton = firstDyeCotton_;

@synthesize subViewType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame viewType:(YDBulkPalettesRecipeType )_viewType
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userType = YDUserTypeBulk;
        subViewType = _viewType;
        [self setBackgroundWithViewType:_viewType];
    }
    return self;
}

- (void)dealloc
{
    [rato_ release];rato_ = nil;
    [batchNo_ release];batchNo_ = nil;
    [xriteNO_ release];xriteNO_ = nil;
    [firstDyeCotton_ release];firstDyeCotton_ = nil;
    [super dealloc];
}
- (void)setBackgroundWithViewType:(YDBulkPalettesRecipeType)_viewType
{
    if (_viewType == YDBulkPalettesRecipeTypeNone)
    {
        [self setUpDeepBackgroundWith:YDPalettesRecipeTypeNone];
    }
    else if (_viewType == YDbulkPalettesRecipeOld || _viewType == YDBulkPalettesRecipeTypeNew)
    {
        if (_viewType == YDBulkPalettesRecipeTypeNew) selected = YES;
        [self setUpDeepBackgroundWith:YDPalettesOldRecipeType];
        [self setUpButton:_viewType];
    }
}
- (void)setUpButton:(YDBulkPalettesRecipeType )_viewType
{
    if (_viewType == YDbulkPalettesRecipeOld)
    {
        [self setUpSelectedButton];
    }
    else if (_viewType == YDBulkPalettesRecipeTypeNew)
    {
         [self setUpSelectedButton];
        [self setUpDeleteButton];
    }
}

- (void)didMoveToSuperview
{
    if (!self.superview) return;
    
    if (touchButton_ == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = recipeType_;
        [button setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y+30, self.bounds.size.width, self.bounds.size.height-30)];
        [button addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
        self.touchButton = button;
        [self addSubview:touchButton_];
        button = nil;
    }
	
    
//    [self setContentWith:recipeVale_];
    
//    if (recipeType_  == YDPalettesRecipeTypeNone)
//    {
//        [self setupNoneRecipeBackground];
//    }
    self.oldUsages = [self generateOldUsage:recipeVale_];
    
//    由服务器那边返回来的数据是没有新的用量的，因为新的用量是用户输入的，
//    根据这个去判定需不需要去查询计算助剂，因为如果是用户在新增或者修改原有配方生成新的配方的时候，这个值是存在的
    if (!self.usagesNew)
    {
        if (self.chemicalIds && self.oldUsages) {
            //            [self queryLabAuxiliariesWith:self.chemicalIds withUsage:self.oldUsages];
            /*
            [self queryBulkAuxiliariesWith:xriteNO_
                               withBatchNo:batchNo_
                            firstDyeCotton:firstDyeCotton_
                           withChemicalIds:self.chemicalIds
                                 withUsage:self.oldUsages];
            */
        }
    }
    
    self.selectedButton.selected = selected;
    [self setRecipeValueWith:recipeVale_];
}
#pragma mark ----------------
#pragma mark 设置配方值
- (void)setRecipeValueWith:(Group_List *)_recipeValue
{
    [super setRecipeValueWith:_recipeValue];
//    NSLog(@"fuck   %@  %@",_recipeValue.titleName,recipeVale_.valueAry);
    if (_recipeValue)
    {
        if (![_recipeValue.titleName isEqualToString:@"NewRecipe"])
        {
            UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(38, 5, 130, 30)];
            [label setFont:[UIFont systemFontOfSize:16]];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setAdjustsFontSizeToFitWidth:YES];
            [label setMinimumFontSize:10.0];
            [label setText:_recipeValue.titleName];
            if ([_recipeValue.titleName length])
            {
                NSString *f = [_recipeValue.titleName substringToIndex:1];
                if ([f isEqualToString:@"D"]) {
                    [label setTextColor:cklRed];
                }
                else if ([f isEqualToString:@"L"])
                {
                     [label setTextColor:cklFuchsia];
                }
                else if ([f isEqualToString:@"S"])
                {
                     [label setTextColor:cklMaroon];
                }
            }
            label.enabled = NO;
            [self addSubview:label];
            [label release];label = nil;
            
            
//            UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(320, 80+(15+30)*i, 150, 30)];
//            field.delegate = self;
//            field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//            [field setReturnKeyType:UIReturnKeyNext];
//            [field setBorderStyle:UITextBorderStyleLine];
//            [field setBackgroundColor:kGroupModifyColor];
        }
       
        //        NSLog(@"recipeTitle  %@",_recipeValue.titleName);
        NSMutableArray *values = _recipeValue.valueAry ;
        //        NSLog(@"YDPalettesRecipeView  values  -----%@",values);
        NSInteger count = [values count];
        for (int i = 0; i<count; i++)
        {
            UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(15, 50+(15 +30)*i, 147, 30)];
            [label setBackgroundColor:[UIColor clearColor]];
            label.enabled = NO;
            [label setTextAlignment:UITextAlignmentCenter];
            [label setFont:[UIFont systemFontOfSize:16]];
            [label setText:[values objectAtIndex:i]];
            [self addSubview:label];
            if (subViewType == YDBulkPalettesRecipeTypeNone) {
                [label setBorderStyle:UITextBorderStyleLine];
            }
            [label release];label = nil;
            
            
            

        }
    }
}

- (void)setUpSelectedButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(6, 5, 26, 26)];
	[button addTarget:self action:@selector(selectedButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = selected;
	[button setBackgroundImage:[UIImage imageNamed:@"BackgroundSelect.png"] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:@"BackgroundSelected.png"] forState:UIControlStateSelected];
	self.selectedButton = button;
	button = nil;
    [self addSubview:selectedButton_];

}
- (void)setUpDeleteButton
{
    	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(140, 5, 26, 26)];
	[button addTarget:self action:@selector(deleteButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = YES;
	[button setBackgroundImage:[UIImage imageNamed:@"BackgroundSelect.png"] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:@"BackgroundDeleteSelected.png"] forState:UIControlStateSelected];
	self.deleteButton = button;
	button = nil;
	
	
//	[self addSubview:selectedButton_];
	[self addSubview:deleteButton_];
}


- (void)selectedButtonPress:(UIButton *)_sender
{
    selected = _sender.selected = !_sender.selected;
    
    if (delegate != nil && [delegate respondsToSelector:@selector(palettesRecipe:didSelected:)])
    {
        [delegate palettesRecipe:self didSelected:selected];
    }
}

- (void)deleteButtonPress:(UIButton *)_sender
{
    selected = _sender.selected = !_sender.selected;
    if (delegate != nil && [delegate respondsToSelector:@selector(palettesRecipe:didRemove:)])
    {
        [delegate palettesRecipe:self didRemove:YES];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:YDBulkAddictionRemoveRecipeNotification object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:YDBulkPalettesRemoveRecipeNotification object:nil userInfo:nil];
    [self removeFromSuperview];
}

- (void)touchAction:(UIButton *)_sender
{
    if ( subViewType == YDBulkPalettesRecipeTypeNone ||subViewType == YDBulkPalettesRecipeTypeNew)
    {
        //新建配方
        YDNewRecipeModifyView *newRecipe = [[YDNewRecipeModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) userType:YDUserTypeBulk];
        newRecipe.recipeValues = self.recipeVale;
//        NSLog(@"")
        //            newRecipe.chemicalIds = self.chemicalIds;
        [newRecipe setValue:self.batchNo xriteNo:self.xriteNO firstDyeCotton:self.firstDyeCotton];
        newRecipe.chemicalIds = self.chemicalIds;
        newRecipe.addictives = additives_;
        newRecipe.rato = self.rato;
        [newRecipe show:YES];
        [newRecipe release];
    }
    else if (subViewType == YDbulkPalettesRecipeOld )
    {
        //修改历史配方
        YDOldRecipeModifyView *oldRecipe = [[YDOldRecipeModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) userType:YDUserTypeBulk];
        oldRecipe.recipeValue = recipeVale_;
        [oldRecipe setValue:self.batchNo xriteNo:self.xriteNO firstDyeCotton:self.firstDyeCotton];
        oldRecipe.addictives = additives_;
         oldRecipe.rato = self.rato;
        oldRecipe.chemicalIds = self.chemicalIds;
        [oldRecipe show:YES];
        [oldRecipe release];oldRecipe = nil;
    }
   
   
}

#pragma mark -----------
#pragma mark -------------- 查询计算助剂
//查询出来这些助剂，是为了当用户点击的时候不需要在去查询网络接口
- (void)queryBulkAuxiliariesWith:(NSString *)xriteNO
                     withBatchNo:(NSString *)_batchNo
                  firstDyeCotton:(NSString *)_firstDyeCotton
                 withChemicalIds:(NSString *)_chemicalIds
                       withUsage:(NSString *)_usages
{
    NSLog(@"bulk 获取计算助剂 xriteNO :%@ _batchNo :%@ _firstDyeCotton :%@ _chemicalIds :%@ _usages :%@",xriteNO,_batchNo,_firstDyeCotton,_chemicalIds,_usages);
    [self queryBulkAuxiliariesWith:xriteNO
                       withBatchNo:_batchNo
                    firstDyeCotton:_firstDyeCotton
                   withChemicalIds:_chemicalIds
                         withUsage:_usages
                             block:^(BulkAuxiliariesInfo *result){
//                                 self.addictives = result
                                 self.additives =[[[LAI_UIData alloc] init] autorelease];
                                 self.additives.keepWarnTime = result.baiUIData.keepWarnTime;
                                 self.additives.NA2CO3 = result.baiUIData.NA2CO3;
                                 self.additives.NA2SO4 = result.baiUIData.NA2SO4;
                                 
                                 
//                                 NSLog(@"resutl %@   count %d",result.ArtInfoAry,[result.ArtInfoAry count]);
//                                 for (id obj in result.ArtInfoAry)
//                                 {
//                                     BAI_Atrb_ArtInfo *art = (BAI_Atrb_ArtInfo *)obj;
//                                     NSLog(@"   %@   %@  %@  %@",art.PreArt,art.OWF,art.Remark,art.LaterArt);
//                                 }
                                 
    }];
}

- (void)queryBulkAuxiliariesWith:(NSString *)xriteNO
                     withBatchNo:(NSString *)_batchNo
                  firstDyeCotton:(NSString *)_firstDyeCotton
                 withChemicalIds:(NSString *)_chemicalIds
                       withUsage:(NSString *)_usages
                           block:(void (^)(BulkAuxiliariesInfo *))block
{
    
//    NSLog(@"xriteNo  %@  _batchNo  %@  _firstDyeCotton  %@  chemicalID %@  usages %@",xriteNO,_batchNo,_firstDyeCotton,_chemicalIds,_usages);
    
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    [self addSubview:loadingView];
    [loadingView release];
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_queue_t networkProcessQueue = dispatch_queue_create("netquery.palettes", NULL);
    dispatch_async(networkProcessQueue,^{
//        BulkAuxiliariesInfo *aux = [networkDataMemberHandle GetLabAuxiliariesInfo:_chemicalIds UsageStr:_usages];
        BulkAuxiliariesInfo*aux = [networkDataMemberHandle GetBulkAuxiliariesInfostring:xriteNO Batch_NO:_batchNo FirstDyeCotton:_firstDyeCotton ChemicalIDStr:_chemicalIds UsageStr:_usages];
        //        NSLog(@"aut.so4 %@ so3 %@ warnTime %@",aux.laiUIData.NA2SO4,aux.laiUIData.NA2CO3,aux.laiUIData.keepWarnTime);
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
//            NSLog(@"bulk用户组 获取计算助剂   。。。。。");
            //            NSLog(@"lab获取调方信息信息   。。。。GroupInfoAry.count。 %d  ChemicalInfoAry.count .%d",resutl.GroupInfoAry.count,resutl.ChemicalInfoAry.count);
            block(aux);
        });
        
    });
    
    dispatch_release(networkProcessQueue);
}

@end
