    //
//  YDBulkTabViewController.m
//  YiDa
//
//  Created by Ni on 12-11-19.
//  Copyright 2012 meson.com. All rights reserved.
//

#import "YDBulkTabViewController.h"
#import "YDBulkPalettesView.h"
#import "YDPalettesGroupView.h"
#import "YDPalettesRecipeView.h"
#import "YDLabTabView.h"
#import "YDLabColorView.h"
#import "YDAppDelegate.h"

@interface YDBulkTabViewController ()

- (void)setUpScrollView;
- (void)updateGroupScrollViewContent;
//重新排列被标记的配方
- (void)reloadSelectedRecipe;
- (void)bulkTabAddSelectedRecipe:(NSNotification *)_notice;

- (void)updateGroupScrollViewContent:(ChemicalInfo *)_chemicalInfo;


- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type;

- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type result:(void(^)(ChemicalInfo *results))block;

@end



@implementation YDBulkTabViewController

@synthesize  navigationBarImageView = navigationBarImageView_;
@synthesize  viewTypeImage = viewTypeImage_;
@synthesize  userImageView = userImageView_;
@synthesize  outputButton = outputButton_;
@synthesize  cancelButton = cancelButton_;
@synthesize  logoutButton = logoutButton_;
@synthesize backButton = backButton_;

@synthesize groupScrollView = groupScrollView_;
@synthesize selectedRecipeScrollView = selectedRecipeScrollView_;

@synthesize batchInfoView = batchInfoView_;

@synthesize scanedCode = scanedCode_;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{
		selectedRecipeCount = 0;
        tabedRecipesList = [[NSMutableArray arrayWithCapacity:0] retain];
        networkProcessQueue = dispatch_queue_create("YDBulkTabQueue.YDBulkTabViewController", NULL);
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedRecipeCount = 0;
        tabedRecipesList = [[NSMutableArray arrayWithCapacity:0] retain];

        self.scanedCode = _scanedCode;
//        self.scanedCode = @"C2106116";
        networkProcessQueue = dispatch_queue_create("YDBulkTabQueue.YDBulkTabViewController", NULL);

    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view setBackgroundColor:kColor];
	[selectedRecipeScrollView_ setBackgroundColor:kUpColor];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bulkTabAddSelectedRecipe:) name:YDBulkTabAddSelectedRecipeNotification object:nil];
    
    
	
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	YDBulkPalettesView *tt = [[YDBulkPalettesView alloc] initWithFrame:CGRectMake(7, 39, 1010, 276) withCode:scanedCode_];
    tt.delegate = self;
    self.batchInfoView = tt;
	[self.view addSubview:tt];
	[tt release];
	
//	YDLabColorView *colorLevel = [[YDLabColorView alloc] initWithFrame:CGRectMake(7, 320, 1010, 120) levelCount:8];
//	[self.view addSubview:colorLevel];
//	[colorLevel release];colorLevel = nil;
//	
	
	
//    YDPalettesRecipeView *r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake(0, 0, 110, 148) recipeType:YDBulkTabRecipeSelectedType];
//    [r setremodifiedWith:YES];
//	[selectedRecipeScrollView_ addSubview:r];
//    [r release];r= nil;
//	
//	r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake(125, 0, 110, 116) recipeType:YDTabColorLevelType];
//    [selectedRecipeScrollView_ addSubview:r];
//    [r release];r= nil;

	
//	[self setUpScrollView];
    
    
    
    
//    [self queryQueryChemicalWith:@"C2097378" type:@"3"];
    
//     [self queryQueryChemicalWith:scanedCode_ type:@"3"];
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
//	[self updateGroupScrollViewContent];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return interfaceOrientation==UIInterfaceOrientationLandscapeLeft || 
	interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:YDBulkTabAddSelectedRecipeNotification object:nil];
    
	
	
}


- (void)dealloc {
    
	[[NSNotificationCenter defaultCenter] removeObserver:self name:YDBulkTabAddSelectedRecipeNotification object:nil];

	
    [navigationBarImageView_ release];navigationBarImageView_ = nil;
    [viewTypeImage_ release];viewTypeImage_ = nil;
    [userImageView_ release];userImageView_ = nil;
    [outputButton_ release];outputButton_ = nil;
    [cancelButton_ release];cancelButton_= nil;
    [logoutButton_ release];logoutButton_ = nil;
    [backButton_ release];backButton_ = nil;
    
	[groupScrollView_ release];groupScrollView_ = nil;
	[selectedRecipeScrollView_ release];selectedRecipeScrollView_ = nil;
    
    batchInfoView_.delegate = nil;
    [batchInfoView_ release];batchInfoView_ = nil;
    
    [scanedCode_ release];scanedCode_ = nil;
    [tabedRecipesList release];tabedRecipesList = nil;
    dispatch_release(networkProcessQueue);
    [super dealloc];
}



#pragma mark --------------------------
#pragma mark --------- 缸信息的回调
- (void)didFinishQueryBatchInfo:(NSString *)_colorCode withRato:(NSString *)_rato firstDye:(NSString *)_dye
{
    NSLog(@"color_code %@",_colorCode);
//    if (_colorCode)
    {
//        self.ratio = _rato;
        //        [self queryQueryChemicalWith:@"CC2106723" type:@"2"];
//        [self queryQueryChemicalWith:@"VL40289" type:@"1"];
        [self queryQueryChemicalWith:scanedCode_ type:@"3"];
    }
    
}

- (void)setUpScrollView
{
    if (groupScrollView_)
    {
        [groupScrollView_ removeFromSuperview];
        
    }
    
    
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 500, 1010, 250)];
    [scrollView setBackgroundColor:kUpColor];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    self.groupScrollView = scrollView;
    [scrollView release];scrollView = nil;
    
    [self.view addSubview:groupScrollView_];
}

- (void)updateGroupScrollViewContent
{
//    NSInteger count = 2;
//    NSInteger i = 0;
//    for (; i<count; i++) 
//    {
//        YDLabTabView *t = [[YDLabTabView alloc] initWithFrame:CGRectMake(7, 240*i, 1010, 240) recipeCount:11 recipeType:YDTabCandidateLongPressType];
//        
//        [groupScrollView_ addSubview:t];
//        [t release];
//    }
//    NSInteger height = 240*i;
//    [groupScrollView_ setContentSize:CGSizeMake(1010, height)];
}

- (void)updateGroupScrollViewContent:(ChemicalInfo *)_chemicalInfo
{
    NSInteger count = 1;
    NSInteger i = 0;
    for (; i<count; i++)
    {
        //        YDLabTabView *t = [[YDLabTabView alloc] initWithFrame:CGRectMake(7, 240*i, 1010, 240) recipeCount:11 recipeType:YDTabCandidateType names:namesArray];
        
        //        [groupScrollView_ addSubview:t];
        //        [t release];
        YDLabTabView    *t = [[YDLabTabView alloc] initWithFrame:CGRectMake(7, 240*i, 1010, 240)
                                                     recipeCount:[_chemicalInfo.grouplistAry count]
                                                      recipeType:YDTabCandidateLongPressType names:nil recipeInfo:_chemicalInfo];
        [groupScrollView_ addSubview:t];
        [t release];
    }
    NSInteger height = 240*i;
    [groupScrollView_ setContentSize:CGSizeMake(1010, height)];
}


- (void)reloadSelectedRecipe
{
    for (int i = 0; i<selectedRecipeCount; i++)
    {
        YDPalettesRecipeView *r = (YDPalettesRecipeView *)[tabedRecipesList objectAtIndex:i];
        [r setFrame:CGRectMake((110 +15)*i, 0, 110, 148)];
    }
}

- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type
{
    [self queryQueryChemicalWith:_colorCode type:_type result:^(ChemicalInfo *results)
    {
        if ([results.chemicalInfoAry count])
        {
//            NSLog(@"获取标记配方信息      -----------------------");
            [self setUpScrollView];
            [self updateGroupScrollViewContent:results];
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
//            NSLog(@"bulk获取标记配方信息   。。。。GroupInfoAry.count。 %d  ChemicalInfoAry.count .%d",resutl.GroupInfoAry.count,resutl.ChemicalInfoAry.count);
            block(resutl);
        });
        
    });
}

#pragma mark ---------- 
#pragma mark add notification
- (void)bulkTabAddSelectedRecipe:(NSNotification *)_notice
{
     NSDictionary *dictionary = [_notice userInfo];
     YDPalettesRecipeView *from=[dictionary objectForKey:YDBulkTabOriginalRecipeKey];
    
	if ([tabedRecipesList count]>5) {
        
//        如果超过了6个，当前被标记的候选配方也不需要改变背景颜色
        if (from) {
            [from updateBackgroundImage:YDTabCandidateLongPressType];
            [from setremodifiedWith:NO];
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不要超过6个标记配方" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
   
    Group_List *recipeValue = (Group_List *)[dictionary objectForKey:YDLabTabColorRecipeValueKey];
    NSString *groupId = [dictionary objectForKey:YDLabColorGroupIdKey];
    NSString *tabOkName = [dictionary objectForKey:YDBulkTabRecipeOKNameKey];
   
//    [dictionary setObject:recipeVale_ forKey:YDLabTabColorRecipeValueKey];
//    if (groupId) {
//        [dictionary setObject:groupId forKey:YDLabColorGroupIdKey];
//    }
//    
//    [dictionary setObject:@"正常" forKey:YDBulkTabRecipeOKNameKey];
    
//    NSLog(@"groupId %@  tabOkName %@  recipeValue %@",groupId,tabOkName,recipeValue);
    
    
    
	YDPalettesRecipeView *r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((110 +15)*selectedRecipeCount, 0, 110, 148) recipeType:YDBulkTabRecipeSelectedType];
    if ([tabOkName isEqualToString:@"回修"]) {
          [r setremodifiedWith:YES];
    }
  
    r.delegate = self;
    r.recipeVale = recipeValue;
    r.originalRecipe = from;
//    [r setGroupId:groupId tabName:tabOkName];
	[selectedRecipeScrollView_ addSubview:r];
     [r setGroupId:groupId tabName:tabOkName];
    [tabedRecipesList addObject:r];
    [r release];r= nil;
	
	selectedRecipeCount +=1;

    NSInteger width = (110+15)*selectedRecipeCount;
    [selectedRecipeScrollView_ setContentSize:CGSizeMake(width, 160)];
}

#pragma mark ---------------
#pragma mark --------- YDPalettesRecipeViewDelegate

- (void)tabRecipe:(YDPalettesRecipeView *)_recipeView didRemove:(BOOL)_removed
{
    if ([tabedRecipesList containsObject:_recipeView])
    {
        [tabedRecipesList removeObject:_recipeView];
//        移除
    }
    selectedRecipeCount -=1;
     NSInteger width = (110+15)*selectedRecipeCount;
    [selectedRecipeScrollView_ setContentSize:CGSizeMake(width, 160)];
    [self reloadSelectedRecipe];
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
            break;
    }
}

- (void)removeScrollViewSubvies
{
    NSArray *subviews = [groupScrollView_ subviews];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *subviewsTab = [selectedRecipeScrollView_ subviews];
    [subviewsTab makeObjectsPerformSelector:@selector(removeFromSuperview)];
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

- (void)recover2Original
{
    [tabedRecipesList removeAllObjects];
    [batchInfoView_ reloadDatas];
    [self removeScrollViewSubvies];
}

- (IBAction)backButtonPress:(id)_sender
{
    if ([tabedRecipesList count])
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
//    if ([tabedRecipesList count])
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
    if ([tabedRecipesList count]) {
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
    if ([_result isEqualToString:@"OK"])
    {
        [self recover2Original];
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
}


- (IBAction)outputButtonPress:(id)_sender
{
    if ([tabedRecipesList count]) {
        NSString *userID = [self YDAppDelegate].currentUserName;
        NSMutableString *recipeNos = [NSMutableString stringWithCapacity:3];
        NSMutableString *grades = [NSMutableString stringWithCapacity:5];
        for (int i = 0; i<[tabedRecipesList count]; i++)
        {
            
            YDPalettesRecipeView *recipe = (YDPalettesRecipeView *)[tabedRecipesList objectAtIndex:i];
            NSString *recipeNo = [recipe getRecipeNo];
            
            if (i == 0 && recipeNo != nil) {
                [recipeNos appendString:recipeNo];
            }
            else if (recipeNo != nil)
            {
                [recipeNos appendString:[NSString stringWithFormat:@",%@",recipeNo]];
            }
            
            NSString *name =@"0";
            BOOL modify = [recipe isRemodified];
            if (modify) {
                name = @"1";
            }
            if (i == 0) {
                [grades appendString:name];
            }
            else 
            {
                [grades appendString:[NSString stringWithFormat:@",%@",name]];
            }
            
//            NSLog(@"配方号组合  %@",recipeNos);
     
        }
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        loadingView.center = CGPointMake(512, 354);
        [self.view addSubview:loadingView];
        [loadingView release];
        DataMember  *networkDataMemberHandle = [DataMember shareInstance];
        //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
        dispatch_async(networkProcessQueue,^{
            NSString *result = [networkDataMemberHandle CheckBulkRecipeInfo:recipeNos GradeStr:grades User_ID:userID];
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingView removeFromSuperview];
                //            NSLog(@"获取调方信息信息   。。。。。%@",resutl);
                //            NSLog(@"lab获取调方信息信息   。。。。GroupInfoAry.count。 %d  ChemicalInfoAry.count .%d",resutl.GroupInfoAry.count,resutl.ChemicalInfoAry.count);
                [self outputResult:result objectIndex:0];
                
            });
            
        });
    }

}



@end
