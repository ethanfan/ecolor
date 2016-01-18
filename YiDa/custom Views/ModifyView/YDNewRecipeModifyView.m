//
//  YDNewRecipeModifyView.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDNewRecipeModifyView.h"
#import "YDPostNotificationName.h"
#import "YDAddictions.h"
#import "YDAppDelegate.h"
#import "MBProgressHUD.h"


#define kLabRect CGRectMake(355, 72, 328, 379)
#define kLabRectDetail CGRectMake(355, 72, 328, 636)

#define kNewRecipeColor [UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]

//#define kBulkRect CGRectMake(355, 72, 328, 689)
#define kBulkRectDetail CGRectMake(355, 72, 328, 689)

@interface YDNewRecipeModifyView ()

- (void)setUpBackgroundView;

- (void)setUpInterface;

- (void)recipeConfrimButton:(UIButton *)_sender;

- (void)confirmButton:(UIButton *)_sender;

- (void)cancelButton:(UIButton *)_sender;

- (void)detailButton:(UIButton *)_sender;

- (void)showDetail:(BOOL)_showOrHide;
- (UIImage *)backImageWith:(YDUserType )_userType;

- (void)setRecipeValue:(Group_List *)_recipeValue;

//bulk 用户计算助剂
- (void)queryBulkAuxiliariesWith:(NSString *)_xriteNO
                     withBatchNo:(NSString *)_batchNo
                  firstDyeCotton:(NSString *)_firstDyeCotton
                 withChemicalIds:(NSString *)_chemicalIds
                       withUsage:(NSString *)_usages;

- (void)queryBulkAuxiliariesWith:(NSString *)_xriteNO
                     withBatchNo:(NSString *)_batchNo
                  firstDyeCotton:(NSString *)_firstDyeCotton
                 withChemicalIds:(NSString *)_chemicalIds
                       withUsage:(NSString *)_usages
                           block:(void (^)(BulkAuxiliariesInfo *))block;


//lab用户计算助剂
- (void)queryLabAuxiliariesWith:(NSString *)_chemicalIds withUsage:(NSString *)_usages;

- (void)queryLabAuxiliariesWith:(NSString *)_chemicalIds withUsage:(NSString *)_usages block:(void (^)(LabAuxiliariesInfo *))block;


//有效的配方值输入
- (BOOL)validNewRecipeInput;
//有效的辅助工艺输入
- (BOOL)validdArtwork;

@end

@implementation YDNewRecipeModifyView

@synthesize containerView = containerView_;
@synthesize yellowLabel = yellowLabel_;
@synthesize redLabel = redLabel_;
@synthesize blueLabel = blueLabel_;
@synthesize moreField = moreField_;
@synthesize recipeConfirmButton = recipeConfirmButton_;
@synthesize     recipeCancelButton = recipeCancelButton_;

@synthesize     soltLabel = soltLabel_;          //盐
@synthesize     sodaLabel = sodaLabel_;          //碱
@synthesize     warnTimeLabel = warnTimeLabel_;     //保温
@synthesize     confirmButton = confirmButton_;
@synthesize     cancelButton = cancelButton_;
@synthesize		bathRate = bathRate_;

@synthesize backgroundImageView = backgroundImageView_;
@synthesize detailButton = detailButton_;

@synthesize userType = userType_;


@synthesize batchNo;
@synthesize xriteNO;
@synthesize firstDyeCotton;



@synthesize NA2CO3 = NA2CO3_,NA2SO4 = NA2SO4_,keepWarnTime = keepWarnTime_,rato = rato_;
@synthesize recipeValues = recipeValues_;
@synthesize addictives  = addictives_;

@synthesize chemicalIds = chemicalIds_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
		UIView *a = [[UIView alloc] initWithFrame:self.bounds];
		[a setBackgroundColor:[UIColor blackColor]];
		a.alpha = 0.2;
		[self addSubview:a];
		[a release];
		a = nil;
		self.userType = YDUserTypeNone;
		containerHeight = 636;
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *view = [[UIView alloc] initWithFrame:kLabRect];
        [view setBackgroundColor:[UIColor clearColor]];
        self.containerView = view;
        [view release];view = nil;
        [self addSubview:containerView_];
        [self setUpBackgroundView];
        
        keyboard = [[NumberKeyboard alloc] initWithNibName:@"NumberKeyboard" bundle:nil];
        keyboard.showsPeriod = YES;
        keyboard.showsMinus = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame userType:(YDUserType )_userType
{
	self = [super initWithFrame:frame];
    if (self) 
    {
		UIView *a = [[UIView alloc] initWithFrame:self.bounds];
		[a setBackgroundColor:[UIColor blackColor]];
		a.alpha = 0.2;
		[self addSubview:a];
		[a release];
		a = nil;
		
		self.userType = _userType;
		containerHeight = 636;
		if (userType_ == YDUserTypeBulk)
		{
			containerHeight = 689;
		}
		
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *view = [[UIView alloc] initWithFrame:kLabRect];
        [view setBackgroundColor:[UIColor clearColor]];
        self.containerView = view;
        [view release];view = nil;
        [self addSubview:containerView_];
        [self setUpBackgroundView];
        
        keyboard = [[NumberKeyboard alloc] initWithNibName:@"NumberKeyboard" bundle:nil];
        keyboard.showsPeriod = YES;
        keyboard.showsMinus = YES;
    }
    return self;
}

- (void)dealloc
{
    
    [yellowLabel_ release];yellowLabel_ = nil;
    [redLabel_ release];redLabel_ = nil;
    [blueLabel_ release];blueLabel_  = nil;
    [moreField_ release];moreField_ = nil;
    [recipeCancelButton_ release];recipeCancelButton_ = nil;
    [recipeConfirmButton_ release];recipeConfirmButton_ = nil;
    [soltLabel_ release];soltLabel_ = nil;
    [sodaLabel_ release];sodaLabel_ = nil;
    [warnTimeLabel_ release];warnTimeLabel_ = nil;
    [confirmButton_ release];confirmButton_ = nil;
    [cancelButton_ release];cancelButton_ = nil;
	[bathRate_ release];bathRate_ = nil;
	[backgroundImageView_ release];backgroundImageView_ = nil;
	[detailButton_ release];detailButton_ = nil;
    [containerView_ release];containerView_ = nil;
    
    [keepWarnTime_ release];keepWarnTime_ = nil;
    [NA2CO3_ release];NA2CO3_ = nil;
    [NA2SO4_ release];NA2SO4_ = nil;
    [rato_ release];rato_ = nil;
    [recipeValues_ release];recipeValues_ = nil;
    [addictives_ release];addictives_ = nil;
    
    [chemicalIds_ release];
    
    self.xriteNO = nil;
    self.batchNo = nil;
    self.firstDyeCotton = nil;
    
    [keyboard release];
    
    [super dealloc];
}

- (void)didMoveToSuperview
{
    
	

	if (!self.superview) 
	{
		[[NSNotificationCenter defaultCenter] removeObserver:keyboardShowObserver];
		[[NSNotificationCenter defaultCenter] removeObserver:keyboardHideObserver];
		return;
	}
	
	[self setUpInterface];
	
#if NS_BLOCKS_AVAILABLE
	keyboardHideObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock: ^(NSNotification *note)
	 {
		 [UIView beginAnimations:nil context:NULL];
		 [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		 [UIView setAnimationDuration:0.3];
		 [containerView_ setFrame:CGRectMake(containerView_.left,72 , containerView_.width, containerView_.height)];
		 [UIView commitAnimations];
	 }];
	
	keyboardShowObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock: ^(NSNotification *note)
	 {
//		 NSDictionary* info = [note userInfo];
		 //获取出来的键盘frame总是portrait的，奇怪
//		 CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
		 CGRect aRect = containerView_.frame;
		 aRect.size.height -= 389;
		 CGPoint aPoint = activedEditField.frame.origin;
		 aPoint = CGPointMake(aPoint.x, aPoint.y);
		 if (!CGRectContainsPoint(aRect, aPoint) ) {
			 [UIView beginAnimations:nil context:NULL];
			 [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
			 [UIView setAnimationDuration:0.3];
			 [containerView_ setFrame:CGRectMake(containerView_.left,containerView_.top-aPoint.y , containerView_.width, containerView_.height)];
			 [UIView commitAnimations];
		 }
		 
	 }];
	
#endif	
    
    [self setRecipeValue:recipeValues_];
}


- (void)setRecipeValue:(Group_List *)_recipeValue
{
//    NSLog(@"jfljfldjfldjfldjfljdfldfjldfjldjf  %@  %@",_recipeValue.titleName,_recipeValue.valueAry);
    if (_recipeValue)
    {
//        [self.recipeTitle setText:_recipeValue.titleName];
//        NSLog(@"recipeTitle  %@",_recipeValue.titleName);
        NSMutableArray *values = _recipeValue.valueAry ;
//        NSLog(@"YDPalettesRecipeView  values  -----%@",values);
        NSInteger count = [values count];
        for (int i = 0; i<count; i++)
        {
            if (i == 0) [yellowLabel_ setText:[values objectAtIndex:i]];
            if (i == 1) [redLabel_ setText:[values objectAtIndex:i]];
            if (i == 2) [blueLabel_ setText:[values objectAtIndex:i]];
            if (i == 3) [moreField_ setText:[values objectAtIndex:i]];
        }
    }

}



- (void)setUpBackgroundView
{
    UIImageView *image = [[UIImageView alloc] initWithFrame:containerView_.bounds];
    [image setImage:[UIImage imageNamed:@"BackgroundModify_05.png"]];
	self.backgroundImageView = image;
    [containerView_ addSubview:image];
    [image release];
}


#pragma mark -----------------
#pragma mark ------------ 取出旧的使用量
- (NSString *)generateOldUsage:(Group_List *)_recipeValue
{
    NSMutableString *usages = [NSMutableString stringWithCapacity:3];
    NSMutableArray *values = _recipeValue.valueAry ;
    NSInteger count = [values count];
    for (int i = 0; i<count; i++)
    {
        if (i == 0) [usages appendString:[NSString stringWithFormat:@"%@",[values objectAtIndex:i]]];
        else {
            [usages appendString:[NSString stringWithFormat:@",%@",[values objectAtIndex:i]]];
        }
    }
    //    NSLog(@"generateOldUsage    %@",usages);
    return [NSString stringWithFormat:@"%@",usages];
}

- (void)setValue:(NSString *)_batchNo xriteNo:(NSString *)_xriteNo firstDyeCotton:(NSString *)_firstDyeCotton
{
    self.xriteNO = _xriteNo;
    self.batchNo = _batchNo;
    self.firstDyeCotton = _firstDyeCotton;
}

- (void)initContentFieldWith:(NSInteger )_count
{
    for (int i = 0; i<_count; i++)
    {
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(78, 73+(30+15)*i, 150, 30)];
        field.delegate = self;
        field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [field setReturnKeyType:UIReturnKeyNext];
        [field setBorderStyle:UITextBorderStyleLine];
         [field setTextAlignment:UITextAlignmentCenter];
    	[field setBackgroundColor:kNewRecipeColor];
        if (i == 0)
        {
            self.yellowLabel = field;
        }
        else if(i==1)
        {
            self.redLabel = field;
        }
        else if (i== 2)
        {
            self.blueLabel = field;
            [field setReturnKeyType:UIReturnKeyDone];
        }
        else if(i == 3)
        {
            self.moreField = field;
            [field setReturnKeyType:UIReturnKeyDone];
        }
        [containerView_ addSubview:field];
    	[field release];field = nil;
    }
    

}

- (void)setUpInterface
{
    UIColor *color = [UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.];
    
	//配方值
//    for (int i = 0; i<3; i++)
//    {
//        UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(78, 73+(35+15)*i, 150, 30)];
//        label.delegate = self;
//         label.returnKeyType = UIReturnKeyNext;
//        label.borderStyle = UITextBorderStyleLine;
//		label.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//        [label setBackgroundColor:color];
//        [label setTextAlignment:UITextAlignmentCenter];
//        if (i== 0) self.yellowLabel = label;
//        if (i== 1) self.redLabel = label;
//        if (i== 2) 
//        {
//            self.blueLabel = label ;
//            label.returnKeyType = UIReturnKeyDone;
//        }
//        [containerView_ addSubview:label];
//        [label release];label = nil;
//    }
    
    [self initContentFieldWith:[recipeValues_.valueAry count]];
    [self setRecipeValue:recipeValues_];
    
    //工艺和辅助
	NSInteger count = 3 ,y = 391;
	if (userType_ == YDUserTypeBulk)
	{
		count = 4;
		y = 396;
	}
    for (int i = 0; i<count; i++)
    {
        UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(149, y+(35+19)*i, 100, 35)];
        label.delegate = self;
        label.borderStyle = UITextBorderStyleLine;
        [label setBackgroundColor:color];
		label.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        label.returnKeyType = UIReturnKeyNext;
		label.hidden = YES;
        [label setTextAlignment:UITextAlignmentCenter];
        if (i== 0) 
        {
            self.soltLabel = label;
            [label setText:addictives_.NA2SO4];
        }
        if (i== 1) 
        {
            self.sodaLabel = label;
            [label setText:addictives_.NA2CO3];
        }
        if (i== 2) 
        {
			if (userType_ == YDUserTypeBulk)
			{
				self.bathRate = label ;
                [self.bathRate setText:self.rato];
//                NSLog(@"ratio %@",self.rato);
			}
			else if (userType_ == YDUserTypeLab)
			{
				self.warnTimeLabel = label ;
				 label.returnKeyType = UIReturnKeyDone;
                  [label setText:addictives_.keepWarnTime];
//                NSLog(@"warnTime  %@",addictives_.keepWarnTime);
			}
          
        }
		if (i== 3)
		{
//            NSLog(@"warnTime  %@",addictives_.keepWarnTime);
			self.warnTimeLabel = label;
            [label setText:addictives_.keepWarnTime];
			label.returnKeyType = UIReturnKeyDone;
		}
        [containerView_ addSubview:label];
        [label release];label = nil;
    }
    //配方值
    for (int i = 0; i<2; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(71+(78+25)*i, 256, 78, 30)];
        if (i== 0) 
        {
            self.recipeConfirmButton = button;
            [button addTarget:self action:@selector(recipeConfrimButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"ButtonModifyConfirm.png"] forState:UIControlStateNormal];
        }
        if (i==1)
        {
            self.recipeCancelButton = button;
            [button addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"ButtonModifyCancel.png"] forState:UIControlStateNormal];
        }
        [containerView_ addSubview:button];
    }
	//显示辅助和工艺按钮
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(0, 316, 328, 55)];
	[button addTarget:self action:@selector(detailButton:) forControlEvents:UIControlEventTouchUpInside];
	self.detailButton = button;
	[containerView_ addSubview:button];
    //辅助和工艺
	
	 y = 573;
	if (userType_ == YDUserTypeBulk)
	{
		y = 630;
	}
	
    for (int i = 0; i<2; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(71+(78+25)*i, y, 78, 30)];
		button.hidden = YES;
        if (i== 0) 
        {
            self.confirmButton = button;
            [button addTarget:self action:@selector(confirmButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"ButtonModifyConfirm.png"] forState:UIControlStateNormal];
        }
        if (i==1)
        {
            self.cancelButton = button;
            [button addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"ButtonModifyCancel.png"] forState:UIControlStateNormal];
        }
        [containerView_ addSubview:button];
    }


}

- (BOOL)validNewRecipeInput
{
//	BOOL valid = NO;
    
    BOOL valid = YES;
    if (yellowLabel_) {
        if (![yellowLabel_.text length]) {
            return NO;
        }
    }
    if (redLabel_) {
        if (![redLabel_.text length]) {
            return NO;
        }
    }
    if (blueLabel_) {
        if (![blueLabel_.text length]) {
            return NO;
        }
    }
    if (moreField_) {
        if (![moreField_.text length]) {
            return NO;
        }
    }
    
//	if (yellowLabel_.text != nil && [yellowLabel_.text length] &&
//		redLabel_.text != nil && [redLabel_.text length] &&
//		blueLabel_.text != nil && [blueLabel_.text length])
//	{
//		valid = YES;
//	}
	return valid;
}
- (BOOL)validdArtwork
{
	BOOL valid = NO;
	if (sodaLabel_.text != nil && [sodaLabel_.text length] &&
		soltLabel_.text != nil && [soltLabel_.text length] &&
		warnTimeLabel_.text != nil && [warnTimeLabel_.text length])
	{
		valid = YES;
	}
	return valid;
	
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//	NSLog(@"textfield !");
    
    keyboard.textField = textField;
    textField.inputView = keyboard.view;
	activedEditField = textField;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == yellowLabel_) {
		[redLabel_ becomeFirstResponder];
	}
	else if (textField == redLabel_)
	{
		[blueLabel_ becomeFirstResponder];
	}
	else if (textField == blueLabel_) {
        if (moreField_) {
            [moreField_ becomeFirstResponder];

        }
        else
            [blueLabel_ resignFirstResponder];
	}
    else if (textField == moreField_)
    {
        [moreField_ resignFirstResponder];
    }
	
	if (textField == soltLabel_) {
		[sodaLabel_ becomeFirstResponder];
	}
	else if (textField == sodaLabel_)
	{
		[warnTimeLabel_ becomeFirstResponder];
	}
	if (textField == warnTimeLabel_) {
		[warnTimeLabel_ resignFirstResponder];
	}
	if (textField == bathRate_)
	{
		[warnTimeLabel_ resignFirstResponder];
	}
    
	
    return YES;
}

- (UIImage *)backImageWith:(YDUserType )_userType
{
	UIImage *image = nil;
	switch (userType_)
	{
		case YDUserTypeBulk:
			image = [UIImage imageNamed:@"BackgroundModify_09.png"];
			break;
		case YDUserTypeLab:
			image = [UIImage imageNamed:@"BackgroundModify_06.png"];
			break;

		default:
			break;
	}
	return image;
}


- (void)showDetail:(BOOL)_showOrHide
{
    
    NSInteger userType = [[self YDAppDelegate] currentUserType];
    
	//show
	if (_showOrHide)
	{
		[backgroundImageView_ setImage:[self backImageWith:userType_]];
		[containerView_ setFrame:CGRectMake(containerView_.left, containerView_.top, containerView_.width, containerHeight)];
		[backgroundImageView_ setFrame:containerView_.bounds];
		soltLabel_.hidden = NO;
		sodaLabel_.hidden = NO;
		warnTimeLabel_.hidden = NO;
		confirmButton_.hidden = NO;
		cancelButton_.hidden = NO;
		bathRate_.hidden = NO;
        
        if (userType == YDUserTypeLab)
        {
            [self queryLabAuxiliariesWith:self.chemicalIds withUsage:[self getNewUsage]];
        }
        else if (userType == YDUserTypeBulk)
        {
            [self queryBulkAuxiliariesWith:xriteNO withBatchNo:self.batchNo firstDyeCotton:self.firstDyeCotton withChemicalIds:chemicalIds_ withUsage:[self getNewUsage]];
        }
	}
	//hide
	else if (!_showOrHide)
	{
		[backgroundImageView_ setImage:[UIImage imageNamed:@"BackgroundModify_05.png"]];
		[containerView_ setFrame:CGRectMake(containerView_.left, containerView_.top, containerView_.width, 379)];
		[backgroundImageView_ setFrame:containerView_.bounds];
		soltLabel_.hidden = YES;
		sodaLabel_.hidden = YES;
		warnTimeLabel_.hidden = YES;
		confirmButton_.hidden = YES;
		cancelButton_.hidden = YES;
		bathRate_.hidden = YES;
	}
}


- (NSString *)getNewUsage
{
    NSString *newUsages = [NSString stringWithFormat:@"%0.5f",[yellowLabel_.text floatValue]];
    if (redLabel_) {
        newUsages = [newUsages stringByAppendingString:[NSString stringWithFormat:@",%0.5f",[redLabel_.text floatValue]]];
    }
    if (blueLabel_) {
        newUsages = [newUsages stringByAppendingString:[NSString stringWithFormat:@",%0.5f",[blueLabel_.text floatValue]]];
    }
    if (moreField_) {
        newUsages = [newUsages stringByAppendingString:[NSString stringWithFormat:@",%0.5f",[moreField_.text floatValue]]];
    }
    
    return newUsages;
    
}

#pragma mark -------------
#pragma mark button actions -----

//显示工艺和辅助
- (void)detailButton:(UIButton *)_sender
{
	BOOL show = _sender.selected = !_sender.selected;
	[self showDetail:show];
}

//新配方的确定
- (void)recipeConfrimButton:(UIButton *)_sender
{
	if (![self validNewRecipeInput] || ![self validdArtwork])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) 
														message:NSLocalizedString(@"请输入完整的组合数值",nil) 
													   delegate:nil 
											  cancelButtonTitle:NSLocalizedString(@"确定",nil) 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    
//    NSString *newUsages  = [NSString stringWithFormat:@"%0.4f,%0.4f,%0.4f",[yellowLabel_.text floatValue],[redLabel_.text floatValue],[blueLabel_.text floatValue]];
//    if (moreField_) {
//        newUsages = [newUsages stringByAppendingString:[NSString stringWithFormat:@",%0.4f",[moreField_.text floatValue]]];
//    }
    NSString *newUsages = [self getNewUsage];
//    
    NSString *newAndOld  = [self generateOldUsage:recipeValues_];
    
//    NSLog(@"旧的使用量     %@",self.ol)
//    这个是新的配方值，应该保存到配方值里面去，在新增的配方的界面面中显示的就是这几个值
    NSArray *newValueArray = [newUsages componentsSeparatedByString:@","];
    recipeValues_.valueAry = [NSMutableArray arrayWithArray:newValueArray];
    addictives_.NA2SO4 = soltLabel_.text;
    addictives_.NA2CO3 = sodaLabel_.text;
    addictives_.keepWarnTime = warnTimeLabel_.text;
    [userInfo setObject:newUsages forKey:YDNewRecipeNewUsageKey];
//    新建的配方，配方号未空
    recipeValues_.titleName = nil;
    [userInfo setObject:recipeValues_ forKey:YDNewRecipeOldUsageKey];
    [userInfo setObject:addictives_ forKey:YDNewRecipeArtworkKey];
    [userInfo setObject:newAndOld forKey:YDNewAndOldUsageKey];
	
    [[NSNotificationCenter defaultCenter] postNotificationName:YDLabPalettesAddRecipeNotification object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:YDBulkPalettesAddRecipeNotification object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:YDBulkAddictionAddRecipeNotification object:nil userInfo:userInfo];
    [self removeFromSuperview];
}
//工艺的确定
- (void)confirmButton:(UIButton *)_sender
{
	if (![self validdArtwork])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) 
														message:NSLocalizedString(@"请输入完整的组合数值",nil) 
													   delegate:nil 
											  cancelButtonTitle:NSLocalizedString(@"确定",nil) 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
    [self showDetail:NO];
//    [[NSNotificationCenter defaultCenter] postNotificationName:YDLabPalettesAddRecipeNotification object:nil userInfo:nil];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:YDBulkPalettesRemoveRecipeNotification object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:YDBulkAddictionRemoveRecipeNotification object:nil userInfo:nil];
//    [self removeFromSuperview];

}

- (void)cancelButton:(UIButton *)_sender
{
    [self removeFromSuperview];

}

- (void)updateChemical:(LAI_UIData *)_data
{
        [soltLabel_ setText:_data.NA2SO4];
    
        [sodaLabel_ setText:_data.NA2CO3];
        
    [warnTimeLabel_ setText:_data.keepWarnTime];
   
}

#pragma mark -----------
#pragma mark -------------- BULK查询计算助剂
//查询出来这些助剂，是为了当用户点击的时候不需要在去查询网络接口
- (void)queryBulkAuxiliariesWith:(NSString *)_xriteNO
                     withBatchNo:(NSString *)_batchNo
                  firstDyeCotton:(NSString *)_firstDyeCotton
                 withChemicalIds:(NSString *)_chemicalIds
                       withUsage:(NSString *)_usages
{
    NSLog(@"bulk 获取计算助剂 xriteNO :%@ _batchNo :%@ _firstDyeCotton :%@ _chemicalIds :%@ _usages :%@",xriteNO,_batchNo,_firstDyeCotton,_chemicalIds,_usages);
    [self queryBulkAuxiliariesWith:_xriteNO
                       withBatchNo:_batchNo
                    firstDyeCotton:@"0"
                   withChemicalIds:_chemicalIds
                         withUsage:_usages
                             block:^(BulkAuxiliariesInfo *result){
                                 //                                 self.addictives = result
                                 self.addictives =[[[LAI_UIData alloc] init] autorelease];
                                 self.addictives.keepWarnTime = result.baiUIData.keepWarnTime;
                                 self.addictives.NA2CO3 = result.baiUIData.NA2CO3;
                                 self.addictives.NA2SO4 = result.baiUIData.NA2SO4;
                                 
                                 [self updateChemical:self.addictives];
                                 
                             }];
}

- (void)queryBulkAuxiliariesWith:(NSString *)_xriteNO
                     withBatchNo:(NSString *)_batchNo
                  firstDyeCotton:(NSString *)_firstDyeCotton
                 withChemicalIds:(NSString *)_chemicalIds
                       withUsage:(NSString *)_usages
                           block:(void (^)(BulkAuxiliariesInfo *))block
{
    
    //    NSLog(@"xriteNo  %@  _batchNo  %@  _firstDyeCotton  %@  chemicalID %@  usages %@",xriteNO,_batchNo,_firstDyeCotton,_chemicalIds,_usages);
    
//    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [loadingView startAnimating];
//    loadingView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
//    [self addSubview:loadingView];
//    [loadingView release];
    [MBProgressHUD showHUDAddedTo:self animated:YES];

    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_queue_t networkProcessQueue = dispatch_queue_create("netquery.palettes", NULL);
    dispatch_async(networkProcessQueue,^{
        //        BulkAuxiliariesInfo *aux = [networkDataMemberHandle GetLabAuxiliariesInfo:_chemicalIds UsageStr:_usages];
        BulkAuxiliariesInfo*aux = [networkDataMemberHandle GetBulkAuxiliariesInfostring:xriteNO Batch_NO:_batchNo FirstDyeCotton:_firstDyeCotton ChemicalIDStr:_chemicalIds UsageStr:_usages];
        //        NSLog(@"aut.so4 %@ so3 %@ warnTime %@",aux.laiUIData.NA2SO4,aux.laiUIData.NA2CO3,aux.laiUIData.keepWarnTime);
        dispatch_async(dispatch_get_main_queue(), ^{
//            [loadingView removeFromSuperview];
            [MBProgressHUD hideHUDForView:self animated:YES];
            //            NSLog(@"bulk用户组 获取计算助剂   。。。。。");
            //            NSLog(@"lab获取调方信息信息   。。。。GroupInfoAry.count。 %d  ChemicalInfoAry.count .%d",resutl.GroupInfoAry.count,resutl.ChemicalInfoAry.count);
            block(aux);
        });
        
    });
    
    dispatch_release(networkProcessQueue);
}



#pragma mark ------------------------------------------
#pragma mark ----------- 查询计算助剂 lab用户
//查询出来这些助剂，是为了当用户点击的时候不需要在去查询网络接口
- (void)queryLabAuxiliariesWith:(NSString *)_chemicalIds withUsage:(NSString *)_usages;
{
    //    NSLog(@"_chemicalIds  %@ _usages  %@",_chemicalIds,_usages);
    [self queryLabAuxiliariesWith:_chemicalIds withUsage:_usages block:^(LabAuxiliariesInfo *auxiliar)
     {
         NSLog(@"LAB 获取计算助剂 NA2SO4 %@ NA2CO3 %@ keepWarnTime %@",auxiliar.laiUIData.NA2SO4,auxiliar.laiUIData.NA2CO3,auxiliar.laiUIData.keepWarnTime);
         //        NSString *NA2SO4;
         //        NSString *NA2CO3;
         //        NSString *keepWarnTime;
         self.addictives = auxiliar.laiUIData;
         [self updateChemical:self.addictives];
     }];
}

- (void)queryLabAuxiliariesWith:(NSString *)_chemicalIds withUsage:(NSString *)_usages block:(void (^)(LabAuxiliariesInfo *))block
{
    //    NSLog(@"_chemicalIds %@  _usages %@",_chemicalIds,_usages);
//    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [loadingView startAnimating];
//    loadingView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
//    [self addSubview:loadingView];
//    [loadingView release];
    [MBProgressHUD showHUDAddedTo:self animated:YES];

    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_queue_t networkProcessQueue = dispatch_queue_create("netquery.palettes", NULL);
    dispatch_async(networkProcessQueue,^{
        LabAuxiliariesInfo *aux = [networkDataMemberHandle GetLabAuxiliariesInfo:_chemicalIds UsageStr:_usages];
        //        NSLog(@"aut.so4 %@ so3 %@ warnTime %@",aux.laiUIData.NA2SO4,aux.laiUIData.NA2CO3,aux.laiUIData.keepWarnTime);
        dispatch_async(dispatch_get_main_queue(), ^{
//            [loadingView removeFromSuperview];
            [MBProgressHUD hideHUDForView:self animated:YES];
            //            NSLog(@"获取计算助剂   。。。。。");
            //            NSLog(@"lab获取调方信息信息   。。。。GroupInfoAry.count。 %d  ChemicalInfoAry.count .%d",resutl.GroupInfoAry.count,resutl.ChemicalInfoAry.count);
            block(aux);
        });
        
    });
    
    dispatch_release(networkProcessQueue);
    
}

- (void)show:(BOOL)_animated
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) 
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	[[[window subviews] objectAtIndex:0] addSubview:self]; 
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    //    判断输入的光标是不是在小数点前
    
    
    NSUInteger tempLength = 0;
    if (nDotLoc != NSNotFound) {
        tempLength = [textField.text length] - nDotLoc;
    }
    
    //    保证这个location是小数点后算起的location
    NSInteger location = range.location;
    
    //    range.location = range.location - nDotLoc;
    //
    if (location<=nDotLoc)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kInputNumberSet] invertedSet];
        
        //  NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString];
        NSString *filtered=[[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        //    NSLog(@"filtered %@",filtered);
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"请输入数字"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            return NO;
            
        }
        return YES;
    }
    else range.location = range.location - nDotLoc;
    
    if (textField == yellowLabel_ || textField == redLabel_    || textField == blueLabel_ || textField == moreField_) {
        if ( tempLength >5) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"小数点后保留五位"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            return NO;
        }
        
        //            }
    }
    
    
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kInputNumberSet] invertedSet];
//    
//    //  NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString];
//    NSString *filtered=[[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
//    BOOL basicTest = [string isEqualToString:filtered];
//    if(!basicTest)
//    {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示提示"
//                                                        message:@"请输入数字"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        
//        [alert show];
//        [alert release];
//        return NO;
//        
//    }
    
    //其他的类型不需要检测，直接写入
    return YES;
    
}


- (YDAppDelegate *)YDAppDelegate
{
    return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}


@end
