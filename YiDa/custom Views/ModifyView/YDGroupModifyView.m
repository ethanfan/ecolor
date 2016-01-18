//
//  YDGroupModifyView.m
//  YiDa
//
//  Created by Ni on 12-11-20.
//  Copyright 2012 meson.com. All rights reserved.
//

#import "YDGroupModifyView.h"
#import "YDAppDelegate.h"
#import "YDPostNotificationName.h"
#import "YDAddictions.h"
#import "Constants.h"

@interface YDGroupModifyView ()

- (void)setUpBackground;

- (void)setUpInterface;

- (void)confirmAction:(UIButton *)_sender;

- (void)cancelAction:(UIButton *)_sender;

- (BOOL)validInput;

- (void)setInputField:(NSArray *)_fields;




- (CGRect)_titleLabelFrame;
- (CGRect)_yellowLabelFrame;
- (CGRect)_redLabelFrame;
- (CGRect)_blueLabelFrame;
- (CGRect)_yellowFieldFrame;
- (CGRect)_redFieldFrame;
- (CGRect)_blueFieldFrame;
- (CGRect)_confirmButtonFrame;
- (CGRect)_cancelButtonFrame;

@end


#define kGroupModifyColor  [UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]

@implementation YDGroupModifyView

@synthesize backgroundImageView = backgroundImageView_;

@synthesize titleLabel = titleLabel_;
@synthesize yellowLabel = yellowLabel_;
@synthesize  redLabel = redLabel_;
@synthesize	blueLabel  = blueLabel_;
@synthesize yellowField = yellowField_;
@synthesize redField = redField_;
@synthesize	blueField = blueField_;
@synthesize moreField = moreField_;
@synthesize confirmButton = confirmButton_;
@synthesize cancelButton = cancelButton_;
@synthesize containerView = containerView_;

@synthesize delegate;
@synthesize chemicalList = chemicalList_;
@synthesize usages = usages_;

- (id)initWithFrame:(CGRect)frame {
    CGRect _frame = CGRectMake(252, 191, 512, 317);
	
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		UIView *a = [[UIView alloc] initWithFrame:self.bounds];
		[a setBackgroundColor:[UIColor blackColor]];
		a.alpha = 0.2;
		[self addSubview:a];
		[a release];
		a = nil;
		
		[self setBackgroundColor:[UIColor clearColor]];
//		self.alpha = 0.2;
		UIView *b = [[UIView alloc] initWithFrame:_frame];
		[b setBackgroundColor:[UIColor clearColor]];
		self.containerView = b;
		[b release];b = nil;
		[self addSubview:containerView_];
		[self setUpBackground];
        
        keyboard = [[NumberKeyboard alloc] initWithNibName:@"NumberKeyboard" bundle:nil];
        keyboard.showsPeriod = YES;
        keyboard.showsMinus = YES;
        
        
        // Get current selected range , this example assumes is an insertion point or empty selection
        UITextRange *selectedRange = [redField_ selectedTextRange];
        
        // Calculate the new position, - for left and + for right
        UITextPosition *newPosition = [redField_ positionFromPosition:selectedRange.start offset:-5];
        
        // Construct a new range using the object that adopts the UITextInput, our textfield
        UITextRange *newRange = [redField_ textRangeFromPosition:newPosition toPosition:selectedRange.start];
        
        // Set new range
        [redField_ setSelectedTextRange:newRange];
    }
    return self;
}

- (void)setChemicalListWith:(NSArray *)_list
{
    NSArray *array = [NSArray arrayWithArray:_list];
    self.chemicalList = array;
}

- (void)removeObserver
{
	[[NSNotificationCenter defaultCenter] removeObserver:keyboardShowObserver];
	[[NSNotificationCenter defaultCenter] removeObserver:keyboardHideObserver];
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

	[containerView_ release];containerView_ = nil;
	[backgroundImageView_ release];backgroundImageView_ = nil;
	[titleLabel_ release];titleLabel_  = nil;
	[yellowLabel_ release];yellowLabel_ = nil;
	[redLabel_ release];redLabel_ = nil;
	[blueLabel_ release];blueLabel_ = nil;
	[yellowField_ release];yellowField_ = nil;
	[redField_ release] ;redField_ = nil;
	[blueField_ release];blueField_ = nil;
    [moreField_ release];moreField_ = nil;
	[confirmButton_ release];confirmButton_ = nil;
	[cancelButton_ release];cancelButton_ = nil;
    [chemicalList_ release];chemicalList_ = nil;
    [usages_ release];usages_ = nil;
    
    [keyboard release];
    [super dealloc];
}

- (void)didMoveToSuperview
{
	if (!self.superview) return;
	
	[self setUpInterface];
    
    
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
#if NS_BLOCKS_AVAILABLE
//	(In a reference counted environment, the system retains the returned observer object until it is removed, so there is no need to retain it yourself.)
//  so,the observer should be removed for memery managerment
	keyboardShowObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock: ^(NSNotification *note)
	{
//		NSLog(@"show ");
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
			[UIView setAnimationDuration:0.3];
			//    NSLog(@"fjfjfjfjfjfjfjfjfj %@",NSStringFromCGRect(self.view.frame));
			[containerView_ setFrame:CGRectMake(containerView_.left,containerView_.top-60 , containerView_.width, containerView_.height)];
			//     NSLog(@"fjfjfjf2222222j %@",NSStringFromCGRect(self.view.frame));
			[UIView commitAnimations];
		});
		
    }];
	
	keyboardHideObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock: ^(NSNotification *note)
	 {
		 dispatch_async(dispatch_get_main_queue(), ^{
		 [UIView beginAnimations:nil context:NULL];
		 [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		 [UIView setAnimationDuration:0.3];
		 //    NSLog(@"fjfjfjfjfjfjfjfjfj %@",NSStringFromCGRect(self.view.frame));
		 [containerView_ setFrame:CGRectMake(containerView_.left,containerView_.top+60 , containerView_.width, containerView_.height)];
		 //     NSLog(@"fjfjfjf2222222j %@",NSStringFromCGRect(self.view.frame));
		 [UIView commitAnimations];
		 });
	 }];
#endif	

}

- (void)setUpBackground
{
	UIImageView *back = [[UIImageView alloc] initWithFrame:containerView_.bounds];
	[back setImage:[UIImage imageNamed:@"BackgroundModify_01.png"]];
	self.backgroundImageView = back;
	[back release];
	
	[containerView_ addSubview:backgroundImageView_];
}


- (void)setInputField:(NSArray *)_fields
{
//    NSInteger count = [_fields count];
//    for (int i = 0; i<count; i++)
//    {
//        NSString *content = [_fields objectAtIndex:i];
//        if (i == 0)
//        {
//            [yellowField_ setText:content];
//        }
//        else if(i==1)
//        {
//            [redField_ setText:content];   
//        }
//        else if (i== 2)
//        {
//            [blueField_ setText:content];
//        }
//    }
    
}

//输入被修改过的组合的修改值（因为该组合还没有被output，所以会存在这个值）
- (void)setInputFieldWith:(NSArray *)_list
{
    NSInteger count = [_list count];
    for (int i = 0; i<count; i++)
    {
        NSString *content = [_list objectAtIndex:i];
        if (i == 0)
        {
            [yellowField_ setText:content];
        }
        else if(i==1)
        {
            [redField_ setText:content];
        }
        else if (i== 2)
        {
            [blueField_ setText:content];
        }
        else if (i == 3)
        {
            [moreField_ setText:content];
        }
    }
}

//设置输入框的个数
- (void)setUpInputFieldWith:(NSInteger)_cout
{
    for (int i = 0; i<_cout; i++)
    {
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(320, 80+(15+30)*i, 150, 30)];
        field.delegate = self;
        field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [field setReturnKeyType:UIReturnKeyNext];
        [field setBorderStyle:UITextBorderStyleLine];
    	[field setBackgroundColor:kGroupModifyColor];
        if (i == 0)
        {
            self.yellowField = field;
        }
        else if(i==1)
        {
            self.redField = field;  
        }
        else if (i== 2)
        {
            self.blueField = field;
             [field setReturnKeyType:UIReturnKeyDone];
        }
        else if(i == 4)
        {
            self.moreField = field;
            [field setReturnKeyType:UIReturnKeyDone];
        }
        [containerView_ addSubview:field];
    	[field release];field = nil;
    }
    	
}

- (void)setUpChemicalNamesWith:(NSArray *)_names
{
    NSInteger _count = [_names count];
    for (int i = 0; i<_count; i++)
    {
        BGI_Atr_BestGroupInfo *group = (BGI_Atr_BestGroupInfo *)[_names objectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(82, 80+(15+30)*i, 150, 30)];
        [label setFont:[UIFont systemFontOfSize:13]];
        [label setBackgroundColor:kGroupModifyColor];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setText:group.Chemical_Name];
        [containerView_ addSubview:label];
        [label release];label = nil;
    }
}

- (void)setColorImagesWith:(NSInteger )_count
{
    for(int i =0;i<_count;i++)
    {
//        82, 86, 150, 30
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(50, 80+(15+30)*i, 22, 25)];
        NSString *imageName = [NSString stringWithFormat:@"Image0%d",i%3+1];
        [image setImage:[UIImage imageNamed:imageName]];
        [containerView_ addSubview:image];
        [image release];
    }
}

- (void)setUpInterface
{
//    UIColor *color = [UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.];
//    NSInteger count = [chemicalList_ count];
//    BGI_Atr_BestGroupInfo *group = nil;
//    int i = 0;
//    
//    if (i<count) {
//        group = (BGI_Atr_BestGroupInfo *)[chemicalList_ objectAtIndex:i];
//        i++;
//    }
//    
//	UILabel *label = [[UILabel alloc] initWithFrame:[self _titleLabelFrame]];
//     
//	[label setText:[NSString stringWithFormat:@"组合%@",group.Group_ID]];
//    [label setTextAlignment:UITextAlignmentCenter];
//	[label setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]];
//	self.titleLabel = label;
//	[label release];label = nil;
//	
//	label = [[UILabel alloc] initWithFrame:[self _yellowLabelFrame]];
//    [label setFont:[UIFont systemFontOfSize:13]];
//	[label setText:group.Chemical_Name];
//    [label setTextAlignment:UITextAlignmentCenter];
//	[label setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]];
//	self.yellowLabel = label;
//	[label release];label = nil;
//	
//    if (i<count) {
//        group = (BGI_Atr_BestGroupInfo *)[chemicalList_ objectAtIndex:i];
//        i++;
//    }
//	label = [[UILabel alloc] initWithFrame:[self _redLabelFrame]];
//     [label setFont:[UIFont systemFontOfSize:13]];
//	[label setText:group.Chemical_Name];
//    [label setTextAlignment:UITextAlignmentCenter];
//	[label setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]];
//	self.redLabel = label;
//	[label release];label = nil;
//	
//    if (i<count) {
//        group = (BGI_Atr_BestGroupInfo *)[chemicalList_ objectAtIndex:i];
//        i++;
//    }
//    
//	label = [[UILabel alloc] initWithFrame:[self _blueLabelFrame]];
//     [label setFont:[UIFont systemFontOfSize:13]];
//    [label setTextAlignment:UITextAlignmentCenter];
//	[label setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]];
//	[label setText:group.Chemical_Name];
//	self.blueLabel = label;
//	[label release];label = nil;
//	
//	UITextField *field = [[UITextField alloc] initWithFrame:[self _yellowFieldFrame]];
//    field.delegate = self;
//    field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    [field setReturnKeyType:UIReturnKeyNext];
//    [field setBorderStyle:UITextBorderStyleLine];
//	[field setBackgroundColor:color];
//	self.yellowField = field;
//	[field release];field = nil;
//	
//	field = [[UITextField alloc] initWithFrame:[self _redFieldFrame]];
//    field.delegate = self;
//    field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//	[field setBackgroundColor:color];
//    [field setReturnKeyType:UIReturnKeyNext];
//    [field setBorderStyle:UITextBorderStyleLine];
//
//	self.redField = field;
//	[field release];field = nil;
//	
//	field = [[UITextField alloc] initWithFrame:[self _blueFieldFrame]];
//    field.delegate = self;
//    field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//	[field setBackgroundColor:color];
//    [field setReturnKeyType:UIReturnKeyDone];
//	self.blueField = field;
//    [field setBorderStyle:UITextBorderStyleLine];
//
//	[field release];field = nil;
//	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//	[button setTitle:@"确定" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonModifyConfirm.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
	[button setFrame:[self _confirmButtonFrame]];
	self.confirmButton = button;
	button = nil;
	
	button = [UIButton buttonWithType:UIButtonTypeCustom];
//	[button setTitle:@"取消" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ButtonModifyCancel.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
	[button setFrame:[self _cancelButtonFrame]];
	self.cancelButton = button;
	button = nil;
    
    NSArray *usages = [usages_ componentsSeparatedByString:@","];
    
    
    [self setColorImagesWith:[chemicalList_ count]];
    [self setUpInputFieldWith:[chemicalList_ count]];
    
    [self setUpChemicalNamesWith:chemicalList_];
	
    [self setInputFieldWith:usages];
    
	[containerView_ addSubview:titleLabel_];
	[containerView_ addSubview:yellowLabel_];
	[containerView_ addSubview:redLabel_];
	[containerView_ addSubview:blueLabel_];
	[containerView_ addSubview:yellowField_];
	[containerView_ addSubview:redField_];
	[containerView_ addSubview:blueField_];
	
	[containerView_ addSubview:confirmButton_];
	[containerView_ addSubview:cancelButton_];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == yellowField_) {
		[redField_ becomeFirstResponder];
	}
	else if (textField == redField_)
	{
		[blueField_ becomeFirstResponder];
	}
	if (textField == blueField_) {
		[blueField_ resignFirstResponder];
	}
    
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    UITextRange *selectedRange = [textField selectedTextRange];
    NSLog(@"UITextRange class : %@",NSStringFromClass([selectedRange class]));


    keyboard.textField = textField;
    textField.inputView = keyboard.view;
	return YES;
}

- (BOOL)validInput
{
	BOOL valid = NO;
	if (yellowField_.text != nil && [yellowField_.text length]
		&& redField_.text != nil && [redField_.text length]
		&& blueField_.text != nil && [blueField_.text length])
	{
		valid = YES;
	}
	return valid;
}

- (void)confirmAction:(UIButton *)_sender
{
	if (![self validInput])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) 
														message:NSLocalizedString(@"请输入有效的组合数值",nil) 
													   delegate:nil 
											  cancelButtonTitle:NSLocalizedString(@"确定",nil) 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
    NSMutableDictionary *groupDictioary = [NSMutableDictionary dictionary];
//    NSMutableString *chemicalIDs = [NSMutableString stringWithCapacity:0];
//    BGI_Atr_BestGroupInfo *tempGroup = (BGI_Atr_BestGroupInfo *)[chemicalList_ objectAtIndex:0];
//    NSString     *groupID = tempGroup.Group_ID;
//    化学材料的使用量
    NSString     *usages = [NSString stringWithFormat:@"%0.5f,%0.5f,%0.5f",[yellowField_.text floatValue],[redField_.text floatValue],[blueField_.text floatValue]];
    if (moreField_) {
        usages = [usages stringByAppendingString:[NSString stringWithFormat:@",%0.5f",[moreField_.text floatValue]]];
    }
//    
//    NSInteger count = [chemicalList_ count];
//    for (int i = 0; i<count; i++)
//    {
//        BGI_Atr_BestGroupInfo *group = (BGI_Atr_BestGroupInfo *)[chemicalList_ objectAtIndex:i];
//        if (i== 0) {
//            [chemicalIDs appendString:[NSString stringWithFormat:@"%@",group.Chemical_ID]];
//        }
//        else {
//            [chemicalIDs appendString:[NSString stringWithFormat:@",%@",group.Chemical_ID]];
//        }
//    }
//    NSLog(@"chemicalIDs  %@  usage %@  groupid %@",chemicalIDs,usages,groupID);
//    
//    [groupDictioary setObject:groupID forKey:YDLabColorGroupIdKey];
//    [groupDictioary setObject:chemicalIDs forKey:YDLabColorChemicalIdKey];
//    [groupDictioary setObject:usages forKey:YDLabColorUsageKey];
    
    [groupDictioary setObject:chemicalList_ forKey:YDLabColorNewGroupKey];
    [groupDictioary setObject:usages forKey:YDLabColorUsageKey];
    
    if (delegate != nil &&[delegate respondsToSelector:@selector(finishModifyGroupWith:)])
    {
        [delegate finishModifyGroupWith:usages];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:YDLabColorAddGroupNotification object:nil userInfo:groupDictioary];
	[self removeObserver];
	[self removeFromSuperview];
}

- (void)cancelAction:(UIButton *)_sender
{
	[self removeObserver];
	[self removeFromSuperview];
}

- (void)show:(BOOL)_animated
{
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) 
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	[[[window subviews] objectAtIndex:0] addSubview:self];  
}





- (CGRect)_titleLabelFrame
{
	return CGRectMake(50, 30, 150, 35);
}

- (CGRect)_yellowLabelFrame
{
	return CGRectMake(82, 86, 150, 30);
}

- (CGRect)_redLabelFrame
{
	return CGRectMake(yellowLabel_.frame.origin.x, yellowLabel_.frame.origin.y+yellowLabel_.frame.size.height+22, 150, 30);
}

- (CGRect)_blueLabelFrame
{
	return CGRectMake(redLabel_.frame.origin.x, redLabel_.frame.origin.y+redLabel_.frame.size.height+22, 150, 30);

}

- (CGRect)_yellowFieldFrame
{
	return CGRectMake(320, 80, 150, 35);
}

- (CGRect)_redFieldFrame
{
	return CGRectMake(yellowField_.frame.origin.x, yellowField_.frame.origin.y+yellowField_.frame.size.height+19, 150, 35);

}

- (CGRect)_blueFieldFrame
{
	return CGRectMake(redField_.frame.origin.x, redField_.frame.origin.y+redField_.frame.size.height+19, 150, 35);

}

- (CGRect)_confirmButtonFrame
{
	return CGRectMake(293, 267, 70, 30);
}

- (CGRect)_cancelButtonFrame
{
	return CGRectMake(confirmButton_.frame.origin.x +confirmButton_.frame.size.width+20, confirmButton_.frame.origin.y, 70, 30);

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
        return YES;
    }
    else range.location = range.location - nDotLoc;
 
    if (textField == yellowField_ || textField == redField_    || textField == blueField_ || textField == moreField_) {
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
    

    
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kInputNumberSet] invertedSet];
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

@end
