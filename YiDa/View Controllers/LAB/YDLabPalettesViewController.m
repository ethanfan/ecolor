//
//  YDLabPalettesViewController.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDLabPalettesViewController.h"
#import "YDPalettesGroupView.h"
#import "YDColorNumberSelectView.h"
#import "YDPalettesRecipeView.h"
#import "YDPostNotificationName.h"
#import "YDAppDelegate.h"

@interface YDLabPalettesViewController ()

- (void)setUpScrollView;
- (void)updateGroupScrollViewContent:(NSArray *)_recipeValue;

//重新排序配方的view ，刷新界面
//_operationType 操作的类型
//被操作的recipe在数组中的位置
- (void)reloadRecipeViewsInScrollViewWith:(YDRecipeViewOperationType )_operationType recipeIndex:(NSInteger )_index;

//回复到最初始的状态
- (void)recover2Original;

- (void)removeScrollViewSubvies;

- (NSString *)chemicalIdsWith:(NSArray *)_chemicalLis;

//新增和删除配方时的响应函数，只有新建的配方才有删除这个功能，并且只要一经output也不能删除了。
- (void)addNewRecipe:(NSNotification *)_notice;
- (void)removeNewRecipe:(NSNotification *)_notice;

- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type;

- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type result:(void(^)(ChemicalInfo *results))block;


- (void)outputSelectedRecipesWith:(NSString *)_LBNO 
                    withColorCode:(NSString *)_colorCode 
                       withWeight:(NSString *)_weight 
                       withUserId:(NSString *)_userId 
                         withRecipeNo:(NSString *)_recipeNo
                       WithNa2Co3:(NSString *)_Na2Co3 
                       withNa2So4:(NSString *)_Na2So4 
                     withWarnTime:(NSString *)_warnTime 
                      withGroupId:(NSString *)_groupId 
                  withChemicalIds:(NSString *)_chemicalIds 
                    withNewUsages:(NSString *)_newUsage 
                    withOldUsages:(NSString *)_oldUsages;

- (void)outputSelectedRecipesWith:(NSString *)_LBNO 
                    withColorCode:(NSString *)_colorCode 
                       withWeight:(NSString *)_weight 
                       withUserId:(NSString *)_userId 
                         withRecipeNo:(NSString *)_recipeNo
                       WithNa2Co3:(NSString *)_Na2Co3 
                       withNa2So4:(NSString *)_Na2So4 
                     withWarnTime:(NSString *)_warnTime 
                      withGroupId:(NSString *)_groupId 
                  withChemicalIds:(NSString *)_chemicalIds 
                    withNewUsages:(NSString *)_newUsage 
                    withOldUsages:(NSString *)_oldUsages 
                           result:(void(^)(NSString *))block;



@end

@implementation YDLabPalettesViewController

@synthesize  navigationBarImageView = navigationBarImageView_;
@synthesize  viewTypeImage = viewTypeImage_;
@synthesize  userImageView = userImageView_;
@synthesize  outputButton = outputButton_;
@synthesize  cancelButton = cancelButton_;
@synthesize  logoutButton = logoutButton_;
@synthesize backButton = backButton_;

@synthesize recipeScrollView = recipeScrollView_;
@synthesize colorView = colorView_;
@synthesize palettesGroupView = palettesGroupView_;

@synthesize colorCode = colorCode_,weight = weight_;
@synthesize scandedCode = scandedCode_;

@synthesize chemicalIds = chemicalIds_;
@synthesize groupId = groupId_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        recipeCount = 9;
        recipeCount = 0;
        recipeUnSelectCount = 0;
        recipeUnSelectCount = 0;
        newSelectedRecipesList = [[NSMutableArray arrayWithCapacity:0] retain];
        newUnSelectedRecipesList = [[NSMutableArray arrayWithCapacity:10] retain];
        networkProcessQueue = dispatch_queue_create("YDNetworkQueue.YDLabPalettesViewController", NULL);
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        recipeCount = 9;
        recipeCount = 0;
        recipeUnSelectCount = 0;
        recipeUnSelectCount = 0;
        newSelectedRecipesList = [[NSMutableArray arrayWithCapacity:0] retain];
        newUnSelectedRecipesList = [[NSMutableArray arrayWithCapacity:10] retain];
          networkProcessQueue = dispatch_queue_create("YDNetworkQueue.YDLabPalettesViewController", NULL);
        self.scandedCode = _scanedCode;
//        self.scandedCode = @"LB2012-2809";
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YDLabPalettesAddRecipeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YDLabPalettesRemoveRecipeNotification object:nil];
    
//    [self removeObserver:self forKeyPath:@"recipeCount"];
    
    [navigationBarImageView_ release];navigationBarImageView_ = nil;
    [viewTypeImage_ release];viewTypeImage_ = nil;
    [userImageView_ release];userImageView_ = nil;
    [outputButton_ release];outputButton_ = nil;
    [cancelButton_ release];cancelButton_= nil;
    [logoutButton_ release];logoutButton_ = nil;
    [backButton_ release];backButton_ = nil;
    
    [recipeScrollView_ release];recipeScrollView_ = nil;
	[colorView_ release];colorView_ = nil;
	[palettesGroupView_ release];palettesGroupView_ = nil;
    
    [scandedCode_ release];scandedCode_ = nil;
    [colorCode_ release];colorCode_ = nil;
    [weight_ release];weight_ = nil;
    
    [newUnSelectedRecipesList release];newUnSelectedRecipesList = nil;
    [newSelectedRecipesList release];newSelectedRecipesList = nil;
    
    [chemicalIds_ release];chemicalIds_ = nil;
    dispatch_release(networkProcessQueue);
    [super dealloc];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YDLabPalettesAddRecipeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YDLabPalettesRemoveRecipeNotification object:nil];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewRecipe:) name:YDLabPalettesAddRecipeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeNewRecipe:) name:YDLabPalettesRemoveRecipeNotification object:nil];
	[self.view setBackgroundColor:kColor];
    // Do any additional setup after loading the view from its nib.
    [self setUpScrollView];
    
    
//    - (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
    
//    [self addObserver:self forKeyPath:@"recipeCount" options:NSKeyValueObservingOptionNew context:nil];

    
}


//
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context{
//    if ([keyPath isEqualToString:@"recipeCount"]) {
//        NSLog(@"keyPath   %@",keyPath);
//        NSLog(@"change    %@  key %@  value %@",change,[change allKeys],[change allValues]);
//        NSDictionary *_NewValue = [change valueForKey:@"new"];
//        if ([_NewValue isKindOfClass:[NSDictionary class]]) {
//            //用户登陆或者续期了
//        }
//        else{
//            //用户登出
//        }
//    }
//}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    YDColorNumberSelectView *color = [[YDColorNumberSelectView alloc] initWithFrame:CGRectMake(7, 39, 1010, 147) popoverTargetType:YDPopoverTargetColor withLBNO:scandedCode_];
	color.delegate = self;
    self.colorView = color;
	[self.view addSubview:color];
    [color release];
    
    
//    DataMember *dataMemberHandle = [DataMember shareInstance];
//    LabAuxiliariesInfo *lab = [dataMemberHandle GetLabAuxiliariesInfo:@"205,195,187," UsageStr:@"1.2,3,0.7,0.2"];
//    
//    for (id obj in lab.ChemicalInfoAry) {
//        LAI_Atrb_ChemicalInfo *
//    }
//    
    
//    YDPalettesGroupView *t = [[YDPalettesGroupView alloc] initWithFrame:CGRectMake(7, 204, 249, 477)];
//	t.hidden = YES;
//	self.palettesGroupView = t;
//	[self.view addSubview:t];
//    [t release];
    
//    YDPalettesRecipeView *r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake(300, 204, 176, 227) recipeType:0];
//    [self.view addSubview:r];
//    [r release];r= nil;
//    
//    r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake(600, 204, 176, 227) recipeType:1];
//    [self.view addSubview:r];
//    [r release];
    
//    [self updateGroupScrollViewContent];
    
//    

}


- (void)setUpScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(270, 202, 747, 546)];
    [scrollView setBackgroundColor:kUpColor];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    self.recipeScrollView = scrollView;
    [scrollView release];scrollView = nil;
    
    [self.view addSubview:recipeScrollView_];
}

#pragma mark ------------------ 
#pragma  mark --------刷新界面
- (void)reloadRecipeViewsInScrollViewWith:(YDRecipeViewOperationType )_operationType recipeIndex:(NSInteger )_index
{
//    新建
    if (_operationType == YDRecipeViewOperationNewType)
    {
        for (int i = 0; i<[newSelectedRecipesList count]; i++)
        {
            NSInteger origin = 1 +i;
            YDPalettesRecipeView *recipe = (YDPalettesRecipeView *)[newSelectedRecipesList objectAtIndex:i];
                [recipe setFrame:CGRectMake((176+16)*(origin%4), (227+23)*(int)floor(origin/4), 176, 227)];
//                [recipeScrollView_ addSubview:recipe];
        }
    }
//    选择
    else if (_operationType == YDRecipeViewOperationSelectType)
    {
        for (int i = 0; i<recipeSelectedCount; i++) {
            NSInteger origin = 1+i;
            YDPalettesRecipeView *recipe = (YDPalettesRecipeView *)[newSelectedRecipesList objectAtIndex:i];
            [recipe setFrame:CGRectMake((176+16)*(origin%4), (227+23)*(int)floor(origin/4), 176, 227)];
        }
    }
//    取消选择
    else if (_operationType == YDRecipeViewOperationCancelType)
    {
        for (int i = 0; i<recipeSelectedCount; i++) {
            NSInteger origin = 1+i;
            YDPalettesRecipeView *recipe = (YDPalettesRecipeView *)[newSelectedRecipesList objectAtIndex:i];
            [recipe setFrame:CGRectMake((176+16)*(origin%4), (227+23)*(int)floor(origin/4), 176, 227)];
        }
    }
//    删除
    else if (_operationType == YDRecipeViewOperationDeleteType)
    {
        for (int i = 0; i<recipeSelectedCount; i++) {
            NSInteger origin = 1+i;
            YDPalettesRecipeView *recipe = (YDPalettesRecipeView *)[newSelectedRecipesList objectAtIndex:i];
            [recipe setFrame:CGRectMake((176+16)*(origin%4), (227+23)*(int)floor(origin/4), 176, 227)];
        }
    }
//    未选择的都是只需要更改frame
    for (int i = 0; i<recipeUnSelectCount; i++)
    {
        NSInteger origin = 1+i+recipeSelectedCount;
        YDPalettesRecipeView *recipe = (YDPalettesRecipeView *)[newUnSelectedRecipesList objectAtIndex:i];
        [recipe setFrame:CGRectMake((176+16)*(origin%4), (227+23)*(int)floor(origin/4), 176, 227)];
    }
}

- (void)updateGroupScrollViewContent:(NSArray *)_recipeValues
{
//    NSInteger count = 9;
    recipeCount = [_recipeValues count];
//    NSLog(@"   %@  %d",_recipeValues,recipeCount);
    NSInteger i = 0;
    for (; i<recipeCount; i++) 
    {
        YDPalettesRecipeView *group;
        if (i==0) {
            group = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((176+16)*(i%4), (227+23)*(int)floor(i/4), 176, 227) recipeType:YDPalettesRecipeTypeNone userType:YDUserTypeLab];
//            group.recipeVale = (Group_List *)[_recipeValues objectAtIndex:i];
            [group setRecipeValueWith:(Group_List *)[_recipeValues objectAtIndex:i]];
            group.chemicalIds = self.chemicalIds;
            
        }
        else {
            group = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((176+16)*(i%4), (227+23)*(int)floor(i/4), 176, 227) recipeType:YDPalettesOldRecipeType userType:YDUserTypeLab];
//            group.recipeVale = (Group_List *)[_recipeValues objectAtIndex:i];
//			group.remodified = YES;
            [group setRecipeValueWith:(Group_List *)[_recipeValues objectAtIndex:i]];
            group.delegate = self;
            group.chemicalIds = self.chemicalIds;
             [newUnSelectedRecipesList addObject:group];
        }
//		if (i%4 == 0 &&i != 0) 
//		{
//			group.remodified = YES;
//		}
        
        
        [recipeScrollView_ addSubview:group];
       
        [group release];
    }
    recipeUnSelectCount = [newUnSelectedRecipesList count];
    NSInteger height = (227+23)*(int)ceil(i/4.0);
    [recipeScrollView_ setContentSize:CGSizeMake(747, height)];
}

- (void)removeNewRecipe:(NSNotification *)_notice
{
    recipeCount -=1;
    NSInteger height = (227+23)*(int)ceil(recipeCount/4.0);
    [recipeScrollView_ setContentSize:CGSizeMake(747, height)];
}
- (void)addNewRecipe:(NSNotification *)_notice
{
    
//    YDPalettesRecipeView *group = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((176+16)*(recipeCount%4), (227+23)*(int)floor(recipeCount/4), 176, 227) recipeType:YDPalettesNewRecipeType];
//    group.selected = YES;
//    [recipeScrollView_ addSubview:group];
//    [newSelectedRecipesList addObject:group];
//    [group release];
    
    NSInteger totalRecipeCount = recipeCount + recipeSelectedCount;
    
    NSDictionary *userInfo = [_notice userInfo];
    NSString *newUsages = [userInfo objectForKey:YDNewRecipeNewUsageKey];
//    NSLog(@"newUsages  -------------- %@",newUsages);
    LAI_UIData *addictives = (LAI_UIData *)[userInfo objectForKey:YDNewRecipeArtworkKey];
    Group_List *recipeValue = (Group_List *)[userInfo objectForKey:YDNewRecipeOldUsageKey];
//    NSLog(@"LAI_UIData %@  %@  %@",addictives.NA2CO3,addictives.NA2SO4,addictives.keepWarnTime);
//    NSLog(@"Group_List  YDNewRecipeOldUsageKey  %@",recipeValue.titleName);
    
    NSString *newAndOldUsage = [userInfo objectForKey:YDNewAndOldUsageKey];
    
    YDPalettesRecipeView *group = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((176+16)*(totalRecipeCount%4), (227+23)*(int)floor(totalRecipeCount/4), 176, 227) recipeType:YDPalettesNewRecipeType userType:YDUserTypeLab];
    group.delegate = self;
    group.usagesNew = newUsages;
    group.recipeVale = recipeValue;
    group.additives = addictives;
    group.oldAndNewUsages = newAndOldUsage;
    group.chemicalIds = self.chemicalIds;
     group.selected = YES;
//    group.chemicalIds = self.chemicalIds;
    
    
    
    [recipeScrollView_ addSubview:group];
    
    
    
//    [newSelectedRecipesList addObject:group];
    
    [newSelectedRecipesList insertObject:group atIndex:0];
    recipeSelectedCount = [newSelectedRecipesList count];
     [group release];
    
    [self reloadRecipeViewsInScrollViewWith:YDRecipeViewOperationNewType recipeIndex:0];
    
   
    
//    [self willChangeValueForKey:@"recipeCount"];
    
//    recipeCount +=1;
    
//    [self didChangeValueForKey:@"recipeCount"];
    recipeCount = 1+recipeSelectedCount +recipeUnSelectCount;
    NSInteger height = (227+23)*(int)ceil((recipeCount+1)/4.0);
    [recipeScrollView_ setContentSize:CGSizeMake(747, height)];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

#pragma mark --------------
#pragma mark -----生成燃料的ids串
- (NSString *)chemicalIdsWith:(NSArray *)_chemicalLis
{
    NSMutableString  *ids = [NSMutableString stringWithCapacity:0];
    NSInteger count = [_chemicalLis count];
    for ( int i = 0;i<count;i++)
    {
        id obj = [_chemicalLis objectAtIndex:i];
        if ([obj isKindOfClass:[CI_Atrb_ChemicalInfo class]])
        {
            CI_Atrb_ChemicalInfo *chemical = (CI_Atrb_ChemicalInfo *)obj;
            if (i == 0) [ids appendString:[NSString stringWithFormat:@"%@",chemical.Chemical_ID]];
            else {
                [ids appendString:[NSString stringWithFormat:@",%@",chemical.Chemical_ID]];
            }
        }
    }
    return [NSString stringWithFormat:@"%@",ids];
}


#pragma mark ----------
#pragma mark  获取配方信息

- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type
{
    [self queryQueryChemicalWith:_colorCode type:_type result:^(ChemicalInfo *results){
    
        [palettesGroupView_ removeFromSuperview];
        
        Group_Head *group = results.group_Head;
        self.chemicalIds = [self chemicalIdsWith:results.chemicalInfoAry];
//        NSLog(@"self.chemicalIds %@  ",self.chemicalIds);
        if ([results.groupInfoAry count])
        {
            CI_Atrb_GroupInfo *groupInfo = (CI_Atrb_GroupInfo *)[results.groupInfoAry objectAtIndex:0];
            self.groupId = groupInfo.GroupID;
//            NSLog(@"组合的id  %@",self.groupId);
        }
        if ([group.valueAry count])
        {
            YDPalettesGroupView *t = [[YDPalettesGroupView alloc] initWithFrame:CGRectMake(7, 204, 249, 477) withGroup:group];
            self.palettesGroupView = t;
            [self.view addSubview:t];
            [t release];
        }
        
        
        [self updateGroupScrollViewContent:results.grouplistAry];
    }];
}

- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type result:(void(^)(ChemicalInfo *results))block
{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 354);
    [self.view addSubview:loadingView];
    [loadingView release];
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_async(networkProcessQueue,^{
        ChemicalInfo *resutl = [networkDataMemberHandle GetChemicalInfo:_colorCode Type:_type];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
//            NSLog(@"获取调方信息信息   。。。。。%@",resutl);
//            NSLog(@"lab获取调方信息信息   。。。。GroupInfoAry.count。 %d  ChemicalInfoAry.count .%d",resutl.GroupInfoAry.count,resutl.ChemicalInfoAry.count);
            block(resutl);
        });
        
    });
    

}


#pragma mark ------------------------------------------
#pragma mark output

- (void)outputSelectedRecipesWith:(NSString *)_LBNO 
                    withColorCode:(NSString *)_colorCode 
                       withWeight:(NSString *)_weight 
                       withUserId:(NSString *)_userId 
                         withRecipeNo:(NSString *)_recipeNo
                       WithNa2Co3:(NSString *)_Na2Co3 
                       withNa2So4:(NSString *)_Na2So4 
                     withWarnTime:(NSString *)_warnTime 
                      withGroupId:(NSString *)_groupId 
                  withChemicalIds:(NSString *)_chemicalIds 
                    withNewUsages:(NSString *)_newUsage 
                    withOldUsages:(NSString *)_oldUsages
{
    [self outputSelectedRecipesWith:_LBNO 
                      withColorCode:_colorCode 
                         withWeight:_weight 
                         withUserId:_userId 
                       withRecipeNo:_recipeNo 
                         WithNa2Co3:_Na2Co3 
                         withNa2So4:_Na2So4 
                       withWarnTime:_warnTime 
                        withGroupId:_groupId 
                    withChemicalIds:_chemicalIds 
                      withNewUsages:_newUsage 
                      withOldUsages:_oldUsages 
                             result:^(NSString *result){
//        NSLog(@"lab 调方 结果  －－－－－－%@",result);
    }];
}

- (void)outputSelectedRecipesWith:(NSString *)_LBNO 
                    withColorCode:(NSString *)_colorCode 
                       withWeight:(NSString *)_weight 
                       withUserId:(NSString *)_userId 
                         withRecipeNo:(NSString *)_recipeNo
                       WithNa2Co3:(NSString *)_Na2Co3 
                       withNa2So4:(NSString *)_Na2So4 
                     withWarnTime:(NSString *)_warnTime 
                      withGroupId:(NSString *)_groupId 
                  withChemicalIds:(NSString *)_chemicalIds 
                    withNewUsages:(NSString *)_newUsage 
                    withOldUsages:(NSString *)_oldUsages 
                           result:(void(^)(NSString *))block
{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 354);
    [self.view addSubview:loadingView];
    [loadingView release];
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_async(networkProcessQueue,^{
        NSString *result = [networkDataMemberHandle SaveLabRecipeInfo:_LBNO 
                                        Color_Code:_colorCode 
                                            Weight:_weight 
                                           User_ID:_userId 
                                         Recipe_NO:_recipeNo 
                                            NA2CO3:_Na2Co3 
                                            NA2SO4:_Na2So4 
                             Keep_Temperature_Time:_warnTime
                                          Group_ID:_groupId 
                                     ChemicalIDStr:_chemicalIds 
                                          UsageStr:_newUsage 
                                       OldUsageStr:_oldUsages];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
//            NSLog(@"获取调方信息信息   。。。。。%@",resutl);
            //            NSLog(@"lab获取调方信息信息   。。。。GroupInfoAry.count。 %d  ChemicalInfoAry.count .%d",resutl.GroupInfoAry.count,resutl.ChemicalInfoAry.count);
            if (!result) {
                 block(@"Error");
            }
            else {
                
                 block(result);
            }
           
        });
        
    });

}

- (YDAppDelegate *)YDAppDelegate
{
    return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}
#pragma mark ----
#pragma mark ---YDColorNumberSelectViewDelegate
- (void)colorNumberSelectDidFinish
{
	palettesGroupView_.hidden = NO;
//	[self updateGroupScrollViewContent];
}

- (void)didFinishSelectInfo:(YDColorNumberSelectView *)_selectView 
                     client:(NSString *)_client 
                 finishList:(NSString *)_finishList 
                     weight:(NSString *)_weight 
                  colorCode:(NSString *)_colorCode
{
    self.colorCode = _colorCode;
    self.weight = _weight;
    if (colorCode_)
    {
        [self queryQueryChemicalWith:_colorCode type:@"0"];
    }
}
- (void)reloadKDNOWith:(BOOL)_yesOrNo
{
    if (_yesOrNo)
    {
        palettesGroupView_.hidden = NO;
//        [self recover2Original];
//        [self updateGroupScrollViewContent];
        [newSelectedRecipesList removeAllObjects];
        [newUnSelectedRecipesList removeAllObjects];
        [self removeScrollViewSubvies];
        if (palettesGroupView_) {
            [palettesGroupView_ removeFromSuperview];
            self.palettesGroupView = nil;
        }
    }
    
}

#pragma mark------------------
#pragma mark -------YDPalettesRecipeViewDelegate
//配方选择或者取消选择
- (void)palettesRecipe:(YDPalettesRecipeView *)_recipeView 
           didSelected:(BOOL)_selected
{
//    NSLog(@"选择或取消配方");
    if (_selected)
    {
//        NSLog(@"select");
//        [newSelectedRecipesList addObject:_recipeView];
        
        NSInteger index = [newUnSelectedRecipesList indexOfObject:_recipeView];
        
        [newUnSelectedRecipesList removeObject:_recipeView];
        [newSelectedRecipesList insertObject:_recipeView atIndex:0];
        
        recipeSelectedCount = [newSelectedRecipesList count];
        recipeUnSelectCount = [newUnSelectedRecipesList count];
        
        [self reloadRecipeViewsInScrollViewWith:YDRecipeViewOperationSelectType recipeIndex:index];
    }
    else if (!_selected)
    {
//        NSLog(@"cancel");
        if ([newSelectedRecipesList containsObject:_recipeView])
        {
            NSInteger index = [newSelectedRecipesList indexOfObject:_recipeView];
            
            
            [newSelectedRecipesList removeObject:_recipeView];
            [newUnSelectedRecipesList addObject:_recipeView];
            
            recipeSelectedCount = [newSelectedRecipesList count];
            recipeUnSelectCount = [newUnSelectedRecipesList count];
            
            [self reloadRecipeViewsInScrollViewWith:YDRecipeViewOperationCancelType recipeIndex:index];
        }
        else if ([newUnSelectedRecipesList containsObject:_recipeView])
        {
            NSInteger index = [newUnSelectedRecipesList indexOfObject:_recipeView];
            
            [newUnSelectedRecipesList removeObject:_recipeView];
//            [newSelectedRecipesList ]
            
            [self reloadRecipeViewsInScrollViewWith:YDRecipeViewOperationCancelType recipeIndex:index];
        }
    }
}

//新建的配方删除
- (void)palettesRecipe:(YDPalettesRecipeView *)_recipeView didRemove:(BOOL)_removed
{
    if ([newSelectedRecipesList containsObject:_recipeView])
    {
        NSInteger index = [newSelectedRecipesList indexOfObject:_recipeView];
        
        [newSelectedRecipesList removeObject:_recipeView];
        
        recipeSelectedCount = [newSelectedRecipesList count];
        
        [self reloadRecipeViewsInScrollViewWith:YDRecipeViewOperationDeleteType recipeIndex:index];
        
        recipeCount -=1;
        NSInteger height = (227+23)*(int)ceil(recipeCount/4.0);
        [recipeScrollView_ setContentSize:CGSizeMake(747, height)];
    }
    else if ([newUnSelectedRecipesList containsObject:_recipeView])
    {
        NSInteger index = [newUnSelectedRecipesList indexOfObject:_recipeView];
        
        [newUnSelectedRecipesList removeObject:_recipeView];
        recipeUnSelectCount = [newUnSelectedRecipesList count];

        [self reloadRecipeViewsInScrollViewWith:YDRecipeViewOperationDeleteType recipeIndex:index];
        
//        recipeCount -=1;
        recipeCount = 1+recipeSelectedCount +recipeUnSelectCount;
        NSInteger height = (227+23)*(int)ceil(recipeCount/4.0);
        [recipeScrollView_ setContentSize:CGSizeMake(747, height)];
    }
}


#pragma mark-------------
#pragma mark button actions


- (void)outputResult:(NSString *)_result objectIndex:(NSInteger)_index
{
    if ([_result isEqualToString:@"OK"]) {
        YDPalettesRecipeView *group = (YDPalettesRecipeView *)[newSelectedRecipesList objectAtIndex:_index];
        [group setselectedWith:NO];
        successCount +=1;
//        [group removeFromSuperview];
    }
    else
    {
        NSString *message = _result;
        if (![_result length]) {
            message = @"output出错";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    if (successCount == totalCount) {
        [self recover2Original];
    }
}

- (void)showCheckResult:(NSString *)_result
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

//如果调用了checkpercent这个接口后没有错误信息就直接调用这个接口了
- (void)outputAfterCheckPercent:(NSInteger)_index
{
    if ([newSelectedRecipesList count])
    {
        NSString *userID = [self YDAppDelegate].currentUserName;
        if (_index < totalCount)
        {
            
            YDPalettesRecipeView *recipe = (YDPalettesRecipeView *)[newSelectedRecipesList objectAtIndex:_index];
            NSString *recipeNo = [recipe getRecipeNo];
            NSString *Na2Co3 = [recipe getNa2Co3];
            NSString *Na2So4 = [recipe getNa2So4];
            NSString *warnTime  = [recipe getKeepWarnTime];
            NSString *groupId = self.groupId;
            NSString *chemicalIds = self.chemicalIds;
            NSString *newUsage ;
            NSString *oldUsage;
            if (recipe.recipeType ==YDPalettesOldRecipeType ) {
                newUsage = [recipe getNewUsage];
                oldUsage = [recipe getOldUsages];
                if (!newUsage) newUsage = oldUsage;
            }
            else if (recipe.recipeType == YDPalettesNewRecipeType)
            {
                oldUsage = recipe.oldAndNewUsages;
                newUsage = [recipe getOldUsages];
            }
            
            
            DataMember  *networkDataMemberHandle = [DataMember shareInstance];
            
            dispatch_async(networkProcessQueue, ^{
                NSString *checkResult = [networkDataMemberHandle CheckIsNeedFixing:scandedCode_
                                                                         colorCode:colorCode_
                                                                       chemicalStr:chemicalIds
                                                                          usageStr:newUsage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([checkResult length]) {
                        [self showCheckResult:checkResult];
                    }
                });
            });
            
            
            
            UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [loadingView startAnimating];
            loadingView.center = CGPointMake(512, 354);
            [self.view addSubview:loadingView];
            [loadingView release];
            
            dispatch_async(networkProcessQueue,^{
                NSString *result = [networkDataMemberHandle SaveLabRecipeInfo:scandedCode_
                                                                   Color_Code:colorCode_
                                                                       Weight:weight_
                                                                      User_ID:userID
                                                                    Recipe_NO:recipeNo
                                                                       NA2CO3:Na2Co3
                                                                       NA2SO4:Na2So4
                                                        Keep_Temperature_Time:warnTime
                                                                     Group_ID:groupId
                                                                ChemicalIDStr:chemicalIds
                                                                     UsageStr:newUsage
                                                                  OldUsageStr:oldUsage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [loadingView removeFromSuperview];
                    [self outputResult:result objectIndex:_index];
  
                });
                
            });
            
  
        }
    }
}

//用户选择了继续output后强制output
- (void)forceOutPut:(NSInteger )_index
{
    if ([newSelectedRecipesList count])
    {
        NSString *userID = [self YDAppDelegate].currentUserName;
        if (_index < totalCount)
        {
            
            YDPalettesRecipeView *recipe = (YDPalettesRecipeView *)[newSelectedRecipesList objectAtIndex:_index];
            NSString *recipeNo = [recipe getRecipeNo];
            NSString *Na2Co3 = [recipe getNa2Co3];
            NSString *Na2So4 = [recipe getNa2So4];
            NSString *warnTime  = [recipe getKeepWarnTime];
            NSString *groupId = self.groupId;
            NSString *chemicalIds = self.chemicalIds;
            NSString *newUsage ;
            NSString *oldUsage;
            if (recipe.recipeType ==YDPalettesOldRecipeType ) {
                newUsage = [recipe getNewUsage];
                oldUsage = [recipe getOldUsages];
                if (!newUsage) newUsage = oldUsage;
            }
            else if (recipe.recipeType == YDPalettesNewRecipeType)
            {
                oldUsage = recipe.oldAndNewUsages;
                newUsage = [recipe getOldUsages];
            }
            
            
            DataMember  *networkDataMemberHandle = [DataMember shareInstance];
            
            dispatch_async(networkProcessQueue, ^{
                NSString *checkResult = [networkDataMemberHandle CheckIsNeedFixing:scandedCode_
                                                                         colorCode:colorCode_
                                                                       chemicalStr:chemicalIds
                                                                          usageStr:newUsage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([checkResult length]) {
                        [self showCheckResult:checkResult];
                    }
                });
            });
            
            
            
            UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [loadingView startAnimating];
            loadingView.center = CGPointMake(512, 354);
            [self.view addSubview:loadingView];
            [loadingView release];
            
            dispatch_async(networkProcessQueue,^{
                NSString *result = [networkDataMemberHandle SaveLabRecipeInfo:scandedCode_
                                                                   Color_Code:colorCode_
                                                                       Weight:weight_
                                                                      User_ID:userID
                                                                    Recipe_NO:recipeNo
                                                                       NA2CO3:Na2Co3
                                                                       NA2SO4:Na2So4
                                                        Keep_Temperature_Time:warnTime
                                                                     Group_ID:groupId
                                                                ChemicalIDStr:chemicalIds
                                                                     UsageStr:newUsage
                                                                  OldUsageStr:oldUsage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [loadingView removeFromSuperview];
                    [self outputResult:result objectIndex:_index];
                    
                });
                
            });
            
            
        }
    }
}

//output前需要先checkpercent
- (void)checkPercentResult:(NSString *)_result objectIndex:(NSInteger)_index
{
    //    检查成功后继续output
    if ([_result isEqualToString:@"OK"] || [_result length] == 0) {
        [self outputAfterCheckPercent:_index];
    }
    else
    {
        NSMutableString *message = [NSMutableString stringWithCapacity:[_result length]+[_result length]/2 +1];
        if (![_result length]) {
            [message appendString:@"output出错"];
        }
        [message appendString:@"，继续ouput？"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = _index;
        [alert show];
        [alert release];
    }
    
    
}



- (IBAction)outputButtonPress:(id)_sender
{
    /*
    if ([newSelectedRecipesList count])
    {
        totalCount = [newSelectedRecipesList count];
        NSString *userID = [self YDAppDelegate].currentUserName;
        for (int i = 0; i<totalCount; i++)
        {
            
            YDPalettesRecipeView *recipe = (YDPalettesRecipeView *)[newSelectedRecipesList objectAtIndex:i];

            NSString *chemicalIds = self.chemicalIds;
            NSString *newUsage ;
            NSString *oldUsage;
            if (recipe.recipeType ==YDPalettesOldRecipeType ) {
               newUsage = [recipe getNewUsage];
               oldUsage = [recipe getOldUsages];
                if (!newUsage) newUsage = oldUsage;
            }
            else if (recipe.recipeType == YDPalettesNewRecipeType)
            {
                oldUsage = recipe.oldAndNewUsages;
                newUsage = [recipe getOldUsages];
            }
           
            
             DataMember  *networkDataMemberHandle = [DataMember shareInstance];

            
            UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [loadingView startAnimating];
            loadingView.center = CGPointMake(512, 354);
            [self.view addSubview:loadingView];
            [loadingView release];
           
            dispatch_async(networkProcessQueue,^{
 
                NSString *result = [networkDataMemberHandle CheckPercent:chemicalIds newUsageStr:newUsage oldUsageStr:oldUsage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [loadingView removeFromSuperview];
                    [self checkPercentResult:result objectIndex:i];

                    
                });
                
            });

            
            
            

        }
    }
*/
    if ([newSelectedRecipesList count])
    {
        totalCount = [newSelectedRecipesList count];
        NSString *userID = [self YDAppDelegate].currentUserName;
        for (int i = 0; i<totalCount; i++)
        {
            
            YDPalettesRecipeView *recipe = (YDPalettesRecipeView *)[newSelectedRecipesList objectAtIndex:i];
            NSString *recipeNo = [recipe getRecipeNo];
            NSString *Na2Co3 = [recipe getNa2Co3];
            NSString *Na2So4 = [recipe getNa2So4];
            NSString *warnTime  = [recipe getKeepWarnTime];
            NSString *groupId = self.groupId;
            NSString *chemicalIds = self.chemicalIds;
            NSString *newUsage ;
            NSString *oldUsage;
            if (recipe.recipeType ==YDPalettesOldRecipeType ) {
                newUsage = [recipe getNewUsage];
                oldUsage = [recipe getOldUsages];
                if (!newUsage) newUsage = oldUsage;
            }
            else if (recipe.recipeType == YDPalettesNewRecipeType)
            {
                oldUsage = recipe.oldAndNewUsages;
                newUsage = [recipe getOldUsages];
            }
            
            
            DataMember  *networkDataMemberHandle = [DataMember shareInstance];
            
            dispatch_async(networkProcessQueue, ^{
                NSString *checkResult = [networkDataMemberHandle CheckIsNeedFixing:scandedCode_
                                                                         colorCode:colorCode_
                                                                       chemicalStr:chemicalIds
                                                                          usageStr:newUsage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([checkResult length]) {
                        [self showCheckResult:checkResult];
                    }
                });
            });
            
            
            
            UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [loadingView startAnimating];
            loadingView.center = CGPointMake(512, 354);
            [self.view addSubview:loadingView];
            [loadingView release];
            
            dispatch_async(networkProcessQueue,^{
                NSString *result = [networkDataMemberHandle SaveLabRecipeInfo:scandedCode_
                                                                   Color_Code:colorCode_
                                                                       Weight:weight_
                                                                      User_ID:userID
                                                                    Recipe_NO:recipeNo
                                                                       NA2CO3:Na2Co3
                                                                       NA2SO4:Na2So4
                                                        Keep_Temperature_Time:warnTime
                                                                     Group_ID:groupId
                                                                ChemicalIDStr:chemicalIds
                                                                     UsageStr:newUsage
                                                                  OldUsageStr:oldUsage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [loadingView removeFromSuperview];
                    [self outputResult:result objectIndex:i];
 
                    
                });
                
            });
            

        }

    }

}

- (IBAction)backButtonPress:(id)_sender
{
    if ([newSelectedRecipesList count])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您修改的数据尚未上传，是否返回到扫描界面？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = kBackAlert;
        [alert show];
        [alert release];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutButtonPress:(id)_sender
{
//    if ([newSelectedRecipesList count])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您修改的数据尚未上传，是否注销？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//        alert.tag = kLogoutAlert;
//        [alert show];
//        [alert release];
//        return;
//    }
     [[self YDAppDelegate] logOut];
}
- (IBAction)cancelButtonPress:(id)_sender;
{
    if ([newSelectedRecipesList count])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您修改的数据尚未上传，是否复位？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = kCancelAlert;
        [alert show];
        [alert release];
        return;
    }
    [self recover2Original];
}

- (void)recover2Original
{
    [newSelectedRecipesList removeAllObjects];
    [newUnSelectedRecipesList removeAllObjects];
    [self removeScrollViewSubvies];
    if (palettesGroupView_) {
        [palettesGroupView_ removeFromSuperview];
         self.palettesGroupView = nil;
    }
    self.palettesGroupView = nil;
    [colorView_ reloadDatas];
}

- (void)removeScrollViewSubvies
{
    NSArray *subviews = [recipeScrollView_ subviews];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)userDidChooseLogout
{
    [[self YDAppDelegate] logOut];
}

- (void)userDidChooseBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//处理弹出警告框后用户选择了是的情况
- (void)respondAlertAction:(NSInteger)_tag
{
    switch (_tag) {
        case kCancelAlert:
            [self recover2Original];
            break;
        case kBackAlert:
            [self userDidChooseBack];
            break;
        case kLogoutAlert:
            [self userDidChooseLogout];
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    if (buttonIndex == 1)
    {
//        NSLog(@" tag  %d  index %d",tag,buttonIndex);
        [self respondAlertAction:tag];
    }
}

@end
