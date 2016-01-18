//
//  YDBulkPalettesView.m
//  YiDa
//
//  Created by Ni on 12-11-15.
//  Copyright 2012 meson.com. All rights reserved.
//

#import "YDBulkPalettesView.h"


@interface YDBulkPalettesView ()


- (void)loadXIBView;
- (void)reloadDatasWith:(BatchInfo *)_batchinfo;
- (void)queryWith:(NSString *)_batch;
- (void)queryWith:(NSString *)_batch result:(void (^)(NSArray *list))block;

@end


@implementation YDBulkPalettesView

@synthesize containerView = containerView_;
@synthesize delegate;

@synthesize scanedCode = scanedCode_;
@synthesize colorCode = colorCode_;
@synthesize ratio = ratio_;

@synthesize firsDyeCotton = firsDyeCotton_;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self loadXIBView];
		ganghaoButton_.tag = YDPopoverTargetGanghao;
		pinmingButton_.tag = YDPopoverTargetPinMing;
        pinmingList_ = [[NSMutableArray arrayWithCapacity:0] retain];
        bulkPalettesQueue = dispatch_queue_create("YDBulkPalettes.YDBulkPalettesView", NULL); 
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withCode:(NSString *)_scanedCode
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self loadXIBView];
		ganghaoButton_.tag = YDPopoverTargetGanghao;
		pinmingButton_.tag = YDPopoverTargetPinMing;
        self.scanedCode = _scanedCode;
        [ganghaoButton_ setTitle:scanedCode_ forState:UIControlStateNormal];
                pinmingList_ = [[NSMutableArray arrayWithCapacity:0] retain];
        bulkPalettesQueue = dispatch_queue_create("YDBulkPalettes.YDBulkPalettesView", NULL);
        self.firsDyeCotton = @"1";
    }
    return self;
}

- (void)loadXIBView
{
	NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"YDXIBBulkPalettesView" owner:self options:nil];
	if ([views count])
	{
		self.containerView = (UIView *)[views lastObject];
		[self addSubview:containerView_];
	}
	
}

- (void)ganghaoButton:(UIButton *)_sender
{
//	YDPopoverViewController *popoverViewController = [[YDPopoverViewController alloc] initWithStyle:UITableViewStylePlain title:@"缸号" buttonType:_sender.tag delegate:self];
//    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:popoverViewController];
//    popover = [[UIPopoverController alloc] initWithContentViewController:nav];
//    popover.delegate = self;
//    [popover presentPopoverFromRect:_sender.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//    
//    [popoverViewController release];
//    [nav release];
}

- (void)pingmingButton:(UIButton *)_sender
{
	YDPopoverViewController *popoverViewController = [[YDPopoverViewController alloc] initWithStyle:UITableViewStylePlain title:@"品名" buttonType:_sender.tag delegate:self];
    popoverViewController.datas = pinmingList_;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:popoverViewController];
    popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    popover.delegate = self;
    [popover presentPopoverFromRect:_sender.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    [popoverViewController release];
    [nav release];
}



- (void)dealloc 
{
	[sehaoLabel_ release];
	[pishaLabel_ release];
	[gangxingLabel_ release];
	[yubiLabel_ release];
	[weightLabel_ release];
	[colorLabel_ release];
	[so4Label_ release];
	[co3Label_ release];
	[dateLabel_ release];
	[clearLabel_ release];
	[clientLabel_ release];
	[backupLabel_ release];  //工艺备注
	[computerLabel_ release];
    [batchLabel_ release];
	
	//tip
	 [sehaoLabelTip_ release];
	 [pishaLabelTip_ release];
	 [gangxingLabelTip_ release];
	 [yubiLabelTip_ release];
	 [weightLabelTip_ release];
	 [colorLabelTip_ release];
	  [so4LabelTip_ release];
	  [co3LabelTip_ release];
	  [dateLabelTip_ release];
	  [clearLabelTip_ release];
	  [clientLabelTip_ release];
	  [backupLabelTip_ release];  //工艺备注
	  [computerLabelTip_ release];
    [batchTip_ release];
	
	  [ganghaoButton_ release];
	  [pinmingButton_ release];
	
	
	  [image1_ release];
	  [image2_ release];
	  [image3_ release];
	  [image4_ release];
	  [image5_ release];
	  [image6_ release];
	  [image7_ release];
	  [image8_ release];
	  [image9_ release];
	  [image10_ release];
	  [image11_ release];
	  [image12_ release];
	  [image13_ release];
    [image14_ release];
    
    [scanedCode_ release];scanedCode_ = nil;
    [pinmingList_ release];pinmingList_ = nil;
    [colorCode_ release];colorCode_ =nil;
    [ratio_ release];ratio_ = nil;
    [firsDyeCotton_ release];firsDyeCotton_ = nil;
    dispatch_release(bulkPalettesQueue);
    [super dealloc];
}

- (void)reloadDatas
{
    [sehaoLabel_ setText:nil];
	[pishaLabel_ setText:nil];
	[gangxingLabel_ setText:nil];
	[yubiLabel_ setText:nil];
	[weightLabel_ setText:nil];
	[colorLabel_ setBackgroundColor:[UIColor blackColor]];
	[so4Label_ setText:nil];
	[co3Label_ setText:nil];
	[dateLabel_ setText:nil];
	[clearLabel_ setText:nil];
	[clientLabel_ setText:nil];
	[backupLabel_ setText:nil];  //工艺备注
	[computerLabel_ setText:nil];
    [batchLabel_ setText:nil];
}

- (void)reloadDatasWith:(BatchInfo *)_batchinfo
{
    int color = [_batchinfo.RGB intValue];
    int r = color/(256*256);
    int g = (color%(256*256)) / 256;
    int b = (color/(256*256)) % 256;
    
//    int r = 0xFF & color;
//    int g = 0xFF00 & color;
//    g >>= 8;
//    int b = 0xFF0000 & color;
//    b >>= 16;
    r = 0xFF & color;
    g = 0xFF00 & color;
    g >>= 8;
    b = 0xFF0000 & color;
    b >>= 16;
    
    NSLog(@"bulk rgb  r: %d g: %d b:%d",r,g,b);
     [colorLabel_ setBackgroundColor:[UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1.0]];
    
	[sehaoLabel_ setText:_batchinfo.Color_Code];
	[pishaLabel_ setText:_batchinfo.Yarn_Lot];
	[gangxingLabel_ setText:_batchinfo.Machine_Model];
	[yubiLabel_ setText:_batchinfo.Ratio];
	[weightLabel_ setText:_batchinfo.Weight];
	[so4Label_ setText:_batchinfo.Ns2So4];
	[co3Label_ setText:_batchinfo.Na2Co3];
	[dateLabel_ setText:_batchinfo.Delivery_Date];
	[clearLabel_ setText:_batchinfo.Final_LB_Delivery_Date];
	[clientLabel_ setText:_batchinfo.Customer];
	[backupLabel_ setText:_batchinfo.Remark];  //工艺备注
	[computerLabel_ setText:_batchinfo.QAHints];
     [pinmingList_ addObjectsFromArray:[_batchinfo.GF_NO componentsSeparatedByString:@","]];
    [batchLabel_ setText:_batchinfo.Batch_Delivery_Date];
    
    if ([pinmingList_ count]) {
        [pinmingButton_ setTitle:[pinmingList_ objectAtIndex:0] forState:UIControlStateNormal];
    }
    self.colorCode = _batchinfo.Color_Code;
    self.ratio = _batchinfo.Ratio;
    self.firsDyeCotton = @"1";
//    不为空的时候提示用户
    if ([_batchinfo.Hints length]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_batchinfo.Hints delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
    }
    else if (delegate != nil && [delegate respondsToSelector:@selector(didFinishQueryBatchInfo:withRato:firstDye:)])
    {
        [delegate didFinishQueryBatchInfo:_batchinfo.Color_Code withRato:_batchinfo.Ratio firstDye:firsDyeCotton_];
    }
    
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"确定 %d  取消  ",buttonIndex);
    if (buttonIndex == 1) {
        self.firsDyeCotton = [NSString stringWithFormat:@"%d",0];

    }
//    if (delegate != nil && [delegate respondsToSelector:@selector(didFinishQueryBatchInfo:withRato:)])
//    {
//        [delegate didFinishQueryBatchInfo:colorCode_ withRato:ratio_];
//    }
    
    if (delegate != nil && [delegate respondsToSelector:@selector(didFinishQueryBatchInfo:withRato:firstDye:)])
    {
        [delegate didFinishQueryBatchInfo:colorCode_ withRato:ratio_ firstDye:firsDyeCotton_];
    }

}

- (void)updateButtonTitleWith:(NSString *)_buttonTitle 
				   buttonType:(NSInteger )_buttonType
{
	NSInteger type = _buttonType;
	switch (type) {
		case YDPopoverTargetGanghao:
		{
//			colorViewState_ = YDColorViewStateColor;
			[ganghaoButton_ setTitle:_buttonTitle forState:UIControlStateNormal];
//			[self postViewState];
		}
			break;
		case YDPopoverTargetPinMing:
		{
			[pinmingButton_ setTitle:_buttonTitle forState:UIControlStateNormal];
//			colorViewState_ = YDColorViewStateKDNO;
//			[self reloadDatas];

		}
			
			break;
			
		default:
			break;
	}
}

- (void)didMoveToSuperview
{
    if (!self.superview) return;
    [self queryWith:scanedCode_];
}

- (void)queryWith:(NSString *)_batch
{
    [self queryWith:_batch result:^(NSArray *resultsList){
        if ([resultsList count]) 
        {
            BatchInfo *batch = (BatchInfo *)[resultsList objectAtIndex:0];
            [self reloadDatasWith:batch];
        }
    }];
}
- (void)queryWith:(NSString *)_batch result:(void (^)(NSArray *list))block
{
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 80);
    [self addSubview:loadingView];
    [loadingView release];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_async(bulkPalettesQueue,^{
        NSArray *lists = [networkDataMemberHandle GetBatchInfo:_batch];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
            block(lists);
        });
        
    });

}

#pragma mark ------
#pragma mark YDPopoverViewDelegate

- (void)targetForPopoverView:(YDPopoverViewController *)_popoverViewController 
					 content:(NSString *)_content 
				  buttonType:(NSInteger )_buttonType
{
	[self updateButtonTitleWith:_content buttonType:_buttonType];
	[popover dismissPopoverAnimated:YES];
}

@end
