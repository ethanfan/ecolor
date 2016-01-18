

#import "YDBulkProgressQueryViewController.h"
#import "YDAppDelegate.h"
#import "DataKit.h"
#import "YDRecipeForIndex.h"

@interface YDBulkProgressQueryViewController ()

- (void)updateInterface:(NSArray *)_list;

- (void)reloadUI;

//根据色号或者缸号查询配方列表
- (void)queryRecipeWith:(NSString *)_batch_ColorCodeBatch;
- (void)queryRecipeWith:(NSString *)_batch_ColorCodeBatch result:(void (^)(NSArray *lists))block;
//根据配方号查询配方进度
- (void)queryRecipeProcessWith:(NSString *)_recipeNo;
- (void)queryRecipeProcessWith:(NSString *)_recipeNo result:(void (^)(NSArray *recipeTraceInfo))block;

@end

@implementation YDBulkProgressQueryViewController

@synthesize  navigationBarImageView = navigationBarImageView_;
@synthesize  viewTypeImage = viewTypeImage_;
@synthesize  userImageView = userImageView_;
@synthesize  outputButton = outputButton_;
@synthesize  cancelButton = cancelButton_;
@synthesize  logoutButton = logoutButton_;
@synthesize backButton = backButton_;
@synthesize queryButton = queryButton_;

@synthesize informationScrollView = informationScrollView_;
@synthesize colorLabel = colorLabel_;  ///色号，缸号
@synthesize colorContentLabel=  colorContentLabel_;
@synthesize recipeNumberLabel = recipeNumberLabel_;
@synthesize mainInfoLabel = mainInfoLabel_;

@synthesize scandedCode = scandedCode_;

@synthesize recipesList = recipesList_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.recipesList = [NSMutableArray arrayWithCapacity:0];
        queryNetworkQueue = dispatch_queue_create("YDQueryNetworkQueue.YDBulkProgressQueryViewController", NULL);

    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.scandedCode = _scanedCode;
//        self.scandedCode = @"C2106723";
        self.recipesList = [NSMutableArray arrayWithCapacity:0];
        queryNetworkQueue = dispatch_queue_create("YDQueryNetworkQueue.YDBulkProgressQueryViewController", NULL);


    }
    return self;
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
    
    [ganghaoLabel_ release];
    [sehaoLabel_ release];
    [shazhiLabel_ release];
    [gangxingLabel_ release];
    [jitaiLabel_ release];
    [shaleiLabel_ release];
    [jingangshijianLabel_ release];
    [shapiLabel_ release];
    [fubanOKshijianLabel_ release];
    [duisheLabel_ release];
    [chugangLabel_ release];
    [hongganLabel_ release];
    [songQCLabel_ release];
    [diyiciLabel_ release];
    [QCLabel_ release];
    [beizhuLabel_ release];
    [detailTipLabel_ release];
    [dGanghaoLabel_ release];
    [paidanLabel_ release];
    [pinmingIDLabel_ release];
    [jingWLabel_ release];
    [weiWLabel_ release];
    [yuanshaLabel_ release];
    [touranLabel_ release];
    [recipesTable release];recipesTable = nil;
    
    [artCommentLabel_ release];
    
    [scandedCode_ release];scandedCode_ = nil;
    [recipesList_ release];recipesList_ = nil;
    dispatch_release(queryNetworkQueue);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:kColor];
    // Do any additional setup after loading the view from its nib.
    [colorContentLabel_ setText:scandedCode_];
    [colorContentLabel_ setFrame:CGRectMake(105, 60, 127, 38)];
    [colorLabel_ setBackgroundColor:[UIColor colorWithRed:174.0/255.0 green:168.0/255. blue:156/255.0 alpha:1.]];
	[colorContentLabel_ setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]];
	[recipeNumberLabel_ setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255. blue:141.0/255.0 alpha:1.]];
	[mainInfoLabel_ setBackgroundColor:[UIColor colorWithRed:174.0/255.0 green:168.0/255. blue:156/255.0 alpha:1.]];
    
	[informationScrollView_ setContentSize:CGSizeMake(859, 1024)];
	[informationScrollView_ setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]];

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
//	recipesTable = [[YDLabQueryTableView alloc] initWithFrame:CGRectMake(15, 157, 128, 588)];
//    recipesTable.delegate = self;
//    recipesTable.progress = YES;
//	[self.view addSubview:recipesTable];
//	[recipesTable release];
//    [self queryRecipeWith:scandedCode_];
    
    
    [self queryRecipeProcessWith:scandedCode_];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)updateRecipeTabel
{
    if (recipesTable == nil) 
    {
        recipesTable = [[YDLabQueryTableView alloc] initWithFrame:CGRectMake(15, 157, 128, 588)];
        recipesTable.delegate = self;
        recipesTable.progress = YES;
        recipesTable.datas = recipesList_;
        [self.view addSubview:recipesTable];
    }
    else {
        [self reloadRecipesData:recipesList_];
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation==UIInterfaceOrientationLandscapeLeft || 
	interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}


- (void)queryRecipeWith:(NSString *)_batch_ColorCodeBatch
{
    [self queryRecipeWith:_batch_ColorCodeBatch result:^(NSArray *list){
        if ([list count])
        {
            for (id object in list)
            {
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    YDRecipeForIndex *recipe = [[[YDRecipeForIndex alloc] initWith:object] autorelease];
                    //                NSString *content = [(NSDictionary *)object objectForKey:@"Item_NO"];
                    if (recipe)
                    {
                        [recipesList_ addObject:recipe];
                    }
                }
            }
            [self updateRecipeTabel];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无该配方信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
      
    }];
}


- (void)reloadRecipesData:(NSMutableArray *)_recipes
{
    [recipesTable reloadTableData:_recipes];
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
//根据配方号查询配方进度
- (void)queryRecipeProcessWith:(NSString *)_recipeNo
{
    [self queryRecipeProcessWith:_recipeNo result:^(NSArray *info){
//        NSLog(@"info   ------ %@",info);
//        [self updateRecipProcessWith:info];
        if ([info count]) {
              [self updateInterface:info];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无该缸号的在进度信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
      
    }];
}
- (void)queryRecipeProcessWith:(NSString *)_recipeNo result:(void (^)(NSArray *recipeTraceInfo))block
{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 354);
    [self.view addSubview:loadingView];
    [loadingView release];
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_async(queryNetworkQueue,^{
        NSArray *recipeInfoProcess = [networkDataMemberHandle GetBatchTraceInfo:_recipeNo];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
//            NSLog(@"进度跟踪查询结果  。。。。。%@",recipeInfoProcess);
            block(recipeInfoProcess);
        });
        
    });
    

}


- (YDAppDelegate *)YDAppDelegate
{
    return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (IBAction)queryButtonPress:(id)sender
{
    [recipesList_ removeAllObjects];
    [self reloadRecipesData:recipesList_];
    [colorContentLabel_ resignFirstResponder];
//    [self queryRecipeWith:colorContentLabel_.text];
    [self queryRecipeProcessWith:colorContentLabel_.text];

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


- (void)updateInterface:(NSArray *)_list
{
    if ([_list count])
    {
        
        
//        NSString * Batch_NO;//缸号
//        NSString * Color_Code;//色号
//        NSString * Machine_Model;//缸型
//        NSString * Machine_ID;//机台
//        NSString * Yarn_Type;//纱类
//        NSString * Yarn_Count;//纱支
//        NSString * Weight;//本缸重
//        NSString * Recipe_OK_Time;//复板OK时间
//        NSString * Dye_Time;//进缸时间
//        NSString * Check_Time;//对色时间
//        NSString * Send_QC_Time;//送QC时间
//        NSString * QC_Time;//QCOK时间
//        NSString * First_Dye_Time;//第一次进缸时间
//        NSString * Remark;//备注
//        NSString * Art_Comment;//工艺评审
        
       

        
        
        BatchTraceInfo *progress = (BatchTraceInfo *)[_list objectAtIndex:0];
        [artCommentLabel_ setText:[NSString stringWithFormat:@"工艺评审:%@",progress.Art_Comment]];
        [ganghaoLabel_ setText:[NSString stringWithFormat:@"缸号：%@",progress.Batch_NO]];
        [sehaoLabel_ setText:[NSString stringWithFormat:@"色号：%@",progress.Color_Code]];
        [shazhiLabel_ setText:[NSString stringWithFormat:@"纱支：%@",progress.Yarn_Count]];
        [gangxingLabel_ setText:[NSString stringWithFormat:@"缸型：%@",progress.Machine_Model]];
        [jitaiLabel_ setText:[NSString stringWithFormat:@"机台：%@",progress.Machine_ID]];
        [shaleiLabel_ setText:[NSString stringWithFormat:@"纱类：%@",progress.Yarn_Type]];
        [jingangshijianLabel_ setText:[NSString stringWithFormat:@"进缸时间：%@",progress.Dye_Time]];
        [shapiLabel_ setText:[NSString stringWithFormat:@"重量：%@",progress.Weight]];
        [fubanOKshijianLabel_ setText:[NSString stringWithFormat:@"复板OK时间：%@",progress.Recipe_OK_Time]];
        [duisheLabel_ setText:[NSString stringWithFormat:@"对色时间：%@",progress.Check_Time]];
        
        [chugangLabel_ setText:[NSString stringWithFormat:@"出缸时间：%@",progress.Finish_Time]];
        
        [hongganLabel_ setText:[NSString stringWithFormat:@"烘干时间：%@",progress.Check_Time]];
         
        [songQCLabel_ setText:[NSString stringWithFormat:@"送QC时间：%@",progress.Send_QC_Time]];
        [diyiciLabel_ setText:[NSString stringWithFormat:@"第一次进缸时间：%@",progress.First_Dye_Time]];
        [QCLabel_ setText:[NSString stringWithFormat:@"QC备注：%@",progress.QC_Time]];
        [beizhuLabel_ setText:[NSString stringWithFormat:@"备注：%@",progress.Remark]];
        
//        [dGanghaoLabel_ setText:[NSString stringWithFormat:@"缸号：%@",progress.Yarn_Count]];
//        [paidanLabel_ setText:[NSString stringWithFormat:@"排单：%@",progress.Yarn_Count]];
//        [pinmingIDLabel_ setText:[NSString stringWithFormat:@"品名ID：%@",progress.Yarn_Count]];
//        [jingWLabel_ setText:[NSString stringWithFormat:@"经向Weight：%@",progress.Yarn_Count]];
//        [weiWLabel_ setText:[NSString stringWithFormat:@"纬向Weight：%@",progress.Yarn_Count]];
//        [yuanshaLabel_ setText:[NSString stringWithFormat:@"原纱重量：%@",progress.Yarn_Count]];
//        [touranLabel_ setText:[NSString stringWithFormat:@"投染重量：%@",progress.Yarn_Count]];
        
        
        
//        
//        [ranshaLabel_ setText:[NSString stringWithFormat:@"染色交期：%@",info.Final_LB_Delivery_Date]];
//        [jingweiLabel_ setText:[NSString stringWithFormat:@"经/纬：%@",info.Warp_Weft]];
//        [gangxingLabel_ setText:[NSString stringWithFormat:@"缸型：%@",info.Machine_Model]];
//        [jitaiLabel_ setText:[NSString stringWithFormat:@"机台：%@",info.Machine_ID]];
//        [ganghaoLabel_ setText:[NSString stringWithFormat:@"缸号：%@",info.Batch_NO]];
//        [sehaoLabel_ setText:[NSString stringWithFormat:@"色号：%@",info.Color_Code]];
//        [zhuangtaiLabel_ setText:[NSString stringWithFormat:@"状态：%@",info.Color_Code]];
//        [yubiLabel_ setText:[NSString stringWithFormat:@"浴比：%@",info.Ratio]];
//        [fubanLabel_ setText:[NSString stringWithFormat:@"复板OK时间：%@",info.Recipe_OK_Time]];
//        [touranLabel_ setText:[NSString stringWithFormat:@"投染时间：%@",info.Dye_Time]];
//        [touranNumLabel_ setText:[NSString stringWithFormat:@"投染量：%@",info.Put_Dye_Weight]];
//        [tongziLabel_ setText:[NSString stringWithFormat:@"筒子数：%@",info.Cone_Num]];
//        [neiduiseLabel_ setText:[NSString stringWithFormat:@"内对色：%@",info.Check_Time]];
//        [duisejielunLabel_ setText:[NSString stringWithFormat:@"对色结论：%@",info.Check_Result]];
//        [pinmingLabel_ setText:[NSString stringWithFormat:@"品名：%@",info.GF_NO]];
//        [shapiLabel_ setText:[NSString stringWithFormat:@"批纱时间：%@",info.Yarn_Lot]];
//        [QCjielunLabel_ setText:[NSString stringWithFormat:@"QC结论：%@",info.QC_Result]];

    }

        
}

#pragma mark -0------
#pragma ---------- UITextFieldDelegate ---------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}

#pragma mark--------
#pragma mark YDLabQueryTableViewDelegate
- (void)queryTabelView:(YDLabQueryTableView*)_tableView didSelectRow:(NSInteger)_row
{
    
//    [self updateInterface];
    
}


- (void)queryTabelView:(YDLabQueryTableView*)_tableView didSelectRow:(NSInteger)_row withRecipe:(NSString *)_recipe
{
    //    [self queryRecipeProcessWith:_recipe];
    if (_recipe) {
        [self queryRecipeProcessWith:_recipe];
    }
    
}



@end
