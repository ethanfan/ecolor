//
//  YDColorStepView.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDColorStepView.h"
#import "YDPopoverViewController.h"


#define STEPS  @"stepsKey"
#define COSTS  @"costKey"
#define COLORS @"colorTypeKey"
#define TYPES  @"typeKey"
#define COLORDEEP @"colorDeepKey"

@interface YDColorStepView ()

- (void)setUp;
- (void)selectItemButtonPress:(UIButton *)_sender;
-(void)updateTargetStateWithIndex:(NSInteger)_buttonIndex;

- (NSString *)convertDictionaryToString:(NSDictionary *)_dictionary withKey:(NSString *)_key;

- (NSArray *)convertArray:(NSArray *)_dictionarys withKey:(NSString *)_key;

- (void)processAllStepsItem;

- (void)processAllStepsItem:(void (^)(NSDictionary *))block;

//初始化时默认设置数组中第一个值为默认的的当前值
- (void)setFirstTitle;


@end

@implementation YDColorStepView

@synthesize stepButton = stepButton_;
@synthesize costButton = costButton_;
@synthesize colorButton =   colorButton_;//色系
@synthesize typeButton = typeButton_;//分类
@synthesize colorDeepButton = colorDeepButton_;

@synthesize stepLabel = stepLabel_;
@synthesize costLabel =  costLabel_;
@synthesize colorLabel = colorLabel_;
@synthesize typeLabel = typeLabel_;
@synthesize colorDeepLabel =  colorDeepLabel_; 

@synthesize currentStep = currentStep_,
currentCost = currentCost_,
currentType = currentType_,
currentColor = currentColor_ , 
currentColorDeep = currentColorDeep_;

@synthesize finishState = finishState_;

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		UIImageView *v = [[UIImageView alloc] initWithFrame:self.bounds];
		[v setImage:[UIImage imageNamed:@"BackgroundLabColor_02.png"]];
		[self addSubview:v];
		[v release];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUp];
        finishState_ = 0;
         stepsList = [[NSMutableArray arrayWithCapacity:3] retain];
         costsList=  [[NSMutableArray arrayWithCapacity:3] retain];
         colorsList =  [[NSMutableArray arrayWithCapacity:10] retain];
         typesList =  [[NSMutableArray arrayWithCapacity:5] retain];
         colorDeepsList =  [[NSMutableArray arrayWithCapacity:3] retain];
        stepsQueue = dispatch_queue_create("YDKDNOQueue.YDColorStepView", NULL);

    }
    return self;
}

- (void)dealloc
{
//    NSLog(@"view dealloc");
    
    [stepButton_ release];stepButton_ = nil;
    [costButton_ release];costButton_ = nil;
    [colorButton_ release];colorButton_ = nil;
    [typeButton_ release];typeButton_ = nil;
    [colorDeepButton_ release];colorDeepButton_ = nil;
    
    [stepLabel_ release];stepLabel_ = nil;
    [costLabel_ release];costLabel_ = nil;
    [colorLabel_ release];colorLabel_ = nil;
    [typeLabel_ release];typeLabel_ = nil;
    [colorDeepLabel_ release];colorDeepLabel_ = nil;
    
    [currentStep_ release];currentStep_ = nil;
    [currentType_ release];currentType_ = nil;
    [currentCost_ release];currentCost_ = nil;
    [currentColor_ release];currentColor_ = nil;
    [currentColorDeep_ release];currentColorDeep_ = nil;
    
    [stepsList removeAllObjects];
    [stepsList release];stepsList = nil;
    [costsList removeAllObjects];
    [costsList release];costsList = nil;
    [typesList removeAllObjects];
    [typesList release];typesList = nil;
    [colorsList removeAllObjects];
    [colorsList release];colorsList = nil;
    [colorDeepsList removeAllObjects];
    [colorDeepsList release];colorDeepsList = nil;
    
    delegate = nil;
    dispatch_release(stepsQueue);
    
    [super dealloc];
}

-(void)updateTargetStateWithIndex:(NSInteger)_buttonIndex
{
    NSInteger buttonType =_buttonIndex;
    switch (buttonType)
    {
        case YDLabColorStepItem:
            stepButton_.selected = NO;
            break;
        case YDLabColorCostItem:
            costButton_.selected = NO;
            break;
        case YDLabColorColorItem:
            colorButton_.selected = NO;
            break;
        case YDLabColorTypeItem:
            typeButton_.selected = NO;
            break;
        case YDLabColorColorDeepItem:
            colorDeepButton_.selected = NO;
            break;
        default:
            break;
    }
    

}

- (void)setUp
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(9, 23, 66, 36)];
    [label setText:@"步骤"];
    [label setBackgroundColor:[UIColor grayColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    self.stepLabel = label;
    [label release];label = nil;
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(9+(66+137)*1, 23, 66, 36)];
    [label setText:@"成本"];
    [label setBackgroundColor:[UIColor grayColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    self.costLabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(9+(66+137)*2, 23, 66, 36)];
    [label setText:@"色系"];
    [label setBackgroundColor:[UIColor grayColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    self.colorLabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(9+(66+137)*3, 23, 66, 36)];
    [label setText:@"分类"];
    [label setBackgroundColor:[UIColor grayColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    self.typeLabel = label;
    [label release];label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(9+(66+137)*4, 23, 66, 36)];
    [label setText:@"深浅"];
    [label setBackgroundColor:[UIColor grayColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    self.colorDeepLabel = label;
    [label release];label = nil;
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//    [imageView setImage:[UIImage imageNamed:@"BackgroundLabColor_02.png"]];
//    [self addSubview:imageView];
//    [imageView release];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(selectItemButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = YDLabColorStepItem;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(78, 23, 114, 36)];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_03.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_04.png"] forState:UIControlStateSelected];
    [button setTitle:NSLocalizedString(@"一浴法", nil) forState:UIControlStateNormal];
    self.stepButton = button;
    button = nil;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(selectItemButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.tag  =YDLabColorCostItem;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(78+(114+90)*1, 23, 114, 36)];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_03.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_04.png"] forState:UIControlStateSelected];
    [button setTitle:NSLocalizedString(@"低", nil) forState:UIControlStateNormal];
    self.costButton = button;
    button = nil;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(selectItemButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = YDLabColorColorItem;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(78+(114+90)*2, 23, 114, 36)];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_03.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_04.png"] forState:UIControlStateSelected];
    [button setTitle:NSLocalizedString(@"PK", nil) forState:UIControlStateNormal];
    self.colorButton = button;
    button = nil;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(selectItemButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = YDLabColorTypeItem;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(78+(114+90)*3, 23, 114, 36)];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_03.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_04.png"] forState:UIControlStateSelected];
    [button setTitle:NSLocalizedString(@"活性", nil) forState:UIControlStateNormal];
    self.typeButton = button;
    button = nil;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(selectItemButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = YDLabColorColorDeepItem;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(78+(114+90)*4, 23, 114, 36)];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_03.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonPulldown_04.png"] forState:UIControlStateSelected];
    [button setTitle:NSLocalizedString(@"L", nil) forState:UIControlStateNormal];
    self.colorDeepButton = button;
    button = nil;
    
    
    [self addSubview:stepLabel_];
    [self addSubview:costLabel_];
    [self addSubview:colorLabel_];
    [self addSubview:typeLabel_];
    [self addSubview:colorDeepLabel_];
    
    [self addSubview:stepButton_];
    [self addSubview:costButton_];
    [self addSubview:colorButton_];
    [self addSubview:typeButton_];
    [self addSubview:colorDeepButton_];
}


- (void)resetSimpleColor:(NSString *)_simpleColor
{
    self.currentColor = _simpleColor;
    [colorButton_ setTitle:_simpleColor forState:UIControlStateNormal];
}

- (NSString *)convertDictionaryToString:(NSDictionary *)_dictionary withKey:(NSString *)_key
{
    NSString *result = [_dictionary objectForKey:_key];
    return result;
}

- (NSArray *)convertArray:(NSArray *)_dictionarys withKey:(NSString *)_key
{
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:[_dictionarys count]];
    
//     NSLog(@"_dictionarys ----- %@  ---key  %@" ,_dictionarys,_key);
    for (id object in _dictionarys)
    {
        if ([object isKindOfClass:[NSDictionary class]])
        {
            NSString *content = [(NSDictionary *)object objectForKey:_key];
            if (content) 
            {
                [results addObject:content];
            }
        }

    }
    return results;
}


- (void)processAllStepsItem
{
    
    [self processAllStepsItem:^(NSDictionary *results){
        [stepsList addObjectsFromArray:[self convertArray:[results objectForKey:STEPS] withKey:@"Item_NO"]];
        [costsList addObjectsFromArray:[self convertArray:[results objectForKey:COSTS] withKey:@"Item_NO"]];
        [colorsList addObjectsFromArray:[self convertArray:[results objectForKey:COLORS] withKey:@"Item_NO"]];
        [typesList addObjectsFromArray:[self convertArray:[results objectForKey:TYPES] withKey:@"Item_NO"]];
        [colorDeepsList addObjectsFromArray:[self convertArray:[results objectForKey:COLORDEEP] withKey:@"Item_NO"]];
        [self setFirstTitle];
    }];

}

///一次获取所有的步骤／色系等步骤
- (void)processAllStepsItem:(void (^)(NSDictionary *))block
{
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(512, 34);
    [self addSubview:loadingView];
    [loadingView release];
    dispatch_async(stepsQueue,^{
        NSArray *steps = [networkDataMemberHandle GetStepList];
        NSArray *costs = [networkDataMemberHandle GetCostList];
        NSArray *colors = [networkDataMemberHandle GetSimpleColorList];
        NSArray *types = [networkDataMemberHandle GetTypeList];
        NSArray *colorDeeps = [networkDataMemberHandle GetColorDeepList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
            NSDictionary *resutls = [NSDictionary dictionaryWithObjectsAndKeys:
                                     steps,STEPS, 
                                     costs,COSTS,
                                     types,TYPES,
                                     colorDeeps,COLORDEEP,
                                     colors,COLORS,nil];
            block(resutls);
        });
        
    });
}

- (NSString *)predicateColorType:(NSString *)_colorCode
{
    NSString *result = NULL;
    if ([colorsList count]) {
        NSInteger index = [colorsList indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop){
            
            NSRange range = [_colorCode rangeOfString:obj];
            *stop = range.length;
            return *stop;
        }];
        
        if (index != NSNotFound) {
            result = [colorsList objectAtIndex:index];
        }
    }
    return result;
}

- (void)setFirstTitle
{
//    finishState_ = 1;
    if ([stepsList count])
    {
        self.currentStep = [stepsList objectAtIndex:0];
        [stepButton_ setTitle:currentStep_ forState:UIControlStateNormal];
    } 
    if ([costsList count])
    {
        self.currentCost = [costsList objectAtIndex:0];
        [costButton_ setTitle:currentCost_ forState:UIControlStateNormal];
    }
    if ([colorsList count])
    {
        self.currentColor = [colorsList objectAtIndex:0];
        [colorButton_ setTitle:currentColor_ forState:UIControlStateNormal];
    }
    if ([typesList count])
    {
        self.currentType = [typesList objectAtIndex:0];
        [typeButton_ setTitle:currentType_ forState:UIControlStateNormal];
    }
    if ([colorDeepsList count])
    {
        self.currentColorDeep = [colorDeepsList objectAtIndex:0];
        [colorDeepButton_ setTitle:currentColorDeep_ forState:UIControlStateNormal];
    }
    if (delegate != nil && [delegate respondsToSelector:@selector(stepDidSelect:withCost:withColor:withType:withColorDeep:)])
    {
        [delegate stepDidSelect:currentStep_ 
                       withCost:currentCost_ 
                      withColor:currentColor_ 
                       withType:currentType_ 
                  withColorDeep:currentColorDeep_];
    }
}

- (void)didMoveToSuperview
{
    if (!self.superview) return;
    
    [self processAllStepsItem];
}


- (void)selectItemButtonPress:(UIButton *)_sender
{
    YDPopoverViewController *popoverViewController;
    _sender.selected = YES;
    currentSelectedBUtton = _sender.tag;
	//显示的内容是哪些
    NSInteger viewType = 0;
    NSInteger buttonType = _sender.tag;
    switch (buttonType)
    {
        case YDLabColorStepItem:
			viewType = YDPopoverTargetStep;
			popoverViewController = [[YDPopoverViewController alloc] initWithStyle:UITableViewStylePlain title:@"步骤" buttonType:viewType delegate:self];
            popoverViewController.datas = stepsList;

            break;
        case YDLabColorCostItem:
			viewType = YDPopoverTargetCost;
			popoverViewController = [[YDPopoverViewController alloc] initWithStyle:UITableViewStylePlain title:@"成本" buttonType:viewType delegate:self];
            popoverViewController.datas = costsList;

            break;
        case YDLabColorColorItem:
			viewType = YDPopoverTargetSimpleColor;
			popoverViewController = [[YDPopoverViewController alloc] initWithStyle:UITableViewStylePlain title:@"色系" buttonType:viewType delegate:self];
            popoverViewController.datas = colorsList;

            break;
        case YDLabColorTypeItem:
			viewType = YDPopoverTargetType;
			popoverViewController = [[YDPopoverViewController alloc] initWithStyle:UITableViewStylePlain title:@"分类" buttonType:viewType delegate:self];
            popoverViewController.datas = typesList;

            break;
        case YDLabColorColorDeepItem:
			viewType = YDPopoverTargetDeep;
			popoverViewController = [[YDPopoverViewController alloc] initWithStyle:UITableViewStylePlain title:@"深浅" buttonType:viewType delegate:self];
            popoverViewController.datas = colorDeepsList;

            break;
        default:
            break;
    }
    
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
	switch (type)
    {
        case YDPopoverTargetStep:
        {
            self.currentStep = _buttonTitle;
			[stepButton_ setTitle:_buttonTitle forState:UIControlStateNormal];
        }
            break;
        case YDPopoverTargetCost:
        {
            self.currentCost = _buttonTitle;
			[costButton_ setTitle:_buttonTitle forState:UIControlStateNormal];
        }
            break;
        case YDPopoverTargetSimpleColor:
        {
            self.currentColor = _buttonTitle;
			[colorButton_ setTitle:_buttonTitle forState:UIControlStateNormal];
        }
            break;
        case YDPopoverTargetType:
        {
            self.currentType = _buttonTitle;
			[typeButton_ setTitle:_buttonTitle forState:UIControlStateNormal];
        }
            break;
        case YDPopoverTargetDeep:
        {
            self.currentColorDeep = _buttonTitle;
			[colorDeepButton_ setTitle:_buttonTitle forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    if (delegate && [delegate respondsToSelector:@selector(stepDidSelect:withCost:withColor:withType:withColorDeep:)])
    {
        [delegate stepDidSelect:currentStep_ 
                       withCost:currentCost_ 
                      withColor:currentColor_ 
                       withType:currentType_ 
                  withColorDeep:currentColorDeep_];
    }

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


#pragma -----
#pragma UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self updateTargetStateWithIndex:currentSelectedBUtton];
    [popover release];popover = nil;
}

@end
