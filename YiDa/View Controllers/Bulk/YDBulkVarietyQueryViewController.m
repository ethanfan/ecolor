

#import "YDBulkVarietyQueryViewController.h"
#import "YDAppDelegate.h"

#define kWidthSize CGSizeMake(10000000,30)
#define kFont    [UIFont systemFontOfSize:17]
//systemFontOfSize:(CGFloat)fontSize
//这些是表格中标题的长度，如果内容的长度比这个还小，这一列的宽度就使用这个
#define kIdenTitleWidth  34    //Iden 缸型 机台 缸号 色号 浴比 品名 纱批
#define kDelieveryDateTitleWidth 51  //交板期 投染量 筒子数 内对色
#define kWarpWeftTitleWidth   39          //经纬
#define kRecipe_OK_TimeTitleWidth 93     //复板ok时间
#define kDye_TimeTitleWidth 68            //对色结论 投染时间
#define kQCTimeTitleWidth 60          //qc时间 qc结论




@interface YDBulkVarietyQueryViewController ()

- (void)updateInterface;

- (void)updateDateTimeTable:(NSMutableArray *)_recipes;

//处理用于显示在界面的列的数据的长度
- (void)proccessDatas;
//画表格，其实就是把view放到scrollview里面
- (void)drawTable;

//查询该大货排期所在的数组的索引，然后把该数据取出来显示在界面
- (NSInteger)indexOfObjectInTotalProgress:(NSString *)_date;
- (NSMutableArray *)createRecipeList:(NSMutableArray *)_array;

- (void)queryVarietyProcess:(NSString *)_code;
- (void)queryVarietyProcess:(NSString *)_code result:(void(^)(NSArray *lists))block;

@end

@implementation YDBulkVarietyQueryViewController

@synthesize  navigationBarImageView = navigationBarImageView_;
@synthesize  viewTypeImage = viewTypeImage_;
@synthesize  userImageView = userImageView_;
@synthesize  outputButton = outputButton_;
@synthesize  cancelButton = cancelButton_;
@synthesize  logoutButton = logoutButton_;
@synthesize backButton = backButton_;

@synthesize queryButton = queryButton_;

@synthesize tableView = tableView_;

@synthesize informationScrollView = informationScrollView_;
@synthesize colorLabel = colorLabel_;  ///色号，缸号
@synthesize colorContentLabel=  colorContentLabel_;
@synthesize recipeNumberLabel = recipeNumberLabel_;
@synthesize mainInfoLabel = mainInfoLabel_;
@synthesize scanedCode = scanedCode_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        queryNetworkQueue = dispatch_queue_create("YDQueryNetworkQueue.YDBulkVarietyQueryViewController", NULL);
        recipesList_ = [[NSMutableArray arrayWithCapacity:8] retain];
        datasList_ = [[NSMutableArray arrayWithCapacity:8] retain];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         queryNetworkQueue = dispatch_queue_create("YDQueryNetworkQueue.YDBulkVarietyQueryViewController", NULL);
        self.scanedCode = _scanedCode;
//         self.scanedCode = @"Z2110533";
        recipesList_ = [[NSMutableArray arrayWithCapacity:8] retain];
        datasList_ = [[NSMutableArray arrayWithCapacity:8] retain];

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
    
    [ranshaLabel_ release];
    [jingweiLabel_ release];
    [gangxingLabel_ release];
    [jitaiLabel_ release];
    [ganghaoLabel_ release];
    [sehaoLabel_ release];
    [zhuangtaiLabel_ release];
    [yubiLabel_ release];
    [fubanLabel_ release];
    [touranLabel_ release];
    [touranNumLabel_ release];
    [tongziLabel_ release];
    [neiduiseLabel_ release];
    [duisejielunLabel_ release];
    [pinmingLabel_ release];
    [shapiLabel_ release];
    [QCjielunLabel_ release];
    
    [tableView_ release];tableView_ = nil;

    [scanedCode_ release];scanedCode_ = nil;
    [recipesList_ release];recipesList_ = nil;
    [datasList_ release];datasList_ = nil;
    
    dispatch_release(queryNetworkQueue);

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:kColor];
    // Do any additional setup after loading the view from its nib.
    [colorContentLabel_ setText:scanedCode_];
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
//	YDLabQueryTableView *t = [[YDLabQueryTableView alloc] initWithFrame:CGRectMake(15, 157, 128, 588)];
//    t.delegate = self;
//    self.tableView = t;
//	[self.view addSubview:t];
//	[t release];
    
    [self queryVarietyProcess:scanedCode_];
}


- (void)updateDateTimeTable:(NSMutableArray *)_recipes
{
    [tableView_ reloadTableData:_recipes];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation==UIInterfaceOrientationLandscapeLeft || 
	interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (YDAppDelegate *)YDAppDelegate
{
    return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}



- (void)reloadRecipesData:(NSMutableArray *)_recipes
{
    
}

- (IBAction)queryButtonPress:(id)sender
{
    
    NSString *inputString = colorContentLabel_.text;
    if ([inputString length] && ![inputString isEqualToString:scanedCode_])
    {
    //      查询前先清空之前的数据，并刷新界面
        [recipesList_ removeAllObjects];
    //    [self updateDateTimeTable:recipesList_];
        NSArray *subviews = [informationScrollView_ subviews];
        [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self updateInterface];
        [colorContentLabel_ resignFirstResponder];
        [self queryVarietyProcess:colorContentLabel_.text];
    }
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

#pragma mark -0------
#pragma ---------- UITextFieldDelegate ---------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    return YES;
}


- (void)updateInterface
{
//    if ([datasList_ count])
//    {
//        TotalProgressInfo *info = (TotalProgressInfo *)[datasList_ objectAtIndex:0];
        [ranshaLabel_ setText:@"染色交期："];
        [jingweiLabel_ setText:@"经/纬:"];
        [gangxingLabel_ setText:@"缸型："];
        [jitaiLabel_ setText:@"机台："];
        [ganghaoLabel_ setText:@"缸号："];
        [sehaoLabel_ setText:@"色号："];
        [zhuangtaiLabel_ setText:@"状态："];
        [yubiLabel_ setText:@"浴比："];
        [fubanLabel_ setText:@"复板OK时间:"];
        [touranLabel_ setText:@"投染："];
        [touranNumLabel_ setText:@"投染量："];
        [tongziLabel_ setText:@"筒子数："];
        [neiduiseLabel_ setText:@"内对色："];
        [duisejielunLabel_ setText:@"对色结论："];
        [pinmingLabel_ setText:@"品名："];
        [shapiLabel_ setText:@"批纱："];
        [QCjielunLabel_ setText:@"QC结论:"];
//    }
    

}

- (void)updateInterface:(TotalProgressInfo *)_info
{
    if (_info) {



        

        
        
//        NSString *QC_Time;//QC时间
        
        TotalProgressInfo *info = _info;
        [ranshaLabel_ setText:[NSString stringWithFormat:@"染色交期：%@",info.Final_LB_Delivery_Date]];
        [jingweiLabel_ setText:[NSString stringWithFormat:@"经/纬：%@",info.Warp_Weft]];
        [gangxingLabel_ setText:[NSString stringWithFormat:@"缸型：%@",info.Machine_Model]];
        [jitaiLabel_ setText:[NSString stringWithFormat:@"机台：%@",info.Machine_ID]];
        [ganghaoLabel_ setText:[NSString stringWithFormat:@"缸号：%@",info.Batch_NO]];
        [sehaoLabel_ setText:[NSString stringWithFormat:@"色号：%@",info.Color_Code]];
        
//        [zhuangtaiLabel_ setText:[NSString stringWithFormat:@"状态：%@",info.Color_Code]];
        
        [yubiLabel_ setText:[NSString stringWithFormat:@"浴比：%@",info.Ratio]];
        [fubanLabel_ setText:[NSString stringWithFormat:@"复板OK时间：%@",info.Recipe_OK_Time]];
        [touranLabel_ setText:[NSString stringWithFormat:@"投染时间：%@",info.Dye_Time]];
        [touranNumLabel_ setText:[NSString stringWithFormat:@"投染量：%@",info.Put_Dye_Weight]];
        [tongziLabel_ setText:[NSString stringWithFormat:@"筒子数：%@",info.Cone_Num]];
        [neiduiseLabel_ setText:[NSString stringWithFormat:@"内对色：%@",info.Check_Time]];
        [duisejielunLabel_ setText:[NSString stringWithFormat:@"对色结论：%@",info.Check_Result]];
        [pinmingLabel_ setText:[NSString stringWithFormat:@"品名：%@",info.GF_NO]];
        [shapiLabel_ setText:[NSString stringWithFormat:@"批纱：%@",info.Yarn_Lot]];
        [QCjielunLabel_ setText:[NSString stringWithFormat:@"QC结论：%@",info.QC_Result]];
    }

}

- (void)drawTable
{
    NSInteger count = [datasList_ count];
    for (int i = 0; i<count; i++) {
//        第一列
//        第一列的标题
        NSInteger titleTag = 99901;
        UITextField *tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake(0, 30*i, column1, 30)];
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.enabled = NO;
            tlabel.tag = titleTag;
            //            [label setText:@"222"];
              [tlabel setText:@"Iden"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
      
        
        TotalProgressInfo *info = (TotalProgressInfo *)[datasList_ objectAtIndex:i];
        NSInteger tag = 10000+i+1;
        UITextField *label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake(0, 30*i+30, column1, 30)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.enabled = NO;
            label.tag = tag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Iden];
//        第二列
         titleTag = 99902;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column2Width] , 30*i, column2, 30)];
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            tlabel.enabled = NO;
            //            [label setText:@"222"];
            [tlabel setText:@"交板期"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
        
        
        tag = 20000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column2Width], 30*i+30, column2, 30)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            label.enabled = NO;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Final_LB_Delivery_Date];
        
//        第三列
        titleTag = 99903;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column3Width], 30*i, column3, 30)];
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            tlabel.enabled = NO;
            //            [label setText:@"222"];
             [tlabel setText:@"经／纬"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
       
        
        tag = 30000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column3Width], 30*i+30, column3, 30)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.enabled = NO;
            label.tag = tag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Warp_Weft];
        
//        第四列
        titleTag = 99904;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column4Width], 30*i, column4, 30)];
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.enabled = NO;
            tlabel.tag = titleTag;
            //            [label setText:@"222"];
              [tlabel setText:@"缸型"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
      
        
        tag = 40000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column4Width], 30*i+30, column4, 30)];
            [label setBackgroundColor:[UIColor clearColor]];
            label.enabled = NO;
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Machine_Model];
        
//        第五列
        titleTag = 99905;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column5Width], 30*i, column5, 30)];
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            tlabel.enabled = NO;
            [tlabel setText:@"机台"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
        
        
        tag = 50000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column5Width], 30*i+30, column5, 30)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            label.enabled = NO;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Machine_ID];
        
//        第六列
        titleTag = 99906;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column6Width], 30*i, column6, 30)];
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            tlabel.enabled = NO;
            //            [label setText:@"222"];
             [tlabel setText:@"缸号"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
       
        
        tag = 60000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column6Width], 30*i+30, column6, 30)];
            label.enabled = NO;
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Batch_NO];
        
//        第七列
        titleTag = 99907;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column7Width], 30*i, column7, 30)];
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            tlabel.enabled = NO;
            //            [label setText:@"222"];
             [tlabel setText:@"色号"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
       
        
        tag = 70000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column7Width], 30*i+30, column7, 30)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.enabled = NO;
            label.tag = tag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Color_Code];
        
//        第八列
        titleTag = 99908;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column8Width], 30*i, column8, 30)];
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            tlabel.enabled = NO;
            //            [label setText:@"222"];
            [tlabel setText:@"浴比"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
        
        
        tag = 80000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column8Width], 30*i+30, column8, 30)];
            label.enabled = NO;
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Ratio];
        
//        第九列
        titleTag = 99909;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column9Width], 30*i, column9, 30)];
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            tlabel.enabled = NO;
            //            [label setText:@"222"];
            [tlabel setText:@"复板OK时间"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
        
        
        tag = 90000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column9Width], 30*i+30, column9, 30)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            label.enabled = NO;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Recipe_OK_Time];
        
//        第十列
        titleTag = 99910;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column10Width], 30*i, column10, 30)];
            tlabel.enabled = NO;
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            //            [label setText:@"222"];
            [tlabel setText:@"投染时间"];
            [informationScrollView_ addSubview:tlabel];
            
            [tlabel release];
        }
        
        
        tag = 100000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column10Width], 30*i+30, column10, 30)];
            label.enabled = NO;
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Dye_Time];
        
//        第11列
        titleTag = 99911;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column11Width], 30*i, column11, 30)];
            tlabel.enabled = NO;
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            //            [label setText:@"222"];
              [tlabel setText:@"投染量"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
      
        
        tag = 110000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column11Width], 30*i+30, column11, 30)];
            label.enabled = NO;
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Put_Dye_Weight];
        
//        第12列
        titleTag = 99912;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column12Width], 30*i, column12, 30)];
            tlabel.enabled = NO;
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            //            [label setText:@"222"];
             [tlabel setText:@"筒子数"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
       
        
        tag = 120000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column12Width], 30*i+30, column12, 30)];
            label.enabled = NO;
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Cone_Num];
        
//        第13列
        titleTag = 99913;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column13Width], 30*i, column13, 30)];
            tlabel.enabled = NO;
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            //            [label setText:@"222"];
            [tlabel setText:@"内对色时间"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
        
        
        tag = 130000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column13Width], 30*i+30, column13, 30)];
            label.enabled = NO;
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Check_Time];
        
//        第14列
        titleTag = 99914;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column14Width], 30*i, column14, 30)];
            tlabel.enabled = NO;
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            //            [label setText:@"222"];
            [tlabel setText:@"对色结论"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
        
        
        tag = 140000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column14Width], 30*i+30, column14, 30)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            label.enabled = NO;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Check_Result];
        
//        第15列
        titleTag = 99915;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column15Width], 30*i, column15, 30)];
            tlabel.enabled = NO;
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            //            [label setText:@"222"];
             [tlabel setText:@"品名"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
       
        
        tag = 150000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column15Width], 30*i+30, column15, 30)];
            label.enabled = NO;
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.GF_NO];
        
        
//        第16列
        titleTag = 99916;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column16Width], 30*i, column16, 30)];
            tlabel.enabled = NO;
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            //            [label setText:@"222"];
            [tlabel setText:@"纱批"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
        
        
        tag = 160000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column16Width], 30*i+30, column16, 30)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            label.enabled = NO;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.Yarn_Lot];
        
//        第17列
        titleTag = 99917;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column17Width], 30*i, column17, 30)];
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            tlabel.enabled = NO;
            //            [label setText:@"222"];
            [tlabel setText:@"QC时间"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel release];
        }
        
        
        tag = 170000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column17Width], 30*i+30, column17, 30)];
            label.enabled = NO;
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.QC_Time];
        
//        第18列
        titleTag = 99918;
        tlabel = (UITextField *)[informationScrollView_ viewWithTag:titleTag];
        if (tlabel== nil)
        {
            tlabel = [[UITextField alloc] initWithFrame:CGRectMake([self column18Width], 30*i, column18, 30)];
            tlabel.enabled = NO;
            [tlabel setBackgroundColor:[UIColor clearColor]];
            [tlabel setFont:kFont];
            [tlabel setTextAlignment:UITextAlignmentCenter];
            [tlabel setBorderStyle:UITextBorderStyleLine];
            tlabel.tag = titleTag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:tlabel];
            [tlabel setText:@"QC结论"];
            [tlabel release];
        }
        
        
        tag = 180000+i+1;
        label = (UITextField *)[informationScrollView_ viewWithTag:tag];
        if (label== nil)
        {
            label = [[UITextField alloc] initWithFrame:CGRectMake([self column18Width], 30*i+30, column18, 30)];
            label.enabled = NO;
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBorderStyle:UITextBorderStyleLine];
            [label setFont:kFont];
            label.tag = tag;
            //            [label setText:@"222"];
            [informationScrollView_ addSubview:label];
            [label release];
        }
        [label setText:info.QC_Result];
        
        
    }
    
    [informationScrollView_ setContentSize:CGSizeMake([self scrollviewScrollWidth], [self scrollviewScrollHeight])];
}

- (NSInteger)indexOfObjectInTotalProgress:(NSString *)_date
{
    NSInteger index = NSNotFound;
    NSPredicate *format = [NSPredicate predicateWithFormat:@"Iden == %@",_date];
    NSArray *array = [datasList_ filteredArrayUsingPredicate:format];
    if ([array count])
    {
        TotalProgressInfo *t = (TotalProgressInfo *)[array objectAtIndex:0];
        index = [datasList_ indexOfObject:t];
    }
    
   
    return index;
}

- (void)proccessDatas
{
    __block CGFloat c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18;
    c1 = c4 = c5 = c6 =c7 = c8 = c15 = c16= kIdenTitleWidth;
    c2 = c11 = c12 =  kDelieveryDateTitleWidth;
    c3 = kWarpWeftTitleWidth;
    c9 = kRecipe_OK_TimeTitleWidth;
    c10 = c14 = kDye_TimeTitleWidth;
    c17 = c18 = kQCTimeTitleWidth;
    c13 = c9;
    [datasList_ enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TotalProgressInfo *info = (TotalProgressInfo *)obj;
         CGSize size = [info.Iden sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c1) {
            c1 = size.width;
        }
         size = [info.Final_LB_Delivery_Date sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c2) {
            c2= size.width;
        }
        size = [info.Warp_Weft sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c3) {
            c3 = size.width;
        }
        size = [info.Machine_Model sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c4) {
            c4 = size.width;
        }
        size = [info.Machine_ID sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c5) {
            c5 = size.width;
        }
        size = [info.Batch_NO sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c6 ) {
            c6 =size.width;
        }
        size = [info.Color_Code sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c7) {
            c7 = size.width;
        }
        size = [info.Ratio sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c8) {
            c8 = size.width;
        }
        size = [info.Recipe_OK_Time sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c9 ) {
            c9 = size.width;
        }
        size = [info.Dye_Time sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width > c10) {
            c10 = size.width;
        }
        size = [info.Put_Dye_Weight sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c11) {
            c11 = size.width;
        }
        size = [info.Cone_Num sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c12) {
            c12 = size.width;
        }
        size = [info.Check_Time sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c13) {
            c13 = size.width;
        }
        size = [info.Check_Result sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c14) {
            c14 = size.width;
        }
        size = [info.GF_NO sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c15) {
            c15 = size.width;
        }
        size = [info.Yarn_Lot sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c16) {
            c16 = size.width;
        }
        size = [info.QC_Time sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c17) {
            c17 = size.width;
        }
        size = [info.QC_Result sizeWithFont:kFont constrainedToSize:kWidthSize lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width >c18) {
            c18 = size.width;
        }
    }];
    [self setColumn1:c1+20];
    [self setColumn2:c2+20];
    [self setColumn3:c3+20];
    [self setColumn4:c4+20];
    [self setColumn5:c5+20];
    [self setColumn6:c6+20];
    [self setColumn7:c7+20];
    [self setColumn8:c8+20];
    [self setColumn9:c9+20];
    [self setColumn10:c10+20];
    [self setColumn11:c11+20];
    [self setColumn12:c12+20];
    [self setColumn13:c13+20];
    [self setColumn14:c14+20];
    [self setColumn15:c15+20];
    [self setColumn16:c16+20];
    [self setColumn17:c17+20];
    [self setColumn18:c18+20];
    
    NSLog(@"1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f",column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,column13,column14,column15,column16,column17,column18);
    
}


//取出大货交期列表
- (NSMutableArray *)createRecipeList:(NSMutableArray *)_array
{
    NSMutableArray *recipes = [NSMutableArray arrayWithCapacity:[_array count]];
    for (id obj in _array) {
        TotalProgressInfo *t = (TotalProgressInfo *)obj;
        if ([t.Iden length]) {
              [recipes addObject:t.Iden];
        }
      
    }
    if (![recipes count])
    {
        return nil;
    }
    
    return  recipes;
}

- (void)queryVarietyProcess:(NSString *)_code
{
    [self queryVarietyProcess:_code result:^(NSArray *lists){
        [datasList_ removeAllObjects];
        [recipesList_ removeAllObjects];
        if ([lists count]) {
            [datasList_ addObjectsFromArray:lists];
            
            [self proccessDatas];
            [self drawTable];
            
            [recipesList_ addObjectsFromArray:[self createRecipeList:datasList_]];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂时没有该配方的进度" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
        [self updateDateTimeTable:recipesList_];
        [self updateInterface];
    }];
}

- (void)queryVarietyProcess:(NSString *)_code result:(void(^)(NSArray *lists))block
{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 354);
    [self.view addSubview:loadingView];
    [loadingView release];
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_async(queryNetworkQueue,^{
        NSArray *lists = [networkDataMemberHandle GetTotalProgressInfo:_code];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
//            NSLog(@"品种进度查询  。。。。。%@",lists);
            block(lists);
        });
        
    });
    

}

#pragma mark--------
#pragma mark YDLabQueryTableViewDelegate
//- (void)queryTabelView:(YDLabQueryTableView*)_tableView didSelectRow:(NSInteger)_row
//{
//    
//    [self updateInterface];
//
//}

- (void)queryTabelView:(YDLabQueryTableView*)_tableView didSelectRow:(NSInteger)_row withRecipe:(NSString *)_recipe
{
    NSInteger index = [self indexOfObjectInTotalProgress:_recipe];
    if (index != NSNotFound) 
    {
        TotalProgressInfo *t = (TotalProgressInfo *)[datasList_ objectAtIndex:index];
        [self updateInterface:t];
    }
}

#pragma mark ----------
#pragma ------------- 设置列宽
- (void)setColumn1:(CGFloat )_width
{
    column1 = _width;
}

- (void)setColumn2:(CGFloat )_width
{
    column2 = _width;
}

- (void)setColumn3:(CGFloat )_width
{
    column3 = _width;
}

- (void)setColumn4:(CGFloat )_width
{
    column4 = _width;
}

- (void)setColumn5:(CGFloat )_width
{
    column5 = _width;
}
- (void)setColumn6:(CGFloat )_width
{
    column6 = _width;
}

- (void)setColumn7:(CGFloat )_width
{
    column7 = _width;
}

- (void)setColumn8:(CGFloat )_width
{
    column8 = _width;
}

- (void)setColumn9:(CGFloat )_width
{
    column9 = _width;
}

- (void)setColumn10:(CGFloat )_width
{
    column10 = _width;
}

- (void)setColumn11:(CGFloat )_width
{
    column11 = _width;
}

- (void)setColumn12:(CGFloat )_width
{
    column12 = _width;
}

- (void)setColumn13:(CGFloat )_width
{
    column13 = _width;
}

- (void)setColumn14:(CGFloat )_width
{
    column14 = _width;
}

- (void)setColumn15:(CGFloat )_width
{
    column15 = _width;
}

- (void)setColumn16:(CGFloat )_width
{
    column16 = _width;
}

- (void)setColumn17:(CGFloat )_width
{
    column17 = _width;
}

- (void)setColumn18:(CGFloat )_width
{
    column18 = _width;
}



-(CGFloat)column1Width
{
    return 0;
}

-(CGFloat)column2Width
{
    return column1;
}

-(CGFloat)column3Width
{
    return column1+column2;
}

-(CGFloat)column4Width
{
    return [self column3Width]+column3;
}

-(CGFloat)column5Width
{
    return [self column4Width]+column4;
}

-(CGFloat)column6Width
{
    return [self column5Width]+column5;
}

-(CGFloat)column7Width
{
    return [self column6Width]+column6;
}

-(CGFloat)column8Width
{
    return [self column7Width]+column7;
}

-(CGFloat)column9Width
{
    return [self column8Width]+column8;
}

-(CGFloat)column10Width
{
    return [self column9Width]+column9;
}

-(CGFloat)column11Width
{
    return [self column10Width]+column10;
}

-(CGFloat)column12Width
{
    return [self column11Width]+column11;
}

-(CGFloat)column13Width
{
    return [self column12Width]+column12;
}

-(CGFloat)column14Width
{
    return [self column13Width]+column13;
}

-(CGFloat)column15Width
{
    return [self column14Width]+column14;
}

-(CGFloat)column16Width
{
    return [self column15Width]+column15;
}

-(CGFloat)column17Width
{
    return [self column16Width]+column16;
}

-(CGFloat)column18Width
{
    return [self column17Width]+column17;
}



- (CGFloat)scrollviewScrollWidth
{
    CGFloat width = column1+column10+column11+column12+column13+column14+column15+column16+column17+column18+column2+column3+column4+column5+column6+column7+column8+column9;
    return width;
}

- (CGFloat)scrollviewScrollHeight
{
    NSInteger count = [datasList_ count];
    return count*30;
}


















@end
