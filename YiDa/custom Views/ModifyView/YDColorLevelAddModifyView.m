//
//  YDColorLevelAddModifyView.m
//  YiDa
//
//  Created by Ni on 12-11-21.
//  Copyright 2012 meson.com. All rights reserved.
//

#import "YDColorLevelAddModifyView.h"


@interface YDColorLevelAddModifyView ()

- (void)setUpBackgroundImage;
- (void)setUpInterface;
- (void)confirmButtonAction:(UIButton *)_sender;
- (void)cancelButtonAction:(UIButton *)_sender;

@end


@implementation YDColorLevelAddModifyView


@synthesize containerView = containerView_;
@synthesize confirmButton = confirmButton_;
@synthesize cancelButton = cancelButton_;
@synthesize nameField = nameField_;
@synthesize modifyType = modifyType_;

@synthesize recieveTarget = recieveTarget_;

@synthesize delegate;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		UIView *a = [[UIView alloc] initWithFrame:self.bounds];
		[a setBackgroundColor:[UIColor blackColor]];
		a.alpha = 0.2;
		[self addSubview:a];
		[a release];
		a = nil;
		
		modifyType_ = YDColorLevelModifyTypeNone;
		[self setBackgroundColor:[UIColor clearColor]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(286, 280, 512, 97)];
        [view setBackgroundColor:[UIColor clearColor]];
        self.containerView = view;
        [view release];view = nil;
        [self addSubview:containerView_];
        [self setUpBackgroundImage];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(YDColorLevelModifyType )_type
{
	
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
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(286, 280, 512, 97)];
//        [view setBackgroundColor:[UIColor clearColor]];
        self.containerView = view;
        [view release];view = nil;
        [self addSubview:containerView_];
        [self setUpBackgroundImage];
		
		modifyType_ = _type;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(YDColorLevelModifyType )_type
           delegate:(id<YDColorLevelAddModifyViewDelegate>)_delegate
{
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
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(286, 280, 512, 97)];
        //        [view setBackgroundColor:[UIColor clearColor]];
        self.containerView = view;
        [view release];view = nil;
        [self addSubview:containerView_];
        [self setUpBackgroundImage];
		
		modifyType_ = _type;
        self.delegate = _delegate;
    }
    return self;
}

- (void)setUpBackgroundImage
{
	UIImageView *image = [[UIImageView alloc] initWithFrame:containerView_.bounds];
	UIImage *i = [UIImage imageNamed:@"BackgroundModify_12.png"];
    [image setImage:i];
    [containerView_ addSubview:image];
    [image release];
}
- (void)setUpInterface
{
	UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(18, 32, 260, 35)];
	[field setPlaceholder:@"输入色级名称"];
    field.delegate = self;
	[field setFont:[UIFont systemFontOfSize:18]];
	[field setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:218.0/255. blue:209/255.0 alpha:1.]];
	[field setBorderStyle:UITextBorderStyleLine];
	self.nameField = field;
	[field release];field = nil;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setBackgroundImage:[UIImage imageNamed:@"ButtonModifyConfirm.png"] forState:UIControlStateNormal];
	[button setFrame:CGRectMake(319, 35, 78, 30)];
	[button addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	self.confirmButton = button;
	button = nil;
	
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setBackgroundImage:[UIImage imageNamed:@"ButtonModifyCancel.png"] forState:UIControlStateNormal];
	[button setFrame:CGRectMake(confirmButton_.frame.origin.x+confirmButton_.frame.size.width+25, confirmButton_.frame.origin.y, 78, 30)];
	[button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	self.cancelButton = button;
	button = nil;
	
	[containerView_ addSubview:nameField_];
	[containerView_ addSubview:confirmButton_];
	[containerView_ addSubview:cancelButton_];
	
}

- (void)dealloc {
	[confirmButton_ release];confirmButton_ = nil;
	[cancelButton_ release];cancelButton_ = nil;
	[nameField_ release];nameField_ = nil;
	[containerView_ release];containerView_ = nil;
    [super dealloc];
}

- (void)didMoveToSuperview
{
	[self setUpInterface];
}


- (void)show:(BOOL)_animated
{
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) 
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	[[[window subviews] objectAtIndex:0] addSubview:self]; 
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark ---------
#pragma mark button actions -------
- (void)confirmButtonAction:(UIButton *)_sender
{
    
    [nameField_ resignFirstResponder];
    
    if (![nameField_.text length]) {
        return;
    }
	if ( [nameField_.text length]>6)
	{
        [nameField_ resignFirstResponder];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入小于6位数的色级名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
		return;
	}
//	所有的色级均为大写
    NSString *newColorName = [nameField_.text uppercaseString];
    
	if (modifyType_ == YDColorLevelModified)
	{
//		if (recieveTarget_ != nil && [recieveTarget_ respondsToSelector:@selector(updateColorLevelName:)])
//		{
//			[recieveTarget_ updateColorLevelName:nameField_.text];
//		}
        if (delegate != nil &&[delegate respondsToSelector:@selector(didchooseModifyName:name:)]) {
            [delegate didchooseModifyName:self name:newColorName];
        }
	}
	else if (modifyType_ == YDColorLevelAddType)
	{
//		if (recieveTarget_ != nil && [recieveTarget_ respondsToSelector:@selector(addMoreColorLevel:)]) 
//		{
//			[recieveTarget_ addMoreColorLevel:nameField_.text];
//		}
        if (delegate != nil && [delegate respondsToSelector:@selector(didchooseAddNewColorName:name:)]) {
            [delegate didchooseAddNewColorName:self name:newColorName];
        }
	}
	
	
	
	[self removeFromSuperview];
}

- (void)cancelButtonAction:(UIButton *)_sender
{
	[self removeFromSuperview];
}


@end
