//
//  YDColorNumberSelectView.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDColorNumberSelectView.h"
#import "YDPopoverViewController.h"

#define ItemKey @"Item_NO"


@interface YDColorNumberSelectView ()

- (void)setUpBackground;

- (void)setUpContentInterface;

- (void)setUpContents;

- (void)updateButtonTitleWith:(NSString *)_buttonTitle 
				   buttonType:(NSInteger )_buttonType;

- (void)kdnoButtonPress:(UIButton *)_sender;

- (void)colorButtonPress:(UIButton *)_sender;
- (void)reloadState;
- (void)postViewState;

- (void)updateUIWith:(LBInfo *)_information;
- (void)reloadDatas:(LBInfo *)_information;

//获取开单号／颜色值/来样单信息
- (void)queryKDNO;
- (void)queryColor;
- (void)queryLBInformation;

//根据扫描得来的码去查询开单号
- (void)queryKDNOWith:(NSString *)_LBNO resultBlock:(void (^)(NSArray *lists))block;
//根据开单号和扫描得来得码查询颜色值
- (void)queryColorListWith:(NSString *)_LBNO withKDNO:(NSString *)_KDNO resultBlock:(void (^)(NSArray *list))block;

- (void)queryLBInformationWith:(NSString *)_KDNO withColorCode:(NSString *)_ColorCode:(void (^)(LBInfo *))block; 

@end

@implementation YDColorNumberSelectView

@synthesize LBNOimageView = LBNOimageView_;
@synthesize colorImageView = colorImageView_;
@synthesize loWeightImageView = loWeightImageView_;//经向重量
@synthesize laWeightImageView = laWeightImageView_;//纬向重量
@synthesize dateImageView = dateImageView_;
@synthesize clearImageView = clearImageView_;//整理
@synthesize clientImageView = clientImageView_;

@synthesize LBNOlabel = LBNOlabel_;
@synthesize colorLabel = colorLabel_;
@synthesize loWeightLabel = loWeightLabel_;
@synthesize laWeightLabel = laWeightLabel_;
@synthesize dateLabel = dateLabel_;
@synthesize clearLabel = clearLabel_;
@synthesize clientLabel = clientLabel_;

@synthesize KDNObutton = KDNObutton_;
@synthesize colorButton = colorButton_;


@synthesize LBNOContentlabel = LBNOContentlabel_;
@synthesize colorContentLabel = colorContentLabel_;
@synthesize loWeightContentLabel = loWeightContentLabel_;
@synthesize laWeightContentLabel = laWeightContentLabel_;
@synthesize dateContentLabel = dateContentLabel_;
@synthesize clearContentLabel = clearContentLabel_;
@synthesize clientContentLabel = clientContentLabel_;

@synthesize  popoverTargetType = popoverTargetType_;
@synthesize  colorViewState = colorViewState_;

@synthesize delegate;


@synthesize LBClient = LBClient_;
@synthesize LBFinishList = LBFinishList_;
@synthesize currentWeight  = currentWeight_;

@synthesize LBNO = LBNO_;
@synthesize KDNO = KDNO_;
@synthesize currentColorCode = currentColorCode_;

@synthesize LBInformationDetail = LBInformationDetail_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        reselectKDNO = NO;
		colorViewState_ = YDColorViewStateNone;
        [self setUpBackground];
        [self setUpContentInterface];
        [self setUpContents];
        kdnoQueue = dispatch_queue_create("YDKDNOQueue.YDColorNumberSelectView", NULL);
        KDNOLists = [[NSMutableArray arrayWithCapacity:0] retain];
        colorsLists = [[NSMutableArray arrayWithCapacity:0] retain];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame popoverTargetType:(YDPopoverTargetTypeOption )_targetType
{
	self = [super initWithFrame:frame];
    if (self) {
        reselectKDNO = NO;
		colorViewState_ = YDColorViewStateNone;
		popoverTargetType_= _targetType;
        [self setUpBackground];
        [self setUpContentInterface];
        [self setUpContents];
        kdnoQueue = dispatch_queue_create("YDKDNOQueue.YDColorNumberSelectView", NULL);
        KDNOLists = [[NSMutableArray arrayWithCapacity:0] retain];
        colorsLists = [[NSMutableArray arrayWithCapacity:0] retain];
    }
    return self;
	
}
- (id)initWithFrame:(CGRect)frame popoverTargetType:(YDPopoverTargetTypeOption )_targetType withLBNO:(NSString *)_LBNO
{
    self = [super initWithFrame:frame];
    if (self) {
        reselectKDNO = NO;
        self.LBNO = _LBNO;
		colorViewState_ = YDColorViewStateNone;
		popoverTargetType_= _targetType;
        [self setUpBackground];
        [self setUpContentInterface];
        [self setUpContents];
        kdnoQueue = dispatch_queue_create("YDKDNOQueue.YDColorNumberSelectView", NULL);
        KDNOLists = [[NSMutableArray arrayWithCapacity:0] retain];
        colorsLists = [[NSMutableArray arrayWithCapacity:0] retain];
        
    }
    return self;
}

- (void)dealloc
{
    self.LBNO = nil;
    [KDNO_ release];KDNO_ = nil;
    [LBClient_ release];LBClient_ = nil;
    [LBFinishList_ release];LBFinishList_ = nil;
    
    [currentColorCode_ release]; currentColorCode_ = nil;
    [KDNOLists release];KDNOLists = nil;
    [colorsLists release];colorsLists = nil;
    [LBInformationDetail_ release];LBInformationDetail_ = nil;
    
    [LBNOimageView_ release];LBNOimageView_ = nil;
    [colorImageView_ release];colorImageView_ = nil;
    [loWeightImageView_ release];loWeightImageView_ = nil;//经向重量
    [laWeightImageView_ release];laWeightImageView_ = nil;//纬向重量
    [dateImageView_ release];dateImageView_ = nil;
    [clearImageView_ release];clearImageView_ = nil;//整理
    [clientImageView_ release];clientImageView_ = nil;
    
    [LBNOlabel_ release];LBNOlabel_ = nil;
    [colorLabel_ release];colorLabel_ = nil;
    [loWeightLabel_ release];loWeightLabel_ = nil;
    [laWeightLabel_ release];laWeightLabel_ = nil;
    [dateLabel_ release];dateLabel_ = nil;
    [clearLabel_ release];clearLabel_ = nil;
    [clientLabel_ release];clientLabel_ = nil;
    
    [KDNObutton_ release];KDNObutton_ = nil;
    [colorButton_ release];colorButton_ = nil;
    dispatch_release(kdnoQueue);
    [super dealloc];
}

//- (void)setKDNO:(NSString *)_KDNO
//{
//    [KDNO_ release];KDNO_ = nil;
//    [_KDNO retain];
//    KDNO_ = _KDNO;
//}
- (void)setUpContents
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 21, 140, 36)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setText:LBNO_];
    self.LBNOContentlabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(110+(240+12)*3, 21, 140, 34)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
    self.colorContentLabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(110, 63, 140, 36)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
//    [label setText:@"20kg"];
    self.loWeightContentLabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(110+(240+12)*1, 63, 140, 36)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
//    [label setText:@"30kg"];
    self.laWeightContentLabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(110+(240+12)*2, 63, 140, 36)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
//    [label setText:@"2012-11-30"];
    self.dateContentLabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(110+(240+12)*3, 63, 140, 36)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
//    [label setText:@"Ni"];
   self.clientContentLabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(110, 104, 910, 36)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
//    [label setText:@"66666666666666666666666666666666666666666666666666666666"];
    
     self.clearContentLabel = label;
    [label release];label = nil;
    
    
    [self addSubview:LBNOContentlabel_];
    [self addSubview:colorContentLabel_];
    [self addSubview:loWeightContentLabel_];
    [self addSubview:laWeightContentLabel_];
    [self addSubview:dateContentLabel_];
    [self addSubview:clearContentLabel_];
    [self addSubview:clientContentLabel_];

}

- (void)setUpContentInterface;
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 21, 100, 36)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setText:@"LB NO."];
    self.LBNOlabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10+(240+12)*3, 21, 100, 36)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setText:@"颜色块"];
    self.colorLabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 63, 100, 36)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setText:@"经向重量"];
    self.loWeightLabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10+(240+12)*1, 63, 100, 36)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setText:@"纬向重量"];
    self.laWeightLabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10+(240+12)*2, 63, 100, 36)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setText:@"交期"];
    self.dateLabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10+(240+12)*3, 63, 100, 36)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setText:@"客户"];
    self.clientLabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 104, 100, 36)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setText:@"整理"];
    self.clearLabel = label;
    [label release];label = nil;
    
    
    [self addSubview:LBNOlabel_];
    [self addSubview:colorLabel_];
    [self addSubview:loWeightLabel_];
    [self addSubview:laWeightLabel_];
    [self addSubview:dateLabel_];
    [self addSubview:clearLabel_];
    [self addSubview:clientLabel_];
}

- (void)setUpBackground
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 21, 240, 36)];
    [imageView setImage:[UIImage imageNamed:@"BackgroundInput_02.png"]];
    self.LBNOimageView = imageView;
    [imageView release];imageView = nil;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7+(240+12)*3, 21, 240, 36)];
    [imageView setImage:[UIImage imageNamed:@"BackgroundInput_02.png"]];
    self.colorImageView = imageView;
    [imageView release];imageView = nil;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 63, 240, 36)];
    [imageView setImage:[UIImage imageNamed:@"BackgroundInput_01.png"]];
    self.loWeightImageView = imageView;
    [imageView release];imageView = nil;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7+(240+12)*1, 63, 240, 36)];
    [imageView setImage:[UIImage imageNamed:@"BackgroundInput_01.png"]];
    self.laWeightImageView = imageView;
    [imageView release];imageView = nil;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7+(240+12)*2, 63, 240, 36)];
    [imageView setImage:[UIImage imageNamed:@"BackgroundInput_02.png"]];
    self.dateImageView = imageView;
    [imageView release];imageView = nil;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7+(240+12)*3, 63, 240, 36)];
    [imageView setImage:[UIImage imageNamed:@"BackgroundInput_02.png"]];
    self.clearImageView = imageView;
    [imageView release];imageView = nil;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 104, 996, 36)];
    [imageView setImage:[UIImage imageNamed:@"BackgroundInput_04.png"]];
    self.clientImageView = imageView;
    [imageView release];imageView = nil;
    
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [imageView setImage:[UIImage imageNamed:@"BackgroundLabColor_01.png"]];
    [self addSubview:imageView];
    [imageView release];imageView = nil;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.tag = YDPopoverTargetKDNO;
    [button setFrame:CGRectMake(7+(240+12)*1, 21, 243, 36)];
    [button setTitle:@"KDNO" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_01.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_02.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(kdnoButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.KDNObutton = button;
    button = nil;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.tag = YDPopoverTargetColor;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"Color" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(7+(240+12)*2, 21, 243, 36)];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_01.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_02.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(colorButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.colorButton = button;
    button = nil;
    
    [self addSubview:LBNOimageView_];
    [self addSubview:KDNObutton_];
    [self addSubview:colorButton_];
    [self addSubview:colorImageView_];
    [self addSubview:loWeightImageView_];
    [self addSubview:laWeightImageView_];
    [self addSubview:dateImageView_];
    [self addSubview:clearImageView_];
    [self addSubview:clientImageView_];
    
}

- (void)kdnoButtonPress:(UIButton *)_sender
{
    [self reloadDatas];
    [self reloadState];
//    YDPopoverViewController *popoverViewController = [[YDPopoverViewController alloc] initWithStyle:UITableViewStylePlain title:@"KDNO." target:_sender];
	
	YDPopoverViewController *popoverViewController = [[YDPopoverViewController alloc] initWithStyle:UITableViewStylePlain title:@"KDNO." buttonType:_sender.tag delegate:self];
    popoverViewController.datas = KDNOLists;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:popoverViewController];
    popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    popover.delegate = self;
    [popover presentPopoverFromRect:_sender.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    [popoverViewController release];
    [nav release];
}

- (void)colorButtonPress:(UIButton *)_sender
{
//    YDPopoverViewController *popoverViewController = [[YDPopoverViewController alloc] initWithStyle:UITableViewStylePlain title:@"Color" target:_sender];
     [self reloadState];
	if (colorViewState_ == YDColorViewStateNone)
	{
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"请先选择开单号！",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	YDPopoverViewController *popoverViewController = [[YDPopoverViewController alloc] initWithStyle:UITableViewStylePlain title:@"Color" buttonType:_sender.tag delegate:self];
    popoverViewController.datas  = colorsLists;

	
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:popoverViewController];
    popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    popover.delegate = self;
    [popover presentPopoverFromRect:_sender.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    [popoverViewController release];
    [nav release];
}

- (void)updateButtonTitleWith:(NSString *)_buttonTitle 
				   buttonType:(NSInteger )_buttonType
{
	NSInteger type = _buttonType;
	switch (type) {
//        选择    颜色值
		case YDPopoverTargetColor:
		{
			colorViewState_ = YDColorViewStateColor;
			[colorButton_ setTitle:_buttonTitle forState:UIControlStateNormal];
            self.currentColorCode = _buttonTitle;
			[self postViewState];
//            [self reloadDatas];
            [self queryLBInformation];

		}
			break;
//            这个选择之后应该去获取网络数据
//            选择开单号
		case YDPopoverTargetKDNO:
		{
			[KDNObutton_ setTitle:_buttonTitle forState:UIControlStateNormal];
            self.KDNO = _buttonTitle;
			colorViewState_ = YDColorViewStateKDNO;
//            只要选择了一次开单号，以后的每一次都是重新选择
            reselectKDNO = YES;
            [self queryColor];
		}
			
			break;

		default:
			break;
	}
}

- (void)didMoveToSuperview
{
    
 
    
    
    if (!self.superview) return;
    if (![KDNOLists count]) 
    {
        [self queryKDNO];
    }
}

- (void)updateUIWith:(LBInfo *)_information
{
    clientLabel_.text = _information.Customer;
    loWeightLabel_.text = _information.FWeight;
    laWeightLabel_.text = _information.WWeight;
}

#pragma mark-----
#pragma query network data ----------


#pragma marik -------获取开单号
- (void)queryKDNO
{
//    self.userInteractionEnabled = NO;
    [self queryKDNOWith:LBNO_ resultBlock:^(NSArray *list){
//        self.userInteractionEnabled = YES;
        if ([KDNOLists count])
        {
            [KDNOLists removeAllObjects];
        }
        for (id object in list)
        {
            if ([object isKindOfClass:[NSDictionary class]])
            {
                NSString *content = [(NSDictionary *)object objectForKey:ItemKey];
                if (content) 
                {
                    [KDNOLists addObject:content];
                }
            }
        }
        
    }];
}

#pragma mark ---------
#pragma ----------- 获取颜色值
- (void)queryColor
{
    self.userInteractionEnabled = NO;
    [self queryColorListWith:LBNO_ withKDNO:KDNO_ resultBlock:^(NSArray *list){
        self.userInteractionEnabled = YES;
        if ([colorsLists count])
        {
            [colorsLists removeAllObjects];
        }
        for (id object in list)
        {
            if ([object isKindOfClass:[NSDictionary class]])
            {
                NSString *content = [(NSDictionary *)object objectForKey:ItemKey];
                if (content) 
                {
                    [colorsLists addObject:content];
                }
            }
        }
    }];
}

#pragma mark ------------
#pragma 获取来样单信息详情
- (void)queryLBInformation
{
//    NSLog(@"KDNO  %@   COLORCOLOR  %@",KDNO_,currentColorCode_);
    self.userInteractionEnabled = NO;
    [self queryLBInformationWith:LBNO_ withColorCode:currentColorCode_ :^(LBInfo *information){
        self.userInteractionEnabled = YES;
        if (information)
        {
            self.LBInformationDetail = information;
            [self reloadDatas:LBInformationDetail_];
        }
    
    }];
}

- (void)queryKDNOWith:(NSString *)_LBNO resultBlock:(void (^)(NSArray *))block
{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 140);
    [self addSubview:loadingView];
    [loadingView release];
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
//    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_async(kdnoQueue,^{
        NSArray *lists = [networkDataMemberHandle GetKDNOList:_LBNO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
            block(lists);
        });
        
    });
//    dispatch_release(kdnoqueue);
}

- (void)queryColorListWith:(NSString *)_LBNO withKDNO:(NSString *)_KDNO resultBlock:(void (^)(NSArray *))block
{
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 140);
    [self addSubview:loadingView];
    [loadingView release];
//    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_async(kdnoQueue,^{
        NSArray *lists = [networkDataMemberHandle GetColorCodeList:_LBNO KD_NO:_KDNO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
            block(lists);
        });
        
    });
//    dispatch_release(kdnoqueue);
}

- (void)queryLBInformationWith:(NSString *)_KDNO withColorCode:(NSString *)_ColorCode:(void (^)(LBInfo *))block
{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 140);
    [self addSubview:loadingView];
    [loadingView release];
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_async(kdnoQueue,^{
        LBInfo *information = [networkDataMemberHandle GetLBInfo:_KDNO Color_Code:_ColorCode];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
            block(information);
        });
        
    });

}

#pragma mark ------------
#pragma mark update interface

- (void)reloadDatas
{

	
	colorViewState_ = YDColorViewStateNone;
	[colorContentLabel_ setBackgroundColor:[UIColor clearColor]];
    

	[loWeightContentLabel_ setText:nil];

	[laWeightContentLabel_ setText:nil];

	[dateContentLabel_ setText:nil];

	[clearContentLabel_ setText:nil];

	[clientContentLabel_ setText:nil];
    [KDNObutton_ setTitle:@"KDNO" forState:UIControlStateNormal];
    [colorButton_ setTitle:@"Color" forState:UIControlStateNormal];
	
}

- (void)reloadDatas:(LBInfo *)_information
{
//    
    //    RGB(Ａ,Ｂ,Ｃ)
//    是，Ａ＊２５５＊２５５＋Ｂ＊２５５＋Ｃ这就是那个长整数 
    int color = [_information.RGB intValue];
    
//    
//    
    int r = color/(256*256);
    int g = (color%(256*256)) / 256;
    int b = (color/(256*256)) % 256;
//    
//    NSLog(@"RGB OLD  r:%d g:%d b:%d",red ,green,blue);
   
    
     r = 0xFF & color;
     g = 0xFF00 & color;
    g >>= 8;
     b = 0xFF0000 & color;
    b >>= 16;
    
    
//    NSLog(@"r  %d   g  %d   b  %d",r,g,b);
    
    [colorContentLabel_ setBackgroundColor:[UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1.0]];
    
	[loWeightContentLabel_ setText:[NSString stringWithFormat:@"%@",_information.FWeight]];
    
	[laWeightContentLabel_ setText:[NSString stringWithFormat:@"%@",_information.WWeight]];
    
	[dateContentLabel_ setText:_information.Delivery_Date];
    
	[clearContentLabel_ setText:_information.FinishMethod];
    
	[clientContentLabel_ setText:_information.Customer];
    self.LBClient = _information.Customer;
    self.LBFinishList = _information.FinishList;
    self.currentWeight = _information.Weight;
    
    if (delegate && [delegate respondsToSelector:@selector(didFinishSelectInfo:client:finishList:weight:colorCode:)])
    {
        [delegate didFinishSelectInfo:self client:LBClient_ finishList:LBFinishList_ weight:currentWeight_ colorCode:currentColorCode_];
    }
}

- (void)postViewState
{
    if (delegate != nil &&[delegate respondsToSelector:@selector(didFinishSelectInfo:client:finishList:weight:colorCode:)]) 
    {
//        [delegate didFinishSelectInfo:self client:nil finishList:nil weight:nil colorCode:nil];
    }
//	if (delegate != nil && [delegate respondsToSelector:@selector(colorNumberSelectDidFinish)]) {
//		[delegate colorNumberSelectDidFinish];
//	}
}

- (void)reloadState
{
    //    这里可以确保无论用户是重新选择开单号还是重新选择颜色值，delegate中都会更新界面，只要不是第一次选择
    if (delegate != nil && [delegate respondsToSelector:@selector(reloadKDNOWith:)]) 
    {
		[delegate reloadKDNOWith:reselectKDNO];
	}
}

#pragma mark ------
#pragma mark YDPopoverViewDelegate

- (void)targetForPopoverView:(YDPopoverViewController *)_popoverViewController 
					 content:(NSString *)_content 
				  buttonType:(NSInteger )_buttonType
{
//    [self reloadState];
	[self updateButtonTitleWith:_content buttonType:_buttonType];
	[popover dismissPopoverAnimated:YES];
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
//    [self updateTargetStateWithIndex:currentSelectedBUtton];
    [popover release];popover = nil;
}

@end
