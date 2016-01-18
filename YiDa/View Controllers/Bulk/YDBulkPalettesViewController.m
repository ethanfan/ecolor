    //
//  YDBulkPalettesViewController.m
//  YiDa
//
//  Created by Ni on 12-11-19.
//  Copyright 2012 meson.com. All rights reserved.
//

#import "YDBulkPalettesViewController.h"
#import "YDBulkPalettesView.h"
#import "YDPalettesGroupView.h"
#import "YDPalettesRecipeView.h"
#import "YDPostNotificationName.h"
#import "YDBulkPalettesRecipeView.h"
#import "YDAppDelegate.h"

@interface YDBulkPalettesViewController()

- (void)setUpScrollView;

- (void)updateGroupScrollViewContent;
- (void)updateGroupScrollViewContent:(NSArray *)_recipeValues;

- (void)reloadRecipeViewsInScrollViewWith:(YDRecipeViewOperationType )_operationType recipeIndex:(NSInteger )_index;

//生成燃料串id
- (NSString *)chemicalIdsWith:(NSArray *)_chemicalLis;

- (void)bulkPalettesAddNewRecipe:(NSNotification *)_notice;
- (void)bulkPalettesRemoveNewRecipe:(NSMutableDictionary *)_info;


- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type;

- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type result:(void(^)(ChemicalInfo *results))block;

- (void)outputRecipe:(NSString *)Repair
             xriteNO:(NSString *)xriteNO
      FirstDyeCotton:(NSString *)FirstDyeCotton
            Batch_NO:(NSString *)Batch_NO
             User_ID:(NSString *)User_ID
           Recipe_NO:(NSString *)Recipe_NO
              NA2CO3:(NSString *)NA2CO3
              NA2SO4:(NSString *)NA2SO4
Keep_Temperature_Time:(NSString *)Keep_Temperature_Time
            Group_ID:(NSString *)Group_ID ChemicalIDStr:(NSString *)ChemicalIDStr
            UsageStr:(NSString *)UsageStr
         OldUsageStr:(NSString *)OldUsageStr;

- (void)outputRecipe:(NSString *)Repair
             xriteNO:(NSString *)xriteNO
      FirstDyeCotton:(NSString *)FirstDyeCotton
            Batch_NO:(NSString *)Batch_NO
             User_ID:(NSString *)User_ID
           Recipe_NO:(NSString *)Recipe_NO
              NA2CO3:(NSString *)NA2CO3
              NA2SO4:(NSString *)NA2SO4
Keep_Temperature_Time:(NSString *)Keep_Temperature_Time
            Group_ID:(NSString *)Group_ID ChemicalIDStr:(NSString *)ChemicalIDStr
            UsageStr:(NSString *)UsageStr
         OldUsageStr:(NSString *)OldUsageStr
               block:(void (^)(NSString *))block;


@end



@implementation YDBulkPalettesViewController

@synthesize recipeScrollView = recipeScrollView_;

@synthesize  navigationBarImageView = navigationBarImageView_;
@synthesize  viewTypeImage = viewTypeImage_;
@synthesize  userImageView = userImageView_;
@synthesize  outputButton = outputButton_;
@synthesize  cancelButton = cancelButton_;
@synthesize  logoutButton = logoutButton_;
@synthesize backButton = backButton_;
@synthesize batchInfoView = batchInfoView_;
@synthesize palettesGroupView = palettesGroupView_;


@synthesize scanedCode = scanedCode_;

@synthesize chemicalIds = chemicalIds_;
@synthesize groupId = groupId_;
@synthesize ratio = ratio_;

@synthesize firstDye = firstDye_;

@synthesize xriteNO = xriteNO_;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        recipeCount = 9;
        newSelectRecipesList = [[NSMutableArray arrayWithCapacity:10] retain];
        newUnSelectRecipesList = [[NSMutableArray arrayWithCapacity:10] retain];
        networkProcessQueue = dispatch_queue_create("YDBulkPalettesQueue.YDBulkPalettesViewController", NULL);

    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         recipeCount = 9;
        self.scanedCode = _scanedCode;
//        self.scanedCode = @"C2106116";
        newSelectRecipesList = [[NSMutableArray arrayWithCapacity:10] retain];
        newUnSelectRecipesList = [[NSMutableArray arrayWithCapacity:10] retain];
         networkProcessQueue = dispatch_queue_create("YDBulkPalettesQueue.YDBulkPalettesViewController", NULL);

    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view setBackgroundColor:kColor];
//	[self setUpScrollView];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bulkPalettesAddNewRecipe:) name:YDBulkPalettesAddRecipeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bulkPalettesRemoveNewRecipe:) name:YDBulkPalettesRemoveRecipeNotification object:nil];
    
//	YDPalettesGroupView *t = [[YDPalettesGroupView alloc] initWithFrame:CGRectMake(7, 320, 249, 433)];
//    [self.view addSubview:t];
//    [t release];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	YDBulkPalettesView *tt = [[YDBulkPalettesView alloc] initWithFrame:CGRectMake(7, 39, 1010, 276) withCode:scanedCode_];
    tt.delegate = self;
    self.batchInfoView = tt;
	[self.view addSubview:tt];
	[tt release];
    
    
    
//    [self queryQueryChemicalWith:@"CC2106723" type:@"2"];
//     [self queryQueryChemicalWith:scanedCode_ type:@"2"];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
//	[self updateGroupScrollViewContent];
}

- (void)setUpScrollView
{
    if (recipeScrollView_)
    {
        [recipeScrollView_ removeFromSuperview];
    }
    
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(270, 320, 747, 433)];
    [scrollView setBackgroundColor:kUpColor];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    self.recipeScrollView = scrollView;
    [scrollView release];scrollView = nil;
    
    [self.view addSubview:recipeScrollView_];
}

- (void)updateGroupScrollViewContent
{
//    NSInteger count = 9;
    NSInteger i = 0;
    for (; i<recipeCount; i++) 
    {
        YDPalettesRecipeView *group;
        if (i==0) {
            group = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((176+16)*(i%4), (227+23)*(int)floor(i/4), 176, 227) recipeType:i userType:YDUserTypeBulk];
        }
        else {
            group = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((176+16)*(i%4), (227+23)*(int)floor(i/4), 176, 227) recipeType:YDPalettesOldRecipeType userType:YDUserTypeBulk];
		}
		if (i%3 == 0 && i!= 0) 
		{
			group.remodified = YES;
		}
        
        [recipeScrollView_ addSubview:group];
        [group release];
    }
    NSInteger height = (227+23)*(int)ceil(i/4.0);
    [recipeScrollView_ setContentSize:CGSizeMake(747, height)];
}

- (void)updateGroupScrollViewContent:(NSArray *)_recipeValues
{
    recipeCount = [_recipeValues count];
    NSLog(@"_recipeValues  in bulk    %@  %d",_recipeValues,recipeCount);
    NSInteger i = 0;
    for (; i<recipeCount; i++)
    {
//        YDPalettesRecipeView *group;
        YDBulkPalettesRecipeView *group = nil;
        if (i==0) {
//            group = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((176+16)*(i%4), (227+23)*(int)floor(i/4), 176, 227) recipeType:YDPalettesRecipeTypeNone userType:YDUserTypeBulk];
            //            group.recipeVale = (Group_List *)[_recipeValues objectAtIndex:i];
            group = [[YDBulkPalettesRecipeView alloc] initWithFrame:CGRectMake((176+16)*(i%4), (227+23)*(int)floor(i/4), 176, 227) viewType:YDBulkPalettesRecipeTypeNone];
            [group setRecipeValueWith:(Group_List *)[_recipeValues objectAtIndex:i]];
            Group_List * list = (Group_List *)[_recipeValues objectAtIndex:i];
            NSLog(@"Group_List   titleName %@",list.titleName);
            group.chemicalIds = self.chemicalIds;
//            group.batchNo = self.scanedCode;
            group.batchNo = scanedCode_;
            group.xriteNO = self.xriteNO;
            group.firstDyeCotton = self.firstDye;
            group.rato = self.ratio;
            
        }
        else {
//            group = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((176+16)*(i%4), (227+23)*(int)floor(i/4), 176, 227) recipeType:YDPalettesOldRecipeType userType:YDUserTypeBulk];
            //            group.recipeVale = (Group_List *)[_recipeValues objectAtIndex:i];
            //			group.remodified = YES;
             group = [[YDBulkPalettesRecipeView alloc] initWithFrame:CGRectMake((176+16)*(i%4), (227+23)*(int)floor(i/4), 176, 227) viewType:YDbulkPalettesRecipeOld];
            [group setRecipeValueWith:(Group_List *)[_recipeValues objectAtIndex:i]];
             Group_List * list = (Group_List *)[_recipeValues objectAtIndex:i];
            NSLog(@"Group_List   titleName %@",list.titleName);

            group.delegate = self;
            group.chemicalIds = self.chemicalIds;
//            group.batchNo = self.scanedCode;
            group.batchNo = scanedCode_;
            group.xriteNO = self.xriteNO;
            group.firstDyeCotton = self.firstDye;
            group.rato = self.ratio;
            [newUnSelectRecipesList addObject:group];
        }
//		if (i%4 == 0 &&i != 0)
//		{
//			group.remodified = YES;
//		}
        
        
        [recipeScrollView_ addSubview:group];
        
        [group release];
    }
    recipeUnSelectCount = [newUnSelectRecipesList count];
    NSInteger height = (227+23)*(int)ceil(i/4.0);
    [recipeScrollView_ setContentSize:CGSizeMake(747, height)];
}


- (void)reloadRecipeViewsInScrollViewWith:(YDRecipeViewOperationType )_operationType recipeIndex:(NSInteger )_index
{
    //    新建
    if (_operationType == YDRecipeViewOperationNewType)
    {
        for (int i = 0; i<[newSelectRecipesList count]; i++)
        {
            NSInteger origin = 1 +i;
            YDBulkPalettesRecipeView *recipe = (YDBulkPalettesRecipeView *)[newSelectRecipesList objectAtIndex:i];
            [recipe setFrame:CGRectMake((176+16)*(origin%4), (227+23)*(int)floor(origin/4), 176, 227)];
            //                [recipeScrollView_ addSubview:recipe];
        }
    }
    //    选择
    else if (_operationType == YDRecipeViewOperationSelectType)
    {
        for (int i = 0; i<recipeSelectedCount; i++) {
            NSInteger origin = 1+i;
            YDBulkPalettesRecipeView *recipe = (YDBulkPalettesRecipeView *)[newSelectRecipesList objectAtIndex:i];
            [recipe setFrame:CGRectMake((176+16)*(origin%4), (227+23)*(int)floor(origin/4), 176, 227)];
        }
    }
    //    取消选择
    else if (_operationType == YDRecipeViewOperationCancelType)
    {
        for (int i = 0; i<recipeSelectedCount; i++) {
            NSInteger origin = 1+i;
            YDBulkPalettesRecipeView *recipe = (YDBulkPalettesRecipeView *)[newSelectRecipesList objectAtIndex:i];
            [recipe setFrame:CGRectMake((176+16)*(origin%4), (227+23)*(int)floor(origin/4), 176, 227)];
        }
    }
    //    删除
    else if (_operationType == YDRecipeViewOperationDeleteType)
    {
        for (int i = 0; i<recipeSelectedCount; i++) {
            NSInteger origin = 1+i;
            YDBulkPalettesRecipeView *recipe = (YDBulkPalettesRecipeView *)[newSelectRecipesList objectAtIndex:i];
            [recipe setFrame:CGRectMake((176+16)*(origin%4), (227+23)*(int)floor(origin/4), 176, 227)];
        }
    }
    //    未选择的都是只需要更改frame
    for (int i = 0; i<recipeUnSelectCount; i++)
    {
        NSInteger origin = 1+i+recipeSelectedCount;
        YDBulkPalettesRecipeView *recipe = (YDBulkPalettesRecipeView *)[newUnSelectRecipesList objectAtIndex:i];
        [recipe setFrame:CGRectMake((176+16)*(origin%4), (227+23)*(int)floor(origin/4), 176, 227)];
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return  interfaceOrientation==UIInterfaceOrientationLandscapeLeft || 
	interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YDBulkPalettesAddRecipeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YDBulkPalettesRemoveRecipeNotification object:nil];

}


- (void)dealloc {
	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YDBulkPalettesAddRecipeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YDBulkPalettesRemoveRecipeNotification object:nil];
    
    [navigationBarImageView_ release];navigationBarImageView_ = nil;
    [viewTypeImage_ release];viewTypeImage_ = nil;
    [userImageView_ release];userImageView_ = nil;
    [outputButton_ release];outputButton_ = nil;
    [cancelButton_ release];cancelButton_= nil;
    [logoutButton_ release];logoutButton_ = nil;
    [backButton_ release];backButton_ = nil;
    
	[recipeScrollView_ release];recipeScrollView_ = nil;
    batchInfoView_.delegate = nil;
    [batchInfoView_ release];batchInfoView_ = nil;
    [palettesGroupView_ release];palettesGroupView_ = nil;
    
    [scanedCode_ release];scanedCode_ = nil;
    [chemicalIds_ release];chemicalIds_ = nil;
    [groupId_ release];groupId_ = nil;
    [ratio_ release];ratio_ = nil;
    [firstDye_ release];firstDye_  = nil;
    [xriteNO_ release];xriteNO_ = nil;
    
    [newSelectRecipesList release];newSelectRecipesList = nil;
    [newUnSelectRecipesList release];newUnSelectRecipesList = nil;
    
    dispatch_release(networkProcessQueue);
    [super dealloc];
}


#pragma mark -------------------------- 
#pragma mark --------- 缸信息的回调
- (void)didFinishQueryBatchInfo:(NSString *)_colorCode withRato:(NSString *)_rato firstDye:(NSString *)_dye
{
//    if (_colorCode)
    {
        self.ratio = _rato;
        self.firstDye = _dye;
//        [self queryQueryChemicalWith:@"CC2106723" type:@"2"];
//        [self queryQueryChemicalWith:@"VL40289" type:@"1"];
        [self queryQueryChemicalWith:scanedCode_ type:@"2"];
    }
    
}

#pragma mark ------------- 新增、删除配方
- (void)bulkPalettesAddNewRecipe:(NSNotification *)_notice
{
    
    
    NSDictionary *userInfo = [_notice userInfo];
    
//    NSString *newUsages  = [NSString stringWithFormat:@"%@,%@,%@",yellowLabel_.text,redLabel_.text,blueLabel_.text];
//    addictives_.NA2SO4 = soltLabel_.text;
//    addictives_.NA2CO3 = sodaLabel_.text;
//    addictives_.keepWarnTime = warnTimeLabel_.text;
//    [userInfo setObject:newUsages forKey:YDNewRecipeNewUsageKey];
//    recipeValues_.titleName = nil;
//    [userInfo setObject:recipeValues_ forKey:YDNewRecipeOldUsageKey];
//    [userInfo setObject:addictives_ forKey:YDNewRecipeArtworkKey];
    
    
    NSLog(@"newusages %@  ",[userInfo objectForKey:YDNewRecipeNewUsageKey]);
    NSLog(@"recipeValues %@",[userInfo objectForKey:YDNewRecipeOldUsageKey]);
    NSLog(@"addictives   %@",[userInfo objectForKey:YDNewRecipeArtworkKey]);
    
    NSNumber *modify= [userInfo objectForKey:YDBulkRemodifyKey];
    
    NSString *newUsages = [userInfo objectForKey:YDNewRecipeNewUsageKey];
    Group_List *recipeValue = (Group_List *)[userInfo objectForKey:YDNewRecipeOldUsageKey];
    LAI_UIData *addictives = (LAI_UIData *)[userInfo objectForKey:YDNewRecipeArtworkKey];
     NSString *newAndOldUsage = [userInfo objectForKey:YDNewAndOldUsageKey];
    
    YDBulkPalettesRecipeView *group = [[YDBulkPalettesRecipeView alloc] initWithFrame:CGRectMake((176+16)*(recipeCount%4), (227+23)*(int)floor(recipeCount/4), 176, 227) viewType:YDBulkPalettesRecipeTypeNew];
//    回修标志
    group.remodified = [modify boolValue];
    
//    [group setRecipeValueWith:(Group_List *)[_recipeValues objectAtIndex:i]];
    group.delegate = self;
    group.oldAndNewUsages = newAndOldUsage;
    group.chemicalIds = self.chemicalIds;
    //            group.batchNo = self.scanedCode;
    group.batchNo = self.scanedCode;
    group.xriteNO = self.xriteNO;
    group.firstDyeCotton = self.firstDye;
    group.rato = self.ratio;
    
    group.delegate = self;
    group.usagesNew = newUsages;
    group.recipeVale = recipeValue;
    group.additives = addictives;
    group.selected = YES;
    
    [newSelectRecipesList insertObject:group atIndex:0];
    recipeSelectedCount = [newSelectRecipesList count];

    [recipeScrollView_ addSubview:group];
//    [newSelectRecipesList addObject:group];
    [group release];
     [self reloadRecipeViewsInScrollViewWith:YDRecipeViewOperationNewType recipeIndex:0];
//    recipeCount +=1;
    recipeCount = 1+recipeSelectedCount +recipeUnSelectCount;
    NSInteger height = (227+23)*(int)ceil(recipeCount/4.0);
    [recipeScrollView_ setContentSize:CGSizeMake(747, height)];
    
    
}

- (void)bulkPalettesRemoveNewRecipe:(NSMutableDictionary *)_info
{
    recipeCount -=1;
    NSInteger height = (227+23)*(int)ceil(recipeCount/4.0);
    [recipeScrollView_ setContentSize:CGSizeMake(747, height)];
}


- (void)palettesRecipe:(YDPalettesRecipeView *)_recipeView didSelected:(BOOL)_selected
{
//    NSLog(@"选择或取消配方");
    if (_selected)
    {
//        NSLog(@"select");
//        [newSelectRecipesList addObject:_recipeView];
        NSInteger index = [newUnSelectRecipesList indexOfObject:_recipeView];
        
        [newUnSelectRecipesList removeObject:_recipeView];
        [newSelectRecipesList insertObject:_recipeView atIndex:0];
        
        recipeSelectedCount = [newSelectRecipesList count];
        recipeUnSelectCount = [newUnSelectRecipesList count];
        
        [self reloadRecipeViewsInScrollViewWith:YDRecipeViewOperationSelectType recipeIndex:index];

    }
    else if (!_selected)
    {
//        NSLog(@"cancel");
        if ([newSelectRecipesList containsObject:_recipeView])
        {
//            [newSelectRecipesList removeObject:_recipeView];
            NSInteger index = [newSelectRecipesList indexOfObject:_recipeView];
            
            
            [newSelectRecipesList removeObject:_recipeView];
            [newUnSelectRecipesList addObject:_recipeView];
            
            recipeSelectedCount = [newSelectRecipesList count];
            recipeUnSelectCount = [newUnSelectRecipesList count];
            
            [self reloadRecipeViewsInScrollViewWith:YDRecipeViewOperationCancelType recipeIndex:index];
        }
    }

}

//新建的配方删除
- (void)palettesRecipe:(YDPalettesRecipeView *)_recipeView didRemove:(BOOL)_removed
{
   
    
//    if ([newSelectRecipesList containsObject:_recipeView])
//    {
//        NSLog(@"删除新建配方");
//        [newSelectRecipesList removeObject:_recipeView];
//         recipeCount -=1;
//        NSInteger height = (227+23)*(int)ceil(recipeCount/4.0);
//        [recipeScrollView_ setContentSize:CGSizeMake(747, height)];
//    }

    if ([newSelectRecipesList containsObject:_recipeView])
    {
        NSInteger index = [newSelectRecipesList indexOfObject:_recipeView];
//        NSLog(@"从选择中删除");
        [newSelectRecipesList removeObject:_recipeView];
        
        recipeSelectedCount = [newSelectRecipesList count];
        
        [self reloadRecipeViewsInScrollViewWith:YDRecipeViewOperationDeleteType recipeIndex:index];
        
//        recipeCount -=1;
        recipeCount = 1+recipeSelectedCount +recipeUnSelectCount;
        NSInteger height = (227+23)*(int)ceil(recipeCount/4.0);
        [recipeScrollView_ setContentSize:CGSizeMake(747, height)];
    }
    else if ([newUnSelectRecipesList containsObject:_recipeView])
    {
        NSInteger index = [newUnSelectRecipesList indexOfObject:_recipeView];
//        NSLog(@"从未选择中删除");
        [newUnSelectRecipesList removeObject:_recipeView];
        recipeUnSelectCount = [newUnSelectRecipesList count];
        
        [self reloadRecipeViewsInScrollViewWith:YDRecipeViewOperationDeleteType recipeIndex:index];
        
        //        recipeCount -=1;
        recipeCount = 1+recipeSelectedCount +recipeUnSelectCount;
        NSInteger height = (227+23)*(int)ceil(recipeCount/4.0);
        [recipeScrollView_ setContentSize:CGSizeMake(747, height)];
    }
   
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

#pragma mark ----------------------
#pragma mark ---------- 网络查询

- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type
{
    [self queryQueryChemicalWith:_colorCode type:_type result:^(ChemicalInfo *results)
    {
        if ([results.chemicalInfoAry count])
        {
            [palettesGroupView_ removeFromSuperview];
            
            self.xriteNO = results.xriteItemNO.xriteNO;
            
//            NSLog(@"self.xriteNO     ----- %@",self.xriteNO);
            
            Group_Head *group = results.group_Head;
            self.chemicalIds = [self chemicalIdsWith:results.chemicalInfoAry];
            //        NSLog(@"self.chemicalIds %@  ",self.chemicalIds);
            if ([results.groupInfoAry count])
            {
                CI_Atrb_GroupInfo *groupInfo = (CI_Atrb_GroupInfo *)[results.groupInfoAry objectAtIndex:0];
                self.groupId = groupInfo.GroupID;
//                NSLog(@"组合的id  %@",self.groupId);
            }
            YDPalettesGroupView *t = [[YDPalettesGroupView alloc] initWithFrame:CGRectMake(7, 320, 249, 433) withGroup:group];
            self.palettesGroupView = t;
            [self.view addSubview:t];
            [t release];
            
            
            [self setUpScrollView];
            [self updateGroupScrollViewContent:results.grouplistAry];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查询配方信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }];
}

- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type result:(void (^)(ChemicalInfo *))block
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
//            NSLog(@"bulk获取调方配方信息   。。。。GroupInfoAry.count。 %d  ChemicalInfoAry.count .%d",resutl.GroupInfoAry.count,resutl.ChemicalInfoAry.count);
            block(resutl);
        });
        
    });
}
#pragma mark ----------- 网络output
#pragma mark ------------
- (void)outputRecipe:(NSString *)Repair
             xriteNO:(NSString *)xriteNO
      FirstDyeCotton:(NSString *)FirstDyeCotton
            Batch_NO:(NSString *)Batch_NO
             User_ID:(NSString *)User_ID
           Recipe_NO:(NSString *)Recipe_NO
              NA2CO3:(NSString *)NA2CO3
              NA2SO4:(NSString *)NA2SO4
Keep_Temperature_Time:(NSString *)Keep_Temperature_Time
            Group_ID:(NSString *)Group_ID
       ChemicalIDStr:(NSString *)ChemicalIDStr
            UsageStr:(NSString *)UsageStr
         OldUsageStr:(NSString *)OldUsageStr
{
    [self outputRecipe:Repair
               xriteNO:xriteNO
        FirstDyeCotton:FirstDyeCotton
              Batch_NO:Batch_NO
               User_ID:User_ID
             Recipe_NO:Recipe_NO
                NA2CO3:NA2CO3
                NA2SO4:NA2SO4
 Keep_Temperature_Time:Keep_Temperature_Time
              Group_ID:Group_ID
         ChemicalIDStr:ChemicalIDStr
              UsageStr:UsageStr
           OldUsageStr:OldUsageStr
                 block:^(NSString *result){
    
    }];
}

- (void)outputRecipe:(NSString *)Repair
             xriteNO:(NSString *)xriteNO
      FirstDyeCotton:(NSString *)FirstDyeCotton
            Batch_NO:(NSString *)Batch_NO
             User_ID:(NSString *)User_ID
           Recipe_NO:(NSString *)Recipe_NO
              NA2CO3:(NSString *)NA2CO3
              NA2SO4:(NSString *)NA2SO4
Keep_Temperature_Time:(NSString *)Keep_Temperature_Time
            Group_ID:(NSString *)Group_ID ChemicalIDStr:(NSString *)ChemicalIDStr
            UsageStr:(NSString *)UsageStr
         OldUsageStr:(NSString *)OldUsageStr
               block:(void (^)(NSString *))block
{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 354);
    [self.view addSubview:loadingView];
    [loadingView release];
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_async(networkProcessQueue,^{
        NSString *result = [networkDataMemberHandle SaveBulkRecipeInfo:Repair
                                                               xriteNO:xriteNO
                                                        FirstDyeCotton:FirstDyeCotton
                                                              Batch_NO:Batch_NO
                                                               User_ID:User_ID
                                                             Recipe_NO:Recipe_NO
                                                                NA2CO3:NA2CO3
                                                                NA2SO4:NA2SO4
                                                 Keep_Temperature_Time:Keep_Temperature_Time
                                                              Group_ID:Group_ID
                                                         ChemicalIDStr:ChemicalIDStr
                                                              UsageStr:UsageStr
                                                           OldUsageStr:OldUsageStr];
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
- (void)userDidChooseBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)userDidChooseLogout
{
    [[self YDAppDelegate] logOut];
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
            [self forceOutPut:_tag];
            break;
    }
}

- (void)removeScrollViewSubvies
{
    NSArray *subviews = [recipeScrollView_ subviews];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    if (buttonIndex == 1)
    {
        
        [self respondAlertAction:tag];
    }
}

- (void)recover2Original
{
    [newSelectRecipesList removeAllObjects];
    [newUnSelectRecipesList removeAllObjects];
    if (self.palettesGroupView) {
        [palettesGroupView_ removeFromSuperview];
        self.palettesGroupView = nil;
    }
    [batchInfoView_ reloadDatas];
    [self removeScrollViewSubvies];
}

- (IBAction)backButtonPress:(id)_sender
{
    if ([newSelectRecipesList count])
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
//    if ([newSelectRecipesList count])
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
    if ([newSelectRecipesList count]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您修改的数据尚未上传，是否复位？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = kCancelAlert;
        [alert show];
        [alert release];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)outputResult:(NSString *)_result objectIndex:(NSInteger)_index
{
    if ([_result isEqualToString:@"OK"]) {
        YDBulkPalettesRecipeView *group = (YDBulkPalettesRecipeView *)[newSelectRecipesList objectAtIndex:_index];
//        [group removeFromSuperview];
        [group setselectedWith:NO];
        successCount +=1;
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

//如果调用了checkpercent这个接口后没有错误信息就直接调用这个接口了
- (void)outputAfterCheckPercent:(NSInteger)_index
{
    NSString *userID = [self YDAppDelegate].currentUserName;
    totalCount = [newSelectRecipesList count];
    if (_index <totalCount) {
        YDBulkPalettesRecipeView *recipe = (YDBulkPalettesRecipeView *)[newSelectRecipesList objectAtIndex:_index];
        NSString *recipeNo = [recipe getRecipeNo];
        NSString *Na2Co3 = [recipe getNa2Co3];
        NSString *Na2So4 = [recipe getNa2So4];
        NSString *warnTime  = [recipe getKeepWarnTime];
        NSString *groupId = self.groupId;
        NSString *chemicalIds = self.chemicalIds;
        
        NSString *modifyString = @"0";
        BOOL  modify = recipe.remodified;
        if (modify) {
            modifyString = @"1";
        }
        
        NSString *newUsage ;
        NSString *oldUsage ;
        
        if (recipe.subViewType ==YDbulkPalettesRecipeOld ) {
            newUsage  = [recipe getNewUsage];
            oldUsage  = [recipe getOldUsages];
            if (!newUsage) newUsage = oldUsage;
        }
        else if (recipe .subViewType == YDBulkPalettesRecipeTypeNew)
        {
            oldUsage = recipe.oldAndNewUsages;
            newUsage = [recipe getOldUsages];
        }
        
        
        
        
        
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        loadingView.center = CGPointMake(512, 354);
        [self.view addSubview:loadingView];
        [loadingView release];
        DataMember  *networkDataMemberHandle = [DataMember shareInstance];
        dispatch_async(networkProcessQueue,^{
            NSString *result = [networkDataMemberHandle SaveBulkRecipeInfo:modifyString
                                                                   xriteNO:xriteNO_
                                                            FirstDyeCotton:firstDye_
                                                                  Batch_NO:scanedCode_
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

//用户选择了继续output后强制output
- (void)forceOutPut:(NSInteger )_index
{
    NSString *userID = [self YDAppDelegate].currentUserName;
    totalCount = [newSelectRecipesList count];
    if (_index <totalCount) {
        YDBulkPalettesRecipeView *recipe = (YDBulkPalettesRecipeView *)[newSelectRecipesList objectAtIndex:_index];
        NSString *recipeNo = [recipe getRecipeNo];
        NSString *Na2Co3 = [recipe getNa2Co3];
        NSString *Na2So4 = [recipe getNa2So4];
        NSString *warnTime  = [recipe getKeepWarnTime];
        NSString *groupId = self.groupId;
        NSString *chemicalIds = self.chemicalIds;
        
        NSString *modifyString = @"0";
        BOOL  modify = recipe.remodified;
        if (modify) {
            modifyString = @"1";
        }
        
        NSString *newUsage ;
        NSString *oldUsage ;
        
        if (recipe.subViewType ==YDbulkPalettesRecipeOld ) {
            newUsage  = [recipe getNewUsage];
            oldUsage  = [recipe getOldUsages];
            if (!newUsage) newUsage = oldUsage;
        }
        else if (recipe .subViewType == YDBulkPalettesRecipeTypeNew)
        {
            oldUsage = recipe.oldAndNewUsages;
            newUsage = [recipe getOldUsages];
        }
        
        
        
        
        
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        loadingView.center = CGPointMake(512, 354);
        [self.view addSubview:loadingView];
        [loadingView release];
        DataMember  *networkDataMemberHandle = [DataMember shareInstance];
        dispatch_async(networkProcessQueue,^{
            NSString *result = [networkDataMemberHandle SaveBulkRecipeInfo:modifyString
                                                                   xriteNO:xriteNO_
                                                            FirstDyeCotton:firstDye_
                                                                  Batch_NO:scanedCode_
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
    totalCount = [newSelectRecipesList count];
    for (int i = 0; i<totalCount; i++)
    {
        
        YDBulkPalettesRecipeView *recipe = (YDBulkPalettesRecipeView *)[newSelectRecipesList objectAtIndex:i];

        NSString *chemicalIds = self.chemicalIds;
        
        NSString *modifyString = @"0";
        BOOL  modify = recipe.remodified;
        if (modify) {
            modifyString = @"1";
        }
        
        NSString *newUsage ;
        NSString *oldUsage ;
        
        if (recipe.subViewType ==YDbulkPalettesRecipeOld ) {
            newUsage  = [recipe getNewUsage];
            oldUsage  = [recipe getOldUsages];
              if (!newUsage) newUsage = oldUsage;
        }
        else if (recipe .subViewType == YDBulkPalettesRecipeTypeNew)
        {
            oldUsage = recipe.oldAndNewUsages;
            newUsage = [recipe getOldUsages];
        }
 
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        loadingView.center = CGPointMake(512, 354);
        [self.view addSubview:loadingView];
        [loadingView release];
        DataMember  *networkDataMemberHandle = [DataMember shareInstance];
        dispatch_async(networkProcessQueue,^{
                       NSString *result = [networkDataMemberHandle CheckPercent:chemicalIds newUsageStr:newUsage oldUsageStr:oldUsage];
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingView removeFromSuperview];
                __block YDBulkPalettesViewController *blockSelf = self;
                [blockSelf checkPercentResult:result objectIndex:i];
            });
            
        });

    }
*/
    NSString *userID = [self YDAppDelegate].currentUserName;
    totalCount = [newSelectRecipesList count];
    for (int i = 0; i<totalCount; i++)
    {
        
        YDBulkPalettesRecipeView *recipe = (YDBulkPalettesRecipeView *)[newSelectRecipesList objectAtIndex:i];
        NSString *recipeNo = [recipe getRecipeNo];
        NSString *Na2Co3 = [recipe getNa2Co3];
        NSString *Na2So4 = [recipe getNa2So4];
        NSString *warnTime  = [recipe getKeepWarnTime];
        NSString *groupId = self.groupId;
        NSString *chemicalIds = self.chemicalIds;
        
        NSString *modifyString = @"0";
        BOOL  modify = recipe.remodified;
        if (modify) {
            modifyString = @"1";
        }
        
        NSString *newUsage ;
        NSString *oldUsage ;
        
        if (recipe.subViewType ==YDbulkPalettesRecipeOld ) {
            newUsage  = [recipe getNewUsage];
            oldUsage  = [recipe getOldUsages];
            if (!newUsage) newUsage = oldUsage;
        }
        else if (recipe .subViewType == YDBulkPalettesRecipeTypeNew)
        {
            oldUsage = recipe.oldAndNewUsages;
            newUsage = [recipe getOldUsages];
        }
 
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        loadingView.center = CGPointMake(512, 354);
        [self.view addSubview:loadingView];
        [loadingView release];
        DataMember  *networkDataMemberHandle = [DataMember shareInstance];
        dispatch_async(networkProcessQueue,^{
            NSString *result = [networkDataMemberHandle SaveBulkRecipeInfo:modifyString
                                                                   xriteNO:xriteNO_
                                                            FirstDyeCotton:firstDye_
                                                                  Batch_NO:scanedCode_
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


@end
