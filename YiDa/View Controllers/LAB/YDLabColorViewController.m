//
//  YDLabColorViewController.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDLabColorViewController.h"
#import "YDColorGroupView.h"
#import "YDColorNumberSelectView.h"
#import "YDColorStepView.h"
#import "YDPostNotificationName.h"
#import "YDAppDelegate.h"

@interface YDLabColorViewController ()

- (void)setUpScrollView;
- (void)updateGroupScrollViewContent;
- (void)addColorGroup:(NSNotification *)_info;
//回复到最初始的状态
- (void)recover2Original;

- (void)removeScrollViewSubvies;

//查询网络中最优的来样组合
- (void)getBestGroupInformation;
- (void)getBestGroupInformationWith:(NSString *)_type 
                        simpleColor:(NSString *)_simpleColor 
                          colorDeep:(NSString *)_colorDeep 
                             client:(NSString *)_client 
                         finishList:(NSString *)_finishList 
                             result:(void (^)(NSArray *list))block;


- (void)outputRecipeWith:(NSString *)LBNO 
           withColorCode:(NSString *)_colorCode 
              withWeight:(NSString *)_weight 
                  withUserId:(NSString *)_userId 
                withStep:(NSString *)_step 
                 groupId:(NSString *)_groupId 
         withChemicalIds:(NSString *)_chemicalIds
              withUsages:(NSString *)_usages;

- (void)outputRecipeWith:(NSString *)LBNO 
           withColorCode:(NSString *)_colorCode 
              withWeight:(NSString *)_weight 
                  withUserId:(NSString *)_userId 
                withStep:(NSString *)_step 
                 groupId:(NSString *)_groupId 
         withChemicalIds:(NSString *)_chemicalIds
withUsages:(NSString *)_usages result:(void (^)(NSString *))block;



@end

@implementation YDLabColorViewController

@synthesize  navigationBarImageView = navigationBarImageView_;
@synthesize  viewTypeImage = viewTypeImage_;
@synthesize  userImageView = userImageView_;
@synthesize  outputButton = outputButton_;
@synthesize  cancelButton = cancelButton_;
@synthesize  logoutButton = logoutButton_;
@synthesize backButton = backButton_;

@synthesize colorView = colorView_;
@synthesize stepView = stepView_;

@synthesize groupScrollView = groupScrollView_;

@synthesize groupViewsArray = groupViewsArray_;

@synthesize scanedCode = scanedCode_;

@synthesize type = type_,
simpleColor = simpleColor_,
colorDeep = colorDeep_,
customer = customer_,
finishList = finishList_,stepString = stepString_;

@synthesize colorCode = colorCode_,weight = weight_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.groupViewsArray = [NSMutableArray arrayWithCapacity:0];
        groupCounts = 9;
        newSelectedGroups = [[NSMutableArray arrayWithCapacity:0] retain];
        networkProcessQueue = dispatch_queue_create("YDLabColorNetwokQueue.YDLabColorViewController", NULL);
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.scanedCode = _scanedCode;
//        测试不用整天输入
//        self.scanedCode = @"LB2012-2809";
        self.groupViewsArray = [NSMutableArray arrayWithCapacity:5];
          newSelectedGroups = [[NSMutableArray arrayWithCapacity:5] retain];
        groupCounts = 9;
        networkProcessQueue = dispatch_queue_create("YDLabColorNetwokQueue.YDLabColorViewController", NULL);
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YDLabColorAddGroupNotification object:nil];
//    NSLog(@"controller  dealloc ");
    
    [navigationBarImageView_ release];navigationBarImageView_ = nil;
    [viewTypeImage_ release];viewTypeImage_ = nil;
    [userImageView_ release];userImageView_ = nil;
    [outputButton_ release];outputButton_ = nil;
    [cancelButton_ release];cancelButton_= nil;
    [logoutButton_ release];logoutButton_ = nil;
    [backButton_ release];backButton_ = nil;
    
	[stepView_ removeFromSuperview];
    stepView_.delegate = nil;
	[stepView_ release];stepView_ = nil;
	[colorView_ removeFromSuperview];
	[colorView_ release];colorView_ = nil;
    
    [groupViewsArray_ release];groupViewsArray_ = nil;
    self.scanedCode = nil;
    [type_ release];type_ = nil;
    [simpleColor_ release];simpleColor_ = nil;
    [colorDeep_ release];colorDeep_ = nil;
    [customer_ release];customer_ = nil;
    [finishList_ release];finishList_ = nil;
    
    [colorCode_ release];colorCode_ = nil;
    [weight_ release];weight_ = nil;
    [stepString_ release];stepString_ = nil;
    
    [oldGroupList_ release];oldGroupList_ = nil;
    [newSelectedGroups release];newSelectedGroups = nil;
    [groupScrollView_ release];groupScrollView_ = nil;
    
    dispatch_release(networkProcessQueue);
    
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:YDLabColorAddGroup object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] addObserverForName:YDLabColorAddGroup object:nil queue:nil usingBlock: ^(NSNotification *note){
//        
//    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addColorGroup:) name:YDLabColorAddGroupNotification object:nil];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:kColor];
    [self setUpScrollView];
    
    YDColorNumberSelectView *color = [[YDColorNumberSelectView alloc] initWithFrame:CGRectMake(7, 39, 1010, 147) popoverTargetType:YDPopoverTargetColor withLBNO:scanedCode_];
    color.delegate = self;
	[self.view addSubview:color];
	self.colorView = color;
    [color release];
    
//    YDColorStepView *step = [[YDColorStepView alloc] initWithFrame:CGRectMake(7, 195, 1010, 68)];
//    step.delegate = self;
//    [self.view addSubview:step];
//	step.hidden = YES;
//	self.stepView = step;
//    [step release];
}

- (void)initStepView
{
    if (stepView_ == nil)
    {
        YDColorStepView *step = [[YDColorStepView alloc] initWithFrame:CGRectMake(7, 195, 1010, 68)];
        step.delegate = self;
        [self.view addSubview:step];
//        step.hidden = YES;
        self.stepView = step;
        [step release];
    }
//    else{
//        [self ]
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
//    NSString *resutl = [networkDataMemberHandle SaveLabRecipeInfo:@"LB2012-2809" Color_Code:@"50RDE0081" Weight:@"75.00" User_ID:@"sunyan" Recipe_NO:@"" NA2CO3:@"20,00000" NA2SO4:@"90,00000" Keep_Temperature_Time:@"90" Group_ID:@"99" ChemicalIDStr:@"205,195,187" UsageStr:@"1.5,3,0.7" OldUsageStr:@"1.5,3,0.7"];
//    
//    NSLog(@"测试 output    %@",resutl);
//    
//    NSLog(@"测试 output  main Thread   %@",resutl);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YDLabColorAddGroupNotification object:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)setUpScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 283, 1010, 455)];
    [scrollView setBackgroundColor:kUpColor];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    self.groupScrollView = scrollView;
    [scrollView release];scrollView = nil;
    
    [self.view addSubview:groupScrollView_];
}

- (void)updateGroupScrollViewContent
{
//    NSInteger count = 9;
//    重新加载的时候先移除旧的组合
    [self removeScrollViewSubvies];
    groupCounts = [oldGroupList_ count];
    NSInteger i = 0;
    for (; i<groupCounts; i++) 
    {
//        YDColorGroupView *group = [[YDColorGroupView alloc] initWithFrame:CGRectMake((245+10)*(i%4), (222+10)*(int)floor(i/4), 245, 222) 
//																title:[NSString stringWithFormat:@"%d",i]];
        YDColorGroupView *group = [[YDColorGroupView alloc] initWithFrame:CGRectMake((245+10)*(i%4), (222+10)*(int)floor(i/4), 245, 222) datas:[oldGroupList_ objectAtIndex:i]];
        group.groupViewType = YDGroupViewLabColor;
        group.delegate = self;
		[groupScrollView_ addSubview:group];
//        [group setColorImages:4];
//        [group setContentLabels:4];
        [group release];
    }
    NSInteger height = (222+10)*(int)ceil(i/4.0);
    [groupScrollView_ setContentSize:CGSizeMake(1010, height)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

#pragma mark --------------------
#pragma mark 网络查询 －－－－－－－－－－－－－－－－－－－
- (void)getBestGroupInformation
{
    
//    //[dataMemberHandle GetBestGroupInfo:@"活性" Simple_Color:@"RD" Color_Deep:@"DD" Customer:@"TMME" FinishList:@"2+"];
//    NSLog(@"type  %@ \nsimpleColor %@ \ncolorDeep %@ \ncustomer %@ \nfinishList %@",type_,simpleColor_,colorDeep_,customer_,finishList_);
    if ([type_ length] && [simpleColor_ length] && [colorDeep_ length] && [customer_ length] && [finishList_ length])
    {
        [self getBestGroupInformationWith:type_ simpleColor:simpleColor_ colorDeep:colorDeep_ client:customer_ finishList:finishList_ result:^(NSArray *list)
        {
            if (oldGroupList_)
            {
                [oldGroupList_ release];oldGroupList_ = nil;
            }
            if ([list count]) {
                oldGroupList_ = [list retain];
//                NSLog(@"old groud list %@  --- count %d",oldGroupList_,[oldGroupList_ count]);
                [self updateGroupScrollViewContent];
            }
//            NSArray *groups = [list getOneGroup];
//            if ([groups count]) {
//                oldGroupList_ = [groups retain];
//                 NSLog(@"old groud list %@  --- count %d",oldGroupList_,[oldGroupList_ count]);
//                NSLog(@"content in arry %@",NSStringFromClass([[oldGroupList_ objectAtIndex:0] class]));
//                [self updateGroupScrollViewContent];
//            }
            
        }];
    }
}

- (void)getBestGroupInformationWith:(NSString *)_type 
                        simpleColor:(NSString *)_simpleColor 
                          colorDeep:(NSString *)_colorDeep 
                             client:(NSString *)_client 
                         finishList:(NSString *)_finishList 
                             result:(void (^)(NSArray *list))block
{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 354);
    [self.view addSubview:loadingView];
    [loadingView release];
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_async(networkProcessQueue,^{
        NSArray *lists = [networkDataMemberHandle GetBestGroupInfo:_type Simple_Color:_simpleColor Color_Deep:_colorDeep Customer:_client FinishList:finishList_];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
//            NSLog(@"最优组合信息   。。。。。%@   ",lists);
        block(lists);
        });
        
    });

}

#pragma mark -------------
#pragma mark output
- (void)outputRecipeWith:(NSString *)LBNO 
           withColorCode:(NSString *)_colorCode 
              withWeight:(NSString *)_weight 
                  withUserId:(NSString *)_userId 
                withStep:(NSString *)_step 
                 groupId:(NSString *)_groupId 
         withChemicalIds:(NSString *)_chemicalIds
              withUsages:(NSString *)_usages
{
    [self outputRecipeWith:LBNO 
             withColorCode:_colorCode 
                withWeight:_weight 
                    withUserId:_userId 
                  withStep:_step 
                   groupId:_groupId 
           withChemicalIds:_chemicalIds 
                withUsages:_usages 
                    result:^(NSString *result){
//        NSLog(@"output result %@",result);
    }];
}

- (void)outputRecipeWith:(NSString *)LBNO 
           withColorCode:(NSString *)_colorCode
              withWeight:(NSString *)_weight 
                  withUserId:(NSString *)_userId 
                withStep:(NSString *)_step 
                 groupId:(NSString *)_groupId 
         withChemicalIds:(NSString *)_chemicalIds
              withUsages:(NSString *)_usages 
                  result:(void (^)(NSString *))block
{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 354);
    [self.view addSubview:loadingView];
    [loadingView release];
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_async(networkProcessQueue,^{
        NSString *results = [networkDataMemberHandle SaveRecipeInfo:LBNO Color_Code:_colorCode Weight:_weight User_ID:_userId Step:_step Group_ID:_groupId ChemicalIDStr:_chemicalIds UsageStr:_usages];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
//            NSLog(@"output 结果   。。。。。%@   ",results);
            block(results);
        });
        
    });
}

#pragma mark ------------------
#pragma mark ----- YDColorGroupViewViewDelegate
- (void)colorGroupDidSelect:(BOOL)_selected colorGroup:(YDColorGroupView *)_colorGroupView
{
    if (_selected)
    {
        if ([newSelectedGroups containsObject:_colorGroupView]) 
        {
//            NSLog(@"已经在选择列表中了。");
        }
        else 
        {
//            NSLog(@"加入选择列表");
            [newSelectedGroups addObject:_colorGroupView];
        }
    }
    else {
        if ([newSelectedGroups containsObject:_colorGroupView]) 
        {
//            NSLog(@"从选择列表中移除");
            [newSelectedGroups removeObject:_colorGroupView];
        }
    }
}

- (void)addColorGroup:(NSNotification *)_info
{

    NSDictionary *dictionary = [_info userInfo];
    NSString  *usages = [dictionary objectForKey:YDLabColorUsageKey];
    
    NSArray *chemicals = (NSArray *)[dictionary objectForKey:YDLabColorNewGroupKey];
//    YDColorGroupView *group = [[YDColorGroupView alloc] initWithFrame:CGRectMake((245+10)*(groupCounts%4), (222+10)*(int)floor(groupCounts/4), 245, 222) 
//                                                                    title:[NSString stringWithFormat:@"%d",groupCounts]];
    
    YDColorGroupView *group = [[YDColorGroupView alloc] initWithFrame:CGRectMake((245+10)*(groupCounts%4), (222+10)*(int)floor(groupCounts/4), 245, 222) datas:chemicals];
    group.usages = usages;
    group.delegate = self;
    [group setSelectButton:YES];
    group.groupViewType = YDGroupViewLabColor;
    [groupScrollView_ addSubview:group];
    [newSelectedGroups addObject:group];
    [group release];
    

    groupCounts +=1;
    NSInteger height = (222+10)*(int)ceil(groupCounts/4.0);
    [groupScrollView_ setContentSize:CGSizeMake(1010, height)];
    
}

- (YDAppDelegate *)YDAppDelegate
{
    return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark ----
#pragma mark ---YDColorNumberSelectViewDelegate
- (void)colorNumberSelectDidFinish
{
	stepView_.hidden = NO;
}

- (void)reloadKDNOWith:(BOOL)_yesOrNo
{
    if (_yesOrNo)
    {
        NSArray *subViews = [groupScrollView_ subviews];
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        stepView_.hidden  =YES;
    }
    
}

- (void)didFinishSelectInfo:(YDColorNumberSelectView *)_selectView 
                     client:(NSString *)_client 
                 finishList:(NSString *)_finishList 
                     weight:(NSString *)_weight 
                  colorCode:(NSString *)_colorCode
{
    stepView_.hidden  =NO;
//    [self updateGroupScrollViewContent];
    
    self.customer = _client;
    self.finishList = _finishList;
    
    self.weight = _weight;
    self.colorCode = _colorCode;
//    步骤在获取来样单之前已经获取完了
    if (stepView_.finishState == 1)
    {
        NSString *presult = [stepView_ predicateColorType:_colorCode];
//        NSLog(@"1 presult %@",presult);
        self.simpleColor = presult;
        [stepView_ resetSimpleColor:presult];
        
        [self removeScrollViewSubvies];
        
        [self getBestGroupInformation];
    }
    else
    {
         [self initStepView];
    }
    
   
    

}

#pragma mark -------------------------
#pragma mark YDStepSelectDelegate
//
- (void)stepDidSelect:(NSString *)_step 
             withCost:(NSString *)_cost 
            withColor:(NSString *)_color 
             withType:(NSString *)_type 
        withColorDeep:(NSString *)_colorDeep
{
//    只要色系、分类和深浅改变了才去查询
     self.stepString = _step;


    if (stepView_.finishState == 0) {
        NSString *presult = [stepView_ predicateColorType:colorCode_];
//        NSLog(@"2 presult %@   simpleColor_ %@",presult,colorCode_);
        self.simpleColor = presult;
        [stepView_ resetSimpleColor:presult];
        
        
        self.type = _type;
        self.colorDeep = _colorDeep;
//        NSLog(@"3 presult    simpleColor_ %@",simpleColor_);
        //        self.simpleColor = _color;
        
        
        [self removeScrollViewSubvies];
        
        [self getBestGroupInformation];
    }
    else if (![type_ isEqualToString:_type] || ![colorDeep_ isEqualToString:_colorDeep] ||![simpleColor_ isEqualToString:_color])
    {
       
        self.type = _type;
        self.colorDeep = _colorDeep;
//        NSLog(@"3 presult    simpleColor_ %@",simpleColor_);
        self.simpleColor = _color;
        
        
        [self removeScrollViewSubvies];
        
        [self getBestGroupInformation];
    }
    stepView_.finishState = 1;

}

#pragma mark------


- (void)userDidChooseBack
{
    
[self.navigationController popViewControllerAnimated:YES];
}
- (void)userDidChooseLogout
{

    [[self YDAppDelegate] logOut];
}

#pragma mark button action
-(IBAction)backButtonPress:(id)_sender
{
    if ([newSelectedGroups count])
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
//    if ([newSelectedGroups count])
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
    if ([newSelectedGroups count]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您修改的数据尚未上传，是否复位？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = kCancelAlert;
        [alert show];
        [alert release];
        return;
    }
   [self  recover2Original];
}

- (void)outputResult:(NSString *)_result objectIndex:(NSInteger)_index
{
    if ([_result isEqualToString:@"OK"]) {
        YDColorGroupView *group = (YDColorGroupView *)[newSelectedGroups objectAtIndex:_index];
//        [group removeFromSuperview];
        [group setSelectButton:NO];
//        其实这里有一个隐患，就是多线程同时操作时的问题，古老问题
//        NSLock
        successCount += 1;
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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

- (IBAction)outputButtonPress:(id)_sender
{
    NSString *userID = [self YDAppDelegate].currentUserName;
    totalCount = [newSelectedGroups count];
    for (int i = 0; i<[newSelectedGroups count]; i++)
    {
        YDColorGroupView *group = (YDColorGroupView *)[newSelectedGroups objectAtIndex:i];
        NSString *chemicalIds = [group chemicalIds];
        NSString *groupId = [group groupId];
        NSString *usages = group.usages;
        
        NSLog(@"scanedcode %@ \n colorCode %@ \n weight %@\n  userId %@ \n step %@ \n groupId %@ \n chemicalSting %@ \n usages  %@ \n ",scanedCode_,colorCode_,weight_,userID,stepString_,groupId,chemicalIds, usages);
        
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        loadingView.center = CGPointMake(512, 354);
        [self.view addSubview:loadingView];
        [loadingView release];
        DataMember  *networkDataMemberHandle = [DataMember shareInstance];
        //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
        
        
        dispatch_async(networkProcessQueue, ^{
            NSString *checkResult = [networkDataMemberHandle CheckIsNeedFixing:scanedCode_
                                                                     colorCode:colorCode_
                                                                   chemicalStr:chemicalIds
                                                                      usageStr:usages];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([checkResult length]) {
                    [self showCheckResult:checkResult];
                }
            });
        });
        
        dispatch_async(networkProcessQueue,^{
            NSString *results = [networkDataMemberHandle SaveRecipeInfo:scanedCode_ Color_Code:colorCode_ Weight:weight_ User_ID:userID Step:stepString_ Group_ID:groupId ChemicalIDStr:chemicalIds UsageStr:usages];
//            NSLog(@"开始");
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingView removeFromSuperview];
//                NSLog(@"output 结果   。。。。。%@   ",results);
                [self outputResult:results objectIndex:i];
                
//                block(results);
            });
            
        });

    }

}

- (void)recover2Original
{
    self.stepString = nil;
    stepView_.hidden = YES;
//    [stepView_ setFirstTitle];
    [newSelectedGroups removeAllObjects];
    [colorView_ reloadDatas];
    [self removeScrollViewSubvies];
}

- (void)removeScrollViewSubvies
{
    NSArray *subviews = [groupScrollView_ subviews];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
