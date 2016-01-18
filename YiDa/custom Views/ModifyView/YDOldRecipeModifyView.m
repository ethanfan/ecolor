//
//  YDOldRecipeModifyView.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDOldRecipeModifyView.h"
#import "YDPostNotificationName.h"
#import "BulkAuxiliariesInfo.h"
#import "DataMember.h"
#import "YDAppDelegate.h"
#import "YDAddictions.h"
#import "MBProgressHUD.h"

//
//#define kLabRect CGRectMake(355, 72, 328, 379)
//#define kLabRectDetail CGRectMake(355, 72, 328, 636)
//
////#define kBulkRect CGRectMake(355, 72, 328, 689)
//#define kBulkRectDetail CGRectMake(355, 72, 328, 689)


@interface YDOldRecipeModifyView ()
- (void)setUpBackgroundImage;
- (void)setUpInterface;

- (void)detailButton:(UIButton *)_sender;

- (void)showDetail:(BOOL)_showOrHide;

- (void)initArrowImagesWith:(NSInteger)_count;
- (void)initPercentImagesWith:(NSInteger)_count;

- (BOOL)validRecipe;
- (BOOL)validArtwork;
- (void)initRemodifyButtonWith:(YDUserType )_userType;

- (CGFloat)calculateInput:(CGFloat )_rate withOldValue:(CGFloat )_value;

@end

@implementation YDOldRecipeModifyView

@synthesize titleLabel = titleLabel_;
@synthesize yellowLabel = yellowLabel_;
@synthesize redLabel = redLabel_;
@synthesize blueLabel = blueLabel_;
@synthesize moreLabel = moreLabe_;

@synthesize yellowInputField = yellowInputField_;
@synthesize redInputField = redInputField_;
@synthesize blueInputField = blueInputField_;
@synthesize moreInputField = moreInputField_;

@synthesize yellowResultField = yellowResultField_;
@synthesize redResultField = redResultField_;
@synthesize blueResultField = blueResultField_;
@synthesize moreResultField = moreResultField_;

@synthesize recipeConfirmButton = recipeConfirmButton_;
@synthesize recipeCancelButton = recipeCancelButton_;

@synthesize soltInputField = soltInputField_;
@synthesize sodaInputField = sodaInputField_;
@synthesize warnInputField = warnInputField_;

@synthesize confirmButton = confirmButton_;
@synthesize cancelButton = cancelButton_;

@synthesize remodifyButton = remodifyButton_;

@synthesize bathRate = bathRate_;

@synthesize backgroundImageView = backgroundImageView_;
@synthesize detailButton = detailButton_;

@synthesize userType = userType_;

@synthesize containerView = containerView_;

@synthesize rato = rato_;
@synthesize addictives = addictives_ ;
@synthesize recipeValue = recipeValue_;


@synthesize batchNo;
@synthesize xriteNO;
@synthesize firstDyeCotton;
@synthesize chemicalIds;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		UIView *a = [[UIView alloc] initWithFrame:self.bounds];
		[a setBackgroundColor:[UIColor blackColor]];
		a.alpha = 0.2;
		[self addSubview:a];
		[a release];
		a = nil;
		self.userType = YDUserTypeBulk;
		containerHeight = 636;
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(183, 72, 659, 379)];
        [view setBackgroundColor:[UIColor clearColor]];
        self.containerView = view;
        [view release];view = nil;
        [self addSubview:containerView_];
        [self setUpBackgroundImage];
        keyboard = [[NumberKeyboard alloc] initWithNibName:@"NumberKeyboard" bundle:nil];
        keyboard.showsPeriod = YES;
        keyboard.showsMinus = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame userType:(YDUserType )_userType
{
	self = [super initWithFrame:frame];
    if (self) {
		
		UIView *a = [[UIView alloc] initWithFrame:self.bounds];
		[a setBackgroundColor:[UIColor blackColor]];
		a.alpha = 0.2;
		[self addSubview:a];
		[a release];
		a = nil;
		self.userType = _userType ;
		containerHeight = 636;
		if (userType_ == YDUserTypeBulk)
		{
			containerHeight = 689;
		}
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(183, 72, 659, 379)];
        [view setBackgroundColor:[UIColor clearColor]];
        self.containerView = view;
        [view release];view = nil;
        [self addSubview:containerView_];
        [self setUpBackgroundImage];
        keyboard = [[NumberKeyboard alloc] initWithNibName:@"NumberKeyboard" bundle:nil];
        keyboard.showsPeriod = YES;
        keyboard.showsMinus = YES;
    }
    return self;
	
}

- (void)dealloc
{

    [titleLabel_ release];titleLabel_ = nil;
    [yellowLabel_ release];yellowLabel_ = nil;
    [redLabel_ release];redLabel_ = nil;
    [blueLabel_ release];blueLabel_ = nil;
    [moreLabe_ release];moreLabe_ = nil;
    
    [yellowInputField_ release];yellowInputField_ = nil;
    [redInputField_ release];redInputField_ = nil;
    [blueInputField_ release];blueInputField_ = nil;
    [moreInputField_ release];moreInputField_ = nil;
    
    [yellowResultField_ release];yellowResultField_ = nil;
    [redResultField_ release];redResultField_ = nil;
    [blueResultField_ release];blueResultField_ = nil;
    [moreResultField_ release];moreResultField_ = nil;
    
    [recipeConfirmButton_ release];recipeConfirmButton_ = nil;
    [recipeCancelButton_ release];recipeCancelButton_ = nil;
    
    [soltInputField_ release];soltInputField_ = nil;
    [sodaInputField_ release];sodaInputField_ = nil;
    [warnInputField_ release];warnInputField_ = nil;
    [confirmButton_ release];confirmButton_ = nil;
    [cancelButton_ release];cancelButton_ = nil;
    
    [remodifyButton_ release];remodifyButton_ = nil;
    
	[bathRate_ release];bathRate_ = nil;

	[backgroundImageView_ release];backgroundImageView_ = nil;
	[detailButton_ release];detailButton_ = nil;
	[containerView_ release];containerView_ = nil;
    
    [rato_ release];rato_ = nil;
    [addictives_ release];addictives_ = nil;
    [recipeValue_ release];recipeValue_  = nil;
    
    self.chemicalIds = nil;
    self.xriteNO = nil;
    self.firstDyeCotton = nil;
    self.batchNo = nil;
    
    [keyboard release];keyboard = nil;
    [super dealloc];
}

//计算输入百分比后，计算结果，把结果放到右边的结果field里面去
- (CGFloat)calculateInput:(CGFloat )_rate withOldValue:(CGFloat )_value
{
    CGFloat resutl = _value;
    resutl = _value*(1+_rate/100.0);
    return resutl;
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
    [self initRemodifyButtonWith:userType_];
	
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
//								NSDictionary* info = [note userInfo];
//								CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
								CGRect aRect = containerView_.frame;
								aRect.size.height -= 389;
								CGPoint aPoint = activeField.frame.origin;
//								aPoint = CGPointMake(aPoint.x, aPoint.y);
								if (!CGRectContainsPoint(aRect, aPoint) ) {
									[UIView beginAnimations:nil context:NULL];
									[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
									[UIView setAnimationDuration:0.3];
									[containerView_ setFrame:CGRectMake(containerView_.left,containerView_.top-aPoint.y , containerView_.width, containerView_.height)];
									[UIView commitAnimations];
								}
								
							}];
	
#endif	
	
	
}

- (void)setUpBackgroundImage
{
    UIImageView *image = [[UIImageView alloc] initWithFrame:containerView_.bounds];
    [image setImage:[UIImage imageNamed:@"BackgroundModify_07.png"]];
	self.backgroundImageView = image;
    [containerView_ addSubview:image];
    [image release];
}

- (void)initRemodifyButtonWith:(YDUserType )_userType
{
    if (_userType == YDUserTypeBulk) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(570, 5, 81, 37)];
        [button setImage:[UIImage imageNamed:@"ButtonRemodify_01.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"ButtonRemodify_02.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(modifyButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        self.remodifyButton = button;
        [containerView_ addSubview:button];
    }
}

- (void)modifyButtonPress:(UIButton *)_button
{
    modify = _button.selected = !_button.selected;
}

//箭头
- (void)initArrowImagesWith:(NSInteger)_count
{
    for (int i = 0; i<_count; i++) {
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(370, 78+(17+33)*i, 26, 17)];
        [arrow setImage:[UIImage imageNamed:@"ImageArrow.png"]];
        [containerView_ addSubview:arrow];
        [arrow release];
    }
    
   
}
//百分号
- (void)initPercentImagesWith:(NSInteger)_count
{
    for (int i = 0; i<_count; i++) {
        UIImageView *percent = [[UIImageView alloc] initWithFrame:CGRectMake(310, 72+(30+19)*i, 29, 30)];
        [percent setImage:[UIImage imageNamed:@"ImagePercent.png"]];
        [containerView_ addSubview:percent];
        [percent release];
    }
}

- (void)setUpInterface
{
     UIColor *color = [UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(270, 25, 130, 30)];
    [label setBackgroundColor:color];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setMinimumFontSize:10.0];
    [label setAdjustsFontSizeToFitWidth:YES];
    self.titleLabel = label;
    [label setText:recipeValue_.titleName];
    
    if ([recipeValue_.titleName length]) {
        NSString *f = [recipeValue_.titleName substringToIndex:1];
        if ([f isEqualToString:@"D"]) {
            [label setTextColor:cklRed];
        }
        else if ([f isEqualToString:@"L"])
        {
            [label setTextColor:cklFuchsia];
        }
        else if ([f isEqualToString:@"S"])
        {
            [label setTextColor:cklMaroon];
        }
    }

    
    [label release];label = nil;
    [containerView_ addSubview:titleLabel_];
    
//    配方值
    NSMutableArray *values = recipeValue_.valueAry;
    NSInteger valueCount = [values count];
    [self initArrowImagesWith:valueCount];
    [self initPercentImagesWith:valueCount];
    for (int i= 0; i<valueCount; i++)
    {
        NSString *value = [values objectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 72+(30+19)*i, 100, 30)];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setText:value];
        [label setBackgroundColor:color];
        if (i== 0) 
        {
            self.yellowLabel = label;
        }
        if (i==1) 
        {
            self.redLabel = label;
        }
        if (i == 2) 
        {
            self.blueLabel = label;
        }
        if (i == 3)
        {
            self.moreLabel = label;
        }
        [containerView_ addSubview:label];
        [label release];label = nil;
    }
    
//    输入百分值
    for (int i = 0; i<valueCount; i++)
    {
        UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(200, 72+(30+19)*i, 100, 30)];
        label.delegate = self;
        [label setBackgroundColor:color];
        label.returnKeyType = UIReturnKeyNext;
        label.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        label.borderStyle = UITextBorderStyleLine;
        [label setTextAlignment:UITextAlignmentCenter];
        [label setBackgroundColor:color];
        if (i== 0) self.yellowInputField = label;
        if (i== 1) self.redInputField = label;
        if (i== 2) 
        {
            self.blueInputField = label ;
            label.returnKeyType = UIReturnKeyDone;
        }
        if (i == 3)
        {
            blueInputField_.returnKeyType = UIReturnKeyNext;
            self.moreInputField = label;
            label.returnKeyType = UIReturnKeyDone;
        }
        [containerView_ addSubview:label];
        [label release];label = nil;
    }
//    结果值
    for (int i = 0; i<valueCount; i++)
    {
        UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(475, 72+(30+19)*i, 150, 30)];
        [label setBackgroundColor:color];
        NSString *value = [values objectAtIndex:i];

        label.delegate = self;
        label.returnKeyType = UIReturnKeyNext;
        label.borderStyle = UITextBorderStyleLine;
        label.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [label setTextAlignment:UITextAlignmentCenter];
        [label setBackgroundColor:color];
        [label setText:value];
        
        if (i== 0) self.yellowResultField = label;
        if (i== 1) self.redResultField = label;
        if (i== 2) 
        {
            self.blueResultField = label ;
            label.returnKeyType = UIReturnKeyDone;
        }
        if (i == 3)
        {
            moreResultField_.returnKeyType = UIReturnKeyNext;
            self.moreResultField = label;
            label.returnKeyType = UIReturnKeyDone;
        }
        [containerView_ addSubview:label];
        [label release];label = nil;
    }
    
    for (int i = 0; i<2; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(248+(78+25)*i, 252, 78, 30)];
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
    
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(0, 316, 659, 55)];
	[button addTarget:self action:@selector(detailButton:) forControlEvents:UIControlEventTouchUpInside];
	self.detailButton = button;
	[containerView_ addSubview:button];
	
	//工艺和辅助
	NSInteger count = 3 ,y = 389;
	if (userType_ == YDUserTypeBulk)
	{
		count = 4;
		y = 395;
	}
    for (int i = 0; i<count; i++)
    {
        UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(317, y+(35+19)*i, 150, 35)];
        label.delegate = self;
        label.returnKeyType = UIReturnKeyNext;
        label.borderStyle = UITextBorderStyleLine;
        label.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [label setTextAlignment:UITextAlignmentCenter];
		label.hidden = YES;
        [label setBackgroundColor:color];
        if (i== 0) 
        {
            self.soltInputField = label;
            [label setText:addictives_.NA2SO4];
        }
        if (i== 1) 
        {
            self.sodaInputField = label;
            [label setText:addictives_.NA2CO3];
        }
		if (i== 2) 
        {
			if (userType_ == YDUserTypeBulk)
			{
				self.bathRate = label ;
                [label setText:self.rato];
//                NSLog(@"ratio %@",self.rato);
			}
			else if (userType_ == YDUserTypeLab)
			{
				self.warnInputField = label ;
                [label setText:addictives_.keepWarnTime];
				label.returnKeyType = UIReturnKeyDone;
//                NSLog(@"warnTime  %@",addictives_.keepWarnTime);
			}
            
        }
		if (i== 3)
		{
			self.warnInputField = label;
             [label setText:addictives_.keepWarnTime];
			label.returnKeyType = UIReturnKeyDone;
//            NSLog(@"warnTime  %@",addictives_.keepWarnTime);
		}
		
//        if (i== 2) 
//        {
//            self.warnInputField = label ;
//            label.returnKeyType = UIReturnKeyDone;
//        }
        [containerView_ addSubview:label];
        [label release];label = nil;
    }
    
	y = 569;
	if (userType_ == YDUserTypeBulk)
	{
		y = 630;
	}
	
	
    for (int i = 0; i<2; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(248+(78+25)*i, y, 78, 30)];
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

- (void)detailButton:(UIButton *)_sender
{
	BOOL select = _sender.selected = !_sender.selected;
	[self showDetail:select];
}


- (UIImage *)backImageWith:(YDUserType )_userType
{
	UIImage *image = nil;
	switch (userType_)
	{
		case YDUserTypeBulk:
			image = [UIImage imageNamed:@"BackgroundModify_10.png"];
			break;
		case YDUserTypeLab:
			image = [UIImage imageNamed:@"BackgroundModify_08.png"];
			break;
			
		default:
			break;
	}
	return image;
}

- (void)showDetail:(BOOL)_showOrHide
{
    NSInteger userType = [[self YDAppDelegate] currentUserType];

	if (_showOrHide)
	{
		[backgroundImageView_ setImage:[self backImageWith:userType_]];
		[containerView_ setFrame:CGRectMake(containerView_.left, containerView_.top, containerView_.width, containerHeight)];
		[backgroundImageView_ setFrame:containerView_.bounds];
		soltInputField_.hidden = NO;
		sodaInputField_.hidden = NO;
		warnInputField_.hidden = NO;
		confirmButton_.hidden = NO;
		cancelButton_.hidden = NO;
		bathRate_.hidden = NO;
        
        if (userType == YDUserTypeLab)
        {
            [self queryLabAuxiliariesWith:self.chemicalIds withUsage:[self getNewUsage]];
        }
        else if (userType == YDUserTypeBulk)
        {
            [self queryBulkAuxiliariesWith:self.xriteNO withBatchNo:self.batchNo firstDyeCotton:self.firstDyeCotton withChemicalIds:self.chemicalIds withUsage:[self getNewUsage]];
        }
	}
	else 
	{
		[backgroundImageView_ setImage:[UIImage imageNamed:@"BackgroundModify_07.png"]];
		[containerView_ setFrame:CGRectMake(containerView_.left, containerView_.top, containerView_.width, 379)];
		[backgroundImageView_ setFrame:containerView_.bounds];
		soltInputField_.hidden = YES;
		sodaInputField_.hidden = YES;
		warnInputField_.hidden = YES;
		confirmButton_.hidden = YES;
		cancelButton_.hidden = YES;
		bathRate_.hidden = YES;
	}
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == yellowInputField_) {
		[redInputField_ becomeFirstResponder];
	}
	else if (textField == redInputField_)
	{
		[blueInputField_ becomeFirstResponder];
	}
	else if (textField == blueInputField_) {
		
        if (moreInputField_)
        {
            [moreInputField_ becomeFirstResponder];
        }
        else
        {
            [blueInputField_ resignFirstResponder];
        }
	}
    else if (textField == moreInputField_)
    {
        [moreInputField_ resignFirstResponder];
    }
	
    
	if (textField == yellowResultField_) {
		[redResultField_ becomeFirstResponder];
	}
	else if (textField == redResultField_)
	{
		[blueResultField_ becomeFirstResponder];
	}
	else if (textField == blueResultField_) {
        if (moreResultField_) {
            [moreResultField_ becomeFirstResponder];
        }
        else
        {
            [blueResultField_ resignFirstResponder];
        }
	}
    else if (textField == moreResultField_)
    {
        [moreResultField_ resignFirstResponder];
    }
	
    
	if (textField == soltInputField_) {
		[sodaInputField_ becomeFirstResponder];
	}
	else if (textField == sodaInputField_)
	{
		[warnInputField_ becomeFirstResponder];
	}
	else if (textField == warnInputField_) {
		[warnInputField_ resignFirstResponder];
	}
	else if (textField == bathRate_)
	{
		[warnInputField_ becomeFirstResponder]; 
	}

	
	
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    keyboard.textField = textField;
    textField.inputView = keyboard.view;
	activeField = textField;
	
		
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
 
    if (textField == yellowInputField_  && [textField.text length]) 
    {
//        取输入数据的小数点后一位去计算
        NSString *input = [NSString stringWithFormat:@"%0.1f",[textField.text floatValue]];
        CGFloat result = [self calculateInput:[input floatValue] withOldValue:[yellowLabel_.text floatValue]];
        [yellowResultField_ setText:[NSString stringWithFormat:@"%.4f",result]];
	}
	else if (textField == redInputField_ &&  [textField.text length])
	{
        NSString *input = [NSString stringWithFormat:@"%0.1f",[textField.text floatValue]];
        CGFloat result = [self calculateInput:[input floatValue] withOldValue:[redLabel_.text floatValue]];
        [redResultField_ setText:[NSString stringWithFormat:@"%.4f",result]];
	}
	else if (textField == blueInputField_ && [textField.text length])
    {
        NSString *input = [NSString stringWithFormat:@"%0.1f",[textField.text floatValue]];
        CGFloat result = [self calculateInput:[input floatValue] withOldValue:[blueLabel_.text floatValue]];
        [blueResultField_ setText:[NSString stringWithFormat:@"%.4f",result]];
	}
    else if (textField == moreInputField_ && [textField.text length])
    {
        NSString *input = [NSString stringWithFormat:@"%0.1f",[textField.text floatValue]];
        CGFloat result = [self calculateInput:[input floatValue] withOldValue:[moreLabe_.text floatValue]];
        [moreResultField_ setText:[NSString stringWithFormat:@"%.4f",result]];
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
      NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
//    判断输入的光标是不是在小数点前
    NSLog(@"LOCATION %d  ndotloc %d",range.location,nDotLoc);
    
    
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
        
        //其他的类型不需要检测，直接写入
        return YES;
    }
    else range.location = range.location - nDotLoc;

        if (textField == yellowInputField_ || textField == redInputField_ || textField == blueInputField_ || textField == moreInputField_) {
//            if (NSNotFound != nDotLoc &&  range.location >  1 )
//            {
//                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                                message:@"小数点后保留一位"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil];
//                
//                [alert show];
//                [alert release];
//                return NO;
//            }
            
            if ( tempLength >1) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"小数点后保留一位"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                return NO;
            }
                
//                return NO;
//            }
        }
        if (textField == yellowResultField_ || textField == redResultField_ || textField == blueResultField_ || textField == moreResultField_) {
//            if (   range.location > 4 &&NSNotFound != nDotLoc)
//            {
//                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                                message:@"小数点后保留四位"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil];
//                
//                [alert show];
//                [alert release];
//                return NO;
//            }
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

//    }
//    }

    return YES;
    
}


- (BOOL)validRecipe
{
	BOOL valid = YES;
    if (yellowResultField_) {
        if (![yellowResultField_.text length]) {
            return NO;
        }
    }
    if (redResultField_) {
        if (![redResultField_.text length]) {
            return NO;
        }
    }
    if (blueResultField_) {
        if (![blueResultField_.text length]) {
            return NO;
        }
    }
    if (moreResultField_) {
        if (![moreResultField_.text length]) {
            return NO;
        }
    }
//	if (yellowResultField_.text!= nil && [yellowResultField_.text length] &&
//		redResultField_.text != nil && [redResultField_.text length] && 
//		blueResultField_.text != nil && [blueResultField_.text length])
//	{
//		valid = YES;
//	}
	return valid;
}
- (BOOL)validArtwork
{
	BOOL valid = NO;
	if (soltInputField_.text!= nil && [soltInputField_.text length] &&
		sodaInputField_.text != nil && [sodaInputField_.text length] && 
		warnInputField_.text != nil && [warnInputField_.text length])
	{
		valid = YES;
	}
	return valid;
	
}

- (void)show:(BOOL)_animated
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) 
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	[[[window subviews] objectAtIndex:0] addSubview:self]; 
}

#pragma mark -------------
#pragma mark button actions -----

- (NSString *)getNewUsage
{
    NSString *newUsages = [NSString stringWithFormat:@"%0.5f",[yellowResultField_.text floatValue]];
    if (redResultField_) {
        newUsages = [newUsages stringByAppendingString:[NSString stringWithFormat:@",%0.5f",[redResultField_.text floatValue]]];
    }
    if (blueResultField_) {
        newUsages = [newUsages stringByAppendingString:[NSString stringWithFormat:@",%0.5f",[blueResultField_.text floatValue]]];
    }
    if (moreInputField_) {
        newUsages = [newUsages stringByAppendingString:[NSString stringWithFormat:@",%0.4f",[moreResultField_.text floatValue]]];
    }
    return newUsages;

}

- (void)recipeConfrimButton:(UIButton *)_sender
{
    [blueInputField_ resignFirstResponder];
	if (![self validRecipe] || ![self validArtwork])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) 
														message:NSLocalizedString(@"请输入完整的配方数值",nil) 
													   delegate:nil 
											  cancelButtonTitle:NSLocalizedString(@"确定",nil) 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
    
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    
//    NSString *newUsages  = [NSString stringWithFormat:@"%0.4f,%0.4f,%0.4f",[yellowResultField_.text floatValue],[redResultField_.text floatValue],[blueResultField_.text floatValue]];
//    if (moreInputField_) {
//        newUsages = [newUsages stringByAppendingString:[NSString stringWithFormat:@",%0.4f",[moreResultField_.text floatValue]]];
//    }
    
    NSString *newUsages = [self getNewUsage];
     NSString *newAndOld  = [self generateOldUsage:recipeValue_];
    NSArray *newValueArray = [newUsages componentsSeparatedByString:@","];
    recipeValue_.valueAry = [NSMutableArray arrayWithArray:newValueArray];
    addictives_.NA2SO4 = soltInputField_.text;
    addictives_.NA2CO3 = sodaInputField_.text;
    addictives_.keepWarnTime = warnInputField_.text;
    [userInfo setObject:newUsages forKey:YDNewRecipeNewUsageKey];
    [userInfo setObject:recipeValue_ forKey:YDNewRecipeOldUsageKey];
    [userInfo setObject:addictives_ forKey:YDNewRecipeArtworkKey];
    [userInfo setObject:newAndOld forKey:YDNewAndOldUsageKey];
     recipeValue_.titleName = nil;   //只要是新生成的配方均没有配方号
    
    if (userType_ ==YDUserTypeLab)
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:YDLabPalettesAddRecipeNotification object:nil userInfo:userInfo];
    }
    if (userType_ == YDUserTypeBulk) {
        [userInfo setObject:[NSNumber numberWithBool:modify] forKey:YDBulkRemodifyKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:YDBulkPalettesAddRecipeNotification object:nil userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:YDBulkAddictionAddRecipeNotification object:nil userInfo:userInfo];
    }
   
  
    [self removeFromSuperview];
}

- (void)confirmButton:(UIButton *)_sender
{
	if (![self validArtwork])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) 
														message:NSLocalizedString(@"请输入完整的配方数值",nil) 
													   delegate:nil 
											  cancelButtonTitle:NSLocalizedString(@"确定",nil) 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
//     [[NSNotificationCenter defaultCenter] postNotificationName:YDLabPalettesAddRecipeNotification object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:YDBulkPalettesAddRecipeNotification object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:YDBulkAddictionAddRecipeNotification object:nil userInfo:nil];
//    [self removeFromSuperview];
    [self showDetail:NO];
}

- (void)cancelButton:(UIButton *)_sender
{
    [self removeFromSuperview];
    
}

- (void)updateChemical:(LAI_UIData *)_data
{
    [soltInputField_ setText:_data.NA2SO4];
    
    [sodaInputField_ setText:_data.NA2CO3];
    
    [warnInputField_ setText:_data.keepWarnTime];
    
}

- (void)setValue:(NSString *)_batchNo xriteNo:(NSString *)_xriteNo firstDyeCotton:(NSString *)_firstDyeCotton
{
    self.xriteNO = _xriteNo;
    self.batchNo = _batchNo;
    self.firstDyeCotton = _firstDyeCotton;
}
#pragma mark -----------
#pragma mark -------------- 查询计算助剂
//查询出来这些助剂，是为了当用户点击的时候不需要在去查询网络接口
- (void)queryBulkAuxiliariesWith:(NSString *)_xriteNO
                     withBatchNo:(NSString *)_batchNo
                  firstDyeCotton:(NSString *)_firstDyeCotton
                 withChemicalIds:(NSString *)_chemicalIds
                       withUsage:(NSString *)_usages
{
    NSLog(@"bulk 获取计算助剂 xriteNO :%@ _batchNo :%@ _firstDyeCotton :%@ _chemicalIds :%@ _usages :%@",_xriteNO,_batchNo,_firstDyeCotton,_chemicalIds,_usages);
    [self queryBulkAuxiliariesWith:_xriteNO
                       withBatchNo:_batchNo
                    firstDyeCotton:_firstDyeCotton
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
            [MBProgressHUD hideHUDForView:self animated:YES];
//            [loadingView removeFromSuperview];
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
            [MBProgressHUD hideHUDForView:self animated:YES];
//            [loadingView removeFromSuperview];
            //            NSLog(@"获取计算助剂   。。。。。");
            //            NSLog(@"lab获取调方信息信息   。。。。GroupInfoAry.count。 %d  ChemicalInfoAry.count .%d",resutl.GroupInfoAry.count,resutl.ChemicalInfoAry.count);
            block(aux);
        });
        
    });
    
    dispatch_release(networkProcessQueue);
    
}

- (YDAppDelegate *)YDAppDelegate
{
    return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}


@end
