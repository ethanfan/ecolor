//
//  YDLabQueryDetailViewController.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDLabQueryDetailViewController.h"
#import "YDAppDelegate.h"
#import "RecipetTraceInfo.h"
#import "YDRecipeForIndex.h"

@interface YDLabQueryDetailViewController ()

- (void)updateInterface;

- (void)setUpTable:(NSArray *)_chemicalList;
//根据色号或者缸号查询配方列表
- (void)queryRecipeWith:(NSString *)_batch_ColorCodeBatch;
- (void)queryRecipeWith:(NSString *)_batch_ColorCodeBatch result:(void (^)(NSArray *lists))block;
//根据配方号查询配方进度
- (void)queryRecipeProcessWith:(NSString *)_recipeNo;
- (void)queryRecipeProcessWith:(NSString *)_recipeNo result:(void (^)(RecipetTraceInfo *recipeTraceInfo))block;

@end

@implementation YDLabQueryDetailViewController

@synthesize  navigationBarImageView = navigationBarImageView_;
@synthesize  viewTypeImage = viewTypeImage_;
@synthesize  userImageView = userImageView_;
@synthesize  outputButton = outputButton_;
@synthesize  cancelButton = cancelButton_;
@synthesize  logoutButton = logoutButton_;
@synthesize backButton = backButton_;

@synthesize queryButton = queryButton_;

@synthesize scandedCode = scandedCode_;

@synthesize informationScrollView = informationScrollView_;
@synthesize colorLabel = colorLabel_;  ///色号，缸号
@synthesize colorContentLabel=  colorContentLabel_;
@synthesize recipeNumberLabel = recipeNumberLabel_;//配方号
@synthesize mainInfoLabel = mainInfoLabel_;

@synthesize recipesList = recipesList_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        queryNetworkQueue = dispatch_queue_create("YDQueryNetworkQueue.YDLabQueryDetailViewController", NULL);
        self.recipesList = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil queryType:(NSInteger )_queryType
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        currentQueryType = _queryType;
        first = 0;
         queryNetworkQueue = dispatch_queue_create("YDQueryNetworkQueue.YDLabQueryDetailViewController", NULL);
         self.recipesList = [NSMutableArray arrayWithCapacity:0];
    }
    return  self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
             withCode:(NSString *)_scanedCode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        first = 0;
//        self.scandedCode = @"C2106723";
        self.scandedCode = _scanedCode;
         queryNetworkQueue = dispatch_queue_create("YDQueryNetworkQueue.YDLabQueryDetailViewController", NULL);
         self.recipesList = [NSMutableArray arrayWithCapacity:0];
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:kColor];
//	[self.view setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]];
    
    NSInteger userType = [[self YDAppDelegate] currentUserType];
    if (userType == YDUserTypeLab)
	{
		userImageView_.image = [UIImage imageNamed:@"ButtonNavigationBarLabUser.png"];
	}
	else if (userType == YDUserTypeBulk)
	{
		userImageView_.image = [UIImage imageNamed:@"ButtonNavigationBarBulkUser.png"];
        
	}
    
    [colorContentLabel_ setText:scandedCode_];
    [colorContentLabel_ setFrame:CGRectMake(105, 60, 127, 38)];
	[colorLabel_ setBackgroundColor:[UIColor colorWithRed:174.0/255.0 green:168.0/255. blue:156/255.0 alpha:1.]];
	[colorContentLabel_ setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]];
	[recipeNumberLabel_ setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255. blue:141.0/255.0 alpha:1.]];
	[mainInfoLabel_ setBackgroundColor:[UIColor colorWithRed:174.0/255.0 green:168.0/255. blue:156/255.0 alpha:1.]];

	//在表格中 左右的间隔未2，上下的间隔未1
	[informationScrollView_ setContentSize:CGSizeMake(859, 1024)];
	[informationScrollView_ setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]];
    // Do any additional setup after loading the view from its nib.
    
//    第一列 w：189 第二列：113 三：112 四：72
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
//	recipeTableView = [[YDLabQueryTableView alloc] initWithFrame:CGRectMake(15, 157, 128, 588)];
//    recipeTableView.delegate = self;
//	[self.view addSubview:recipeTableView];
//	[tableView release];
    
    [self queryRecipeWith:scandedCode_];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)updateInterface
{
    [jihuashazhiLabel_ setText:@"计划纱支："];
    [gongyiLabel_ setText:@"工艺：R"];
    [jihuapishaLabel_ setText:@"计划纱批："];
    [fubanpishaLabel_ setText:@"复板纱批："];
    [kaibanshijianLabel_ setText:@"开板时间："];
    [anpaishiliaoLabel_ setText:@"安排吸料时间："];
    [anpaishiliaoMenLabel_ setText:@"吸料人："];
    [chengshaLabel_ setText:@"称纱时间："];
    [chengshaMenLabel_ setText:@"称纱人："];
    [jingongshiLabel_ setText:@"进缸时间："];
    [jingongMenLabel_ setText:@"进缸人："];
    [jialiaoLabel_ setText:@"加料时间："];
    [jialiaoMenLabel_ setText:@"加料人："];
    [chugangLabel_ setText:@"出缸时间："];
    [chugangMenLabel_ setText:@"出缸人："];
    [songyangLabel_ setText:@"送样时间："];
    [songyangMenLabel_ setText:@"送样人："];
    [shouyangLabel_ setText:@"收样时间："];
    [shouyangMenLabel_ setText:@"收样人："];
    [tiaosheshiLabel_ setText:@"调色师："];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (YDAppDelegate *)YDAppDelegate
{
    return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark---------------------
#pragma mark button actions

- (IBAction)queryButtonPress:(id)sender
{
    [self updateInterface];
    [colorContentLabel_ resignFirstResponder];
    [self queryRecipeWith:colorContentLabel_.text];
}

- (IBAction)backButtonPress:(id)_sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutButtonPress:(id)_sender
{
    [[self YDAppDelegate] logOut];

}
- (IBAction)cancelButtonPress:(id)_sender;
{
    
}
- (IBAction)outputButtonPress:(id)_sender
{
    
}

- (void)dealloc
{
    [navigationBarImageView_ release];navigationBarImageView_ = nil;
    [viewTypeImage_ release];viewTypeImage_ = nil;
    [userImageView_ release];userImageView_ = nil;
    [outputButton_ release];outputButton_ = nil;
    [cancelButton_ release];cancelButton_= nil;
    [logoutButton_ release];logoutButton_ = nil;
    [backButton_ release];backButton_ = nil;
    [queryButton_ release];queryButton_ = nil;
    
	[informationScrollView_ release];informationScrollView_ = nil;
	[colorLabel_ release];  colorLabel_ = nil;
	[colorContentLabel_ release]; colorContentLabel_ = nil;
	[recipeNumberLabel_ release]; recipeNumberLabel_ = nil;
	[mainInfoLabel_ release];
    
    [jihuashazhiLabel_ release];
    [gongyiLabel_ release];
     [jihuapishaLabel_ release];
     [fubanpishaLabel_ release];
     [kaibanshijianLabel_ release];
     [anpaishiliaoLabel_ release];
     [anpaishiliaoMenLabel_ release];
     [chengshaLabel_ release];
     [chengshaMenLabel_ release];
     [jingongshiLabel_ release];
     [jingongMenLabel_ release];
     [jialiaoLabel_ release];
     [jialiaoMenLabel_ release];
     [chugangLabel_ release];
     [chugangMenLabel_ release];
     [songyangLabel_ release];
     [songyangMenLabel_ release];
     [shouyangLabel_ release];
     [shouyangMenLabel_ release];
    [tiaosheshiLabel_ release];
    
    [colorCodeLabel_ release];

    [recipeTableView removeFromSuperview];
    [recipeTableView release];recipeTableView = nil;
    
     [nameLabel_ release];    //化料名
     [nameIdLabel_ release];    //化料id
     [costLabel_ release];      //单位用量
     [unitLabel_ release];     //单位
    [scandedCode_ release];scandedCode_ = nil;
    [recipesList_ release];recipesList_ = nil;
    dispatch_release(queryNetworkQueue);
	[super dealloc];
}


- (void)setUpTable:(NSArray *)_chemicalList
{
//    第一列化料名
    NSInteger count = [_chemicalList count];
    for (int i = 0; i<count; i++) {
        RTI_atb_ChemicalInfo *chemical = (RTI_atb_ChemicalInfo *)[_chemicalList objectAtIndex:i];
        NSInteger tag = 10000+i+1;
        UILabel *label = (UILabel *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
             label = [[UILabel alloc] initWithFrame:CGRectMake(116, 400+(37+2)*i, 189, 37)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            label.tag = tag;
//            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:chemical.Chemical_Name];
//    }
//    第二列 化料名id
//    for (int i = 0; i<10; i++) {
         tag = 20000+i+1;
         label = (UILabel *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(307, 400+(37+2)*i, 113, 37)];
            [label setTextAlignment:UITextAlignmentCenter];
            label.tag = tag;
            [label setBackgroundColor:[UIColor clearColor]];
//            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:chemical.Chemical_ID];

//    }
//    第三列 单位用量
//    for (int i = 0; i<10; i++) {
         tag = 30000+i+1;
         label = (UILabel *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(422, 400+(37+2)*i, 113, 37)];
            label.tag = tag;
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBackgroundColor:[UIColor clearColor]];
//            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:chemical.Unit_Usage];

//    }
//    第四列 单位
//    for (int i = 0; i<10; i++) {
//         tag = 40000+i+1;
//        label = (UILabel *)[informationScrollView_ viewWithTag:tag];
//        if (label== nil)
//        {
//            label = [[UILabel alloc] initWithFrame:CGRectMake(537, 400+(37+2)*i, 72, 37)];
//            [label setTextAlignment:UITextAlignmentCenter];
//            [label setBackgroundColor:[UIColor clearColor]];
//            [label setText:@"222"];
//            [informationScrollView_ addSubview:label];
//            [label release];
//        }
//        [label setText:chemical.Unit];

//    }
    }
}

- (void)updateRecipeProcessWith:(RTI_atb_RecipeTrace *)_trace
{



    
    
    [jihuashazhiLabel_ setText:[NSString stringWithFormat:@"缸号：%@",_trace.Batch_NO]];
    [colorCodeLabel_ setText:[NSString stringWithFormat:@"色号：%@",_trace.Color_Code]];
    [gongyiLabel_ setText:[NSString stringWithFormat:@"工艺:%@",_trace.Art_NO]];
    [jihuapishaLabel_ setText:[NSString stringWithFormat:@"浴比：%@",_trace.Ratio]];
    [fubanpishaLabel_ setText:[NSString stringWithFormat:@"交板期：%@",_trace.Final_LB_Delivery_Date]];
    [kaibanshijianLabel_ setText:[NSString stringWithFormat:@"开板时间:%@",_trace.Handle_Time]];
    [anpaishiliaoLabel_ setText:[NSString stringWithFormat:@"安排吸料时间:%@",_trace.Suck_Plan_Date]];
//    [anpaishiliaoMenLabel_ setText:@"吸料人：jgi"];
    [chengshaLabel_ setText:[NSString stringWithFormat:@"称纱时间:%@",_trace.Operate_Date]];
//    [chengshaMenLabel_ setText:@"称纱人：ndi"];
    [jingongshiLabel_ setText:[NSString stringWithFormat:@"进缸时间:%@",_trace.Dye_Time]];
//    [jingongMenLabel_ setText:@"进缸人：ndi"];
    [jialiaoLabel_ setText:[NSString stringWithFormat:@"加料时间:%@",_trace.Add_alkali_Time]];
//    [jialiaoMenLabel_ setText:@"加料人：nfidj"];
    [chugangLabel_ setText:[NSString stringWithFormat:@"出缸时间:%@",_trace.Out_Time]];
//    [chugangMenLabel_ setText:@"出缸人：ndi"];
    [songyangLabel_ setText:[NSString stringWithFormat:@"送样时间:%@",_trace.Send_Sample_Time]];
//    [songyangMenLabel_ setText:[NSString stringWithFormat:@"送样人:%@",_trace.Send_Sample_Opertor]];
    [shouyangLabel_ setText:[NSString stringWithFormat:@"收样时间:%@",_trace.Receive_Sample_Time]];
    [shouyangMenLabel_ setText:[NSString stringWithFormat:@"收样人:%@",_trace.Receive_Toner]];
    [tiaosheshiLabel_ setText:[NSString stringWithFormat:@"调色师:%@",_trace.Worker_ID]];

}

- (void)updateRecipeTabel
{
    if (recipeTableView == nil) {
        recipeTableView = [[YDLabQueryTableView alloc] initWithFrame:CGRectMake(15, 157, 128, 588)];
        recipeTableView.delegate = self;
        recipeTableView.datas = recipesList_;
        [self.view addSubview:recipeTableView];
    }
    else {
        [self reloadRecipesData:recipesList_];
    }
    
}

- (void)reloadRecipesData:(NSMutableArray *)_recipes
{
    [recipeTableView reloadTableData:_recipes];
}

#pragma mark -0------
#pragma ---------- UITextFieldDelegate ---------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}

//更新配方进度的界面－－－上面的一部分－－－－
- (void)updateRecipProcessWith:(RecipetTraceInfo *)_info
{
    if ([_info.RecipeTraceAry count])
    {
       RTI_atb_RecipeTrace *trace = (RTI_atb_RecipeTrace *)[_info.RecipeTraceAry objectAtIndex:0];
        [self updateRecipeProcessWith:trace];
    }
    if ([_info.ChemicalInfoAry count])
    {
        [self setUpTable:_info.ChemicalInfoAry];
    }
}

#pragma mark -----------------
#pragma mark ---------获取网络数据  查询配方列表
- (void)queryRecipeWith:(NSString *)_batch_ColorCodeBatch
{
    [self queryRecipeWith:_batch_ColorCodeBatch result:^(NSArray *list){
        if ([recipesList_ count]) {
            [recipesList_ removeAllObjects];
        }
        if ([list count]) {
            for (id object in list)
            {
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    //                NSString *content = [(NSDictionary *)object objectForKey:@"Item_NO"];
                    YDRecipeForIndex *recipe = [[[YDRecipeForIndex alloc] initWith:(NSDictionary *)object] autorelease];
                    if (recipe)
                    {
                        [recipesList_ addObject:recipe];
                    }
                }
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无该缸号/色号信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
            [alert show];
            [alert release];
        }
        
        [self updateRecipeTabel];
    }];
}

- (void)queryRecipeWith:(NSString *)_batch_ColorCodeBatch result:(void (^)(NSArray *lists))block
{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 354);
    [self.view addSubview:loadingView];
    [loadingView release];
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_async(queryNetworkQueue,^{
        NSArray *lists = [networkDataMemberHandle GetRecipeNOList:_batch_ColorCodeBatch];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
//            NSLog(@"配方列表  。。。。。%@",lists);
            block(lists);
        });
        
    });

}

//查询配方进度
- (void)queryRecipeProcessWith:(NSString *)_recipeNo
{
    [self queryRecipeProcessWith:_recipeNo result:^(RecipetTraceInfo *info){
//        NSLog(@"info   ------ %@",info);
//        NSLog(@"recipe trace count %d",info.RecipeTraceAry.count);
//        NSLog(@"chemical info count %d",info.ChemicalInfoAry.count);
        [self updateRecipProcessWith:info];
    }];
}
- (void)queryRecipeProcessWith:(NSString *)_recipeNo result:(void (^)(RecipetTraceInfo *recipeTraceInfo))block
{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 354);
    [self.view addSubview:loadingView];
    [loadingView release];
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_async(queryNetworkQueue,^{
        RecipetTraceInfo *recipeInfoProcess = [networkDataMemberHandle GetRecipetTraceInfo:_recipeNo];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
//            NSLog(@"配方进度查询结果  。。。。。%@",lists);
            block(recipeInfoProcess);
        });
        
    });
    

}

#pragma mark--------
#pragma mark YDLabQueryTableViewDelegate
- (void)queryTabelView:(YDLabQueryTableView*)_tableView didSelectRow:(NSInteger)_row
{
    
    [self updateInterface];
    if (!first) {
//        [self setUpTable];
        first= 100;
    }
}

- (void)queryTabelView:(YDLabQueryTableView*)_tableView didSelectRow:(NSInteger)_row withRecipe:(NSString *)_recipe
{
//    [self queryRecipeProcessWith:_recipe];
    if (_recipe) {
        [self queryRecipeProcessWith:_recipe];
    }
}

@end
