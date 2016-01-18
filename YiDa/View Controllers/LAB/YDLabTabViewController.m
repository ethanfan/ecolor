//
//  YDLabTabViewController.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDLabTabViewController.h"
#import "YDColorNumberSelectView.h"
#import "YDPalettesRecipeView.h"
#import "YDLabTabView.h"
#import "YDLabColorView.h"
#import "YDColorPopoverView.h"
#import "PopoverView.h"
#import "YDAppDelegate.h"



#define kLastColorNameObjectTag   10000


@interface YDLabTabViewController ()
{
     
}


- (void)setUpScrollView;
- (void)updateGroupScrollViewContent;

//重置色级的状态，当用户重新选择的时候
- (void)resetColorNameState;

//监听标记的标记，如果有标记的色级配方，就在这儿捕获，并增加到色级这一栏去
- (void)addTabColorObserver:(NSNotification *)_notice;

//设置色级这一栏的scrollview
- (void)setUpColorNameScrollView:(NSMutableArray *)_colorName;

- (void)updateGroupScrollViewContent:(ChemicalInfo *)_chemicalInfo;

- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type;

- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type result:(void(^)(ChemicalInfo *results))block;


@end

@implementation YDLabTabViewController

@synthesize  navigationBarImageView = navigationBarImageView_;
@synthesize  viewTypeImage = viewTypeImage_;
@synthesize  userImageView = userImageView_;
@synthesize  outputButton = outputButton_;
@synthesize  cancelButton = cancelButton_;
@synthesize  logoutButton = logoutButton_;
@synthesize backButton = backButton_;

@synthesize groupScrollView = groupScrollView_;
@synthesize colorNameScrollView = colorNameScrollView_ ;

@synthesize colorView = colorView_;

@synthesize scanedCode = scanedCode_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        groupCount = 0;
        colorRecipeSelectedList = [[NSMutableArray arrayWithCapacity:0] retain];
        networkProcessQueue = dispatch_queue_create("YDLabTabQueue.YDLabTabViewController", NULL);
		namesArray = [[NSMutableArray arrayWithObjects:[YDColorLevelName initWith:@"A" state:0],
					  [YDColorLevelName initWith:@"B" state:0],
					  [YDColorLevelName initWith:@"C" state:0],
					  [YDColorLevelName initWith:@"D" state:0],
					  [YDColorLevelName initWith:@"E" state:0],
					  [YDColorLevelName initWith:@"F" state:0],
					  [YDColorLevelName initWith:@"G" state:0],nil] retain];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        测试数据
        groupCount = 0;
        colorRecipeSelectedList = [[NSMutableArray arrayWithCapacity:0] retain];
		namesArray = [[NSMutableArray arrayWithObjects:[YDColorLevelName initWith:@"A" state:0],
                       [YDColorLevelName initWith:@"B" state:0],
                       [YDColorLevelName initWith:@"C" state:0],
                       [YDColorLevelName initWith:@"D" state:0],
                       [YDColorLevelName initWith:@"E" state:0],
                       [YDColorLevelName initWith:@"F" state:0],
                       [YDColorLevelName initWith:@"G" state:0],nil] retain];
        self.scanedCode = _scanedCode;
//        self.scanedCode = @"LB2012-2809";
        networkProcessQueue = dispatch_queue_create("YDLabTabQueue.YDLabTabViewController", NULL);
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YDLabTabColorNameNotification object:nil];
    [navigationBarImageView_ release];navigationBarImageView_ = nil;
    [viewTypeImage_ release];viewTypeImage_ = nil;
    [userImageView_ release];userImageView_ = nil;
    [outputButton_ release];outputButton_ = nil;
    [cancelButton_ release];cancelButton_= nil;
    [logoutButton_ release];logoutButton_ = nil;
    [backButton_ release];backButton_ = nil;
    
    [groupScrollView_ release];groupScrollView_ = nil;
    [colorNameScrollView_ release];colorNameScrollView_ = nil;
    
	[namesArray release];namesArray = nil;
    [colorRecipeSelectedList release];colorRecipeSelectedList = nil;
    dispatch_release(networkProcessQueue);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:kColor];
    // Do any additional setup after loading the view from its nib.
//    YDPalettesRecipeView *r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake(300, 190, 110, 148) recipeType:YDTabRecipeSelectedTyep];
//    [self.view addSubview:r];
//    [r release];r= nil;
//	
//	r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake(600, 190, 110, 116) recipeType:YDTabColorLevelType];
//    [self.view addSubview:r];
//    [r release];r= nil;
	
    [self setUpScrollView];
	
//    [self addObserverForKeyPath:@"CurentUserOnLineInformation"
//                           owner:self
//                         options:NSKeyValueObservingOptionNew
//                           block:^(id observed, NSDictionary *change) {
//                               NSLog(@"%@",change);
//                               
//                           }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTabColorObserver:) name:YDLabTabColorNameNotification object:nil];
    

}

//
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context{
//    if ([keyPath isEqualToString:@"CurentUserOnLineInformation"]) {
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
    YDColorNumberSelectView *colorView = [[YDColorNumberSelectView alloc] initWithFrame:CGRectMake(7, 39, 1010, 147) popoverTargetType:YDPopoverTargetColor withLBNO:scanedCode_];
    colorView.delegate = self;
    self.colorView = colorView;
	[self.view addSubview:colorView];
    [colorView release];
    
    
//	
//    YDLabColorView *colorLevel = [[YDLabColorView alloc] initWithFrame:CGRectMake(7, 190, 1010, 160) levelCount:[namesArray count]+1 levelName:namesArray];
//	[self.view addSubview:colorLevel];
//	[colorLevel release];colorLevel = nil;
    
	
	
	
	
//	YDLabTabView *t = [[YDLabTabView alloc] initWithFrame:CGRectMake(7, 320, 1010, 240) recipeCount:11];
//	[self.view addSubview:t];
//	[t release];
    
//    [self queryQueryChemicalWith:@"VL40289" type:@"1"];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self updateGroupScrollViewContent];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:YDLabTabColorNameNotification object:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}


#pragma mark ------------
#pragma mark 更新色级的状态
- (void)resetColorNameState
{
    for (id obj in namesArray) {
        YDColorLevelName *name = (YDColorLevelName *)obj;
        name.nameState = 0;
    }
}


#pragma mark -------------------------------------
#pragma mark ----------------更新界面


- (void)setUpScrollView
{
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 340, 1010, 428)];
    [scrollView setBackgroundColor:kUpColor];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    self.groupScrollView = scrollView;
    [scrollView release];scrollView = nil;
    
    [self.view addSubview:groupScrollView_];
}

//色级这一栏的scrollview
- (void)setUpColorNameScrollView:(NSMutableArray *)_colorName
{
    if (colorNameScrollView_ == nil)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 190, 1010, 160)];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [scrollView setBackgroundColor:[UIColor clearColor]];
        self.colorNameScrollView = scrollView;
        [scrollView release];scrollView = nil;
        
        
        [self.view addSubview:colorNameScrollView_];
    }
    
        colorNameCount = [_colorName count]+1;
        
        for (int i = 0; i<colorNameCount; i++)
        {
            NSInteger type = YDTabColorLevelType;
            if (i== colorNameCount -1) {
                type = YDTabColorLevelMoreType;
                YDPalettesRecipeView *r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((110 +15)*i, 0, 110, 116) recipeType:type colorNames:_colorName];
                r.delegate = self;
                if (i== colorNameCount -1) {
                    r.tag =kLastColorNameObjectTag;
                }
                [colorNameScrollView_ addSubview:r];
                //			[colorsArray addObject:r];
                [r release];r= nil;
                break;
            }
            
            YDColorLevelName *name = (YDColorLevelName *)[_colorName objectAtIndex:i];
            
            YDPalettesRecipeView *r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((110 +15)*i, 0, 110, 116)
                                                                       recipeType:type
                                                                       colorNames:_colorName];
            [r setColorLevelName:name.colorLvelName];
            if (i== colorNameCount -1) {
                r.tag =kLastColorNameObjectTag;
            }
            [colorNameScrollView_ addSubview:r];
            //		[colorsArray addObject:r];
            [colorRecipeSelectedList addObject:r];
            [r release];r= nil;
        }
        [colorNameScrollView_ setContentSize:CGSizeMake((110+15)*colorNameCount, 120)];

}

- (void)updateGroupScrollViewContent
{
    NSInteger count = 2;
    NSInteger i = 0;
    for (; i<count; i++) 
    {
        YDLabTabView *t = [[YDLabTabView alloc] initWithFrame:CGRectMake(7, 240*i, 1010, 240) recipeCount:11 recipeType:YDTabCandidateType names:namesArray];
        
        [groupScrollView_ addSubview:t];
        [t release];
    }
    NSInteger height = 240*i;
    [groupScrollView_ setContentSize:CGSizeMake(1010, height)];
	
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
                                                      recipeType:YDTabCandidateType names:namesArray recipeInfo:_chemicalInfo];
        [groupScrollView_ addSubview:t];
        [t release];
    }
    NSInteger height = 240*i;
    [groupScrollView_ setContentSize:CGSizeMake(1010, height)];
}

//增加新标记的色级配方到色级这一栏去
- (void)addTabColorObserver:(NSNotification *)_notice
{
    
    
//    NSString *colorName = name.colorLvelName;
//    
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
//    [dictionary setObject:colorName forKey:YDLabTabColorNameKey];
//    if (recipeValue_) {
//        [dictionary setObject:recipeValue_ forKey:YDLabTabColorRecipeValueKey];
//    }
//	if (groupId_)
//    {
//        [dictionary setObject:groupId_ forKey:YDLabColorGroupIdKey];
//    }
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:YDLabTabColorNameNotification
//                                                        object:nil userInfo:dictionary];
    
    NSDictionary *userinfo = [_notice userInfo];
    
    NSString  *colorName = [userinfo objectForKey:YDLabTabColorNameKey];
    Group_List *recipeValue = (Group_List *)[userinfo objectForKey:YDLabTabColorRecipeValueKey];
    
    NSString *groupId = [userinfo objectForKey:YDLabColorGroupIdKey];
     YDPalettesRecipeView *from=[userinfo objectForKey:YDBulkTabOriginalRecipeKey];
    
//    NSLog(@"userinfo  %@",userinfo);
//    NSLog(@"colorName  %@",colorName);
//    NSLog(@"groupId   %@",groupId);
//    NSLog(@"recipe NO %@  recipeValue %@",recipeValue.titleName,recipeValue.valueAry);
    
//    NSLog(@"from view   %@",from);
    
    NSInteger indext = [namesArray indexOfObjectPassingTest:^(id element, NSUInteger idx, BOOL * stop)
    {
        
        YDColorLevelName *name = (YDColorLevelName*)element;
        
        
        *stop = [colorName isEqualToString:name.colorLvelName];
        return *stop;
    }];
    
//    NSLog(@"当前色级的位置   %d",indext);
 
    YDPalettesRecipeView *r = (YDPalettesRecipeView *)[colorRecipeSelectedList objectAtIndex:indext];
    r.recipeVale = recipeValue;
    r.groupId = groupId;
    r.originalRecipe = from;
    [r transformToSelect];
    
//    YDPalettesRecipeView *r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((110 +15)*tabRecipeCount, 0, 110, 148) recipeType:YDTabRecipeSelectedTyep];
    //    [r setremodifiedWith:YES];
//
//    r.recipeVale = recipeValue;
//    r.groupId = groupId;
//	[colorNameScrollView_ addSubview:r];
//    [r release];r= nil;
	
	tabRecipeCount +=1;
    
//    NSInteger width = (110+15)*selectedRecipeCount;
//    [selectedRecipeScrollView_ setContentSize:CGSizeMake(width, 160)];
}



//一次只能加一张
- (void)addMoreColorLevel:(NSString *)_name
{
	YDPalettesRecipeView *l = (YDPalettesRecipeView*)[colorNameScrollView_ viewWithTag:kLastColorNameObjectTag];
	if (l) {
        //		[l setFrame:CGRectMake((110 +15)*(colorLevelCount +1), 0, 110, 116)];
		[l setFrame:CGRectMake((110 +15)*colorNameCount , 0, 110, 116)];
	}
	
	YDPalettesRecipeView *r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((110 +15)*(colorNameCount -1), 0, 110, 116) recipeType:YDTabColorLevelType];
	[r setColorLevelName:_name];
	[colorNameScrollView_ addSubview:r];
	colorNameCount = colorNameCount+1;
	[colorRecipeSelectedList addObject:r];
	[r release];r= nil;
	
	if (namesArray)
	{
		[namesArray addObject:[YDColorLevelName initWith:_name state:0]];
	}
	[colorNameScrollView_ setContentSize:CGSizeMake((110+15)*colorNameCount, 160)];
}

#pragma mark -----------------------------------------------------------
#pragma mark 网络查询  查询配方信息

- (void)queryQueryChemicalWith:(NSString *)_colorCode type:(NSString *)_type
{
    [self queryQueryChemicalWith:_colorCode type:_type result:^(ChemicalInfo *results)
    {
        if ([results.chemicalInfoAry count]) {
            [self updateGroupScrollViewContent:results];
            [self setUpColorNameScrollView:namesArray];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无配方信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
//            NSLog(@"lab获取标记配方信息   。。。。GroupInfoAry.count。 %d  ChemicalInfoAry.count .%d",resutl.GroupInfoAry.count,resutl.ChemicalInfoAry.count);
            block(resutl);
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
//	[self updateGroupScrollViewContent];
}

- (void)reloadKDNOWith:(BOOL)_yesOrNo
{
    if (_yesOrNo)
    {
//        NSArray *subViews = [colorNameScrollView_ subviews];
//        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [colorRecipeSelectedList removeAllObjects];
        [self removeScrollViewSubvies];
    }
    
}

- (void)didFinishSelectInfo:(YDColorNumberSelectView *)_selectView 
                     client:(NSString *)_client 
                 finishList:(NSString *)_finishList 
                     weight:(NSString *)_weight 
                  colorCode:(NSString *)_colorCode
{
//    self.colorCode = _colorCode;
//    self.weight = _weight;
    if (_colorCode)
    {
        [self queryQueryChemicalWith:_colorCode type:@"1"];
        
       

    }
//    [self updateGroupScrollViewContent];
}



#pragma mark---------------------
#pragma mark button actions
- (IBAction)backButtonPress:(id)_sender
{
    if ([self canOutPut])
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
//    if ([self canOutPut])
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
    if ([self canOutPut])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您修改的数据尚未上传，是否复位？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = kCancelAlert;
        [alert show];
        [alert release];
        return;
    }
    [self recover2Original];
    [colorView_ reloadDatas];
}

- (void)recover2Original
{
    [colorRecipeSelectedList removeAllObjects];
    [self removeScrollViewSubvies];

    [colorView_ reloadDatas];
}

- (void)removeScrollViewSubvies
{
    
    NSArray *subviews = [groupScrollView_ subviews];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *colors = [colorNameScrollView_ subviews];
    [colors makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self resetColorNameState];
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


- (BOOL)canOutPut
{
    BOOL result = NO;
    for (id obj in colorRecipeSelectedList)
    {
        YDPalettesRecipeView *r = (YDPalettesRecipeView *)obj;
        if (r.recipeType == YDTabRecipeSelectedTyep) result = YES;
    }
    return result;
}

- (IBAction)outputButtonPress:(id)_sender
{
    NSString *userID = [self YDAppDelegate].currentUserName;
    NSString *recipeName = [NSString string];
    NSString *colorName = [NSString string];
    for (id obj in colorRecipeSelectedList)
    {
        YDPalettesRecipeView *r = (YDPalettesRecipeView *)obj;
        if (r.recipeType == YDTabRecipeSelectedTyep)
        {
            if ([recipeName length] == 0)
            {
                recipeName =[recipeName stringByAppendingString:[r getRecipeNo]];
                colorName = [colorName stringByAppendingString:r.colorLevelNameString];
            }
            else
            {
                recipeName =[recipeName stringByAppendingString:[NSString stringWithFormat:@",%@",[r getRecipeNo]]];
                colorName = [colorName stringByAppendingString:[NSString stringWithFormat:@",%@",r.colorLevelNameString]];
            }
            
            
        }
       
    }
    
//    NSLog(@"配方号，   %@   色级名称 %@",recipeName,colorName);
    
    if ([recipeName length] && [colorName length])
    {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        loadingView.center = CGPointMake(512, 354);
        [self.view addSubview:loadingView];
        [loadingView release];
        DataMember  *networkDataMemberHandle = [DataMember shareInstance];
        //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
        dispatch_async(networkProcessQueue,^{
            NSString *result = [networkDataMemberHandle CheckLabRecipeInfo:recipeName GradeStr:colorName User_ID:userID];
//            NSLog(@"开始");
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingView removeFromSuperview];
//                NSLog(@"output 结果   。。。。。%@   ",result);
                [self outputResult:result];
                
                //                block(results);
            });
            
        });
    }
   

}


- (void)outputResult:(NSString *)_result
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

//Delegate receives this call as soon as the item has been selected
- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
//	NSLog(@"fjfjfjfjfjfjfj");
}

//Delegate receives this call once the popover has begun the dismissal animation
- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
//	NSLog(@"dismiss   ------");
}

#pragma mark ------  
#pragma mark --------------------- 增加色级-------------------
//一次只能加一张


- (void)recipeDidChangeColorLevelName:(NSString *)_colorName
{
    YDPalettesRecipeView *l = (YDPalettesRecipeView*)[colorNameScrollView_ viewWithTag:kLastColorNameObjectTag];
	if (l) {
        //		[l setFrame:CGRectMake((110 +15)*(colorLevelCount +1), 0, 110, 116)];
		[l setFrame:CGRectMake((110 +15)*colorNameCount , 0, 110, 116)];
	}
	
	YDPalettesRecipeView *r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((110 +15)*(colorNameCount -1), 0, 110, 116) recipeType:YDTabColorLevelType colorNames:namesArray];
	[r setColorLevelName:_colorName];
	[colorNameScrollView_ addSubview:r];
	colorNameCount = colorNameCount+1;
	[colorRecipeSelectedList addObject:r];
	[r release];r= nil;
	
	if (namesArray)
	{
		[namesArray addObject:[YDColorLevelName initWith:_colorName state:0]];
	}
    
	[colorNameScrollView_ setContentSize:CGSizeMake((110+15)*colorNameCount, 160)];
}




@end
