//
//  YDColorPopoverView.m
//  YiDa
//
//  Created by Ni on 12-11-21.
//  Copyright 2012 meson.com. All rights reserved.
//

#import "YDColorPopoverView.h"
#import "YDColorLevelAddModifyView.h"

@interface YDColorPopoverView ()
	
- (void)setUpBackgroundImage:(YDColorPopoverType )_type;
- (void)setUpInterface:(YDColorPopoverType )_type;
//更改色级名字
- (void)modifyColorLevelName:(UIButton *)_sender;
//取消标记
- (void)cancelTab:(UIButton *)_sender;
//更改色级
- (void)modifyColorLevel:(UIButton *)_sender;



@end


@implementation YDColorPopoverView

@synthesize popoverType= popoverType_;

@synthesize buttonTitle = buttonTitle_;

@synthesize delegate;

@synthesize transferTarget = transferTarget_;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		popoverType_ = YDColorPopoverTypeNone;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(YDColorPopoverType )_type
{
	self = [super initWithFrame:frame];
    if (self) {
		popoverType_ = _type;
		[self setUpBackgroundImage:_type];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(YDColorPopoverType )_type title:(NSString *)_pTitle
{
	self = [super initWithFrame:frame];
    if (self) {
		popoverType_ = _type;
		self.buttonTitle = _pTitle;
		[self setUpBackgroundImage:_type];
    }
    return self;
}

- (void)setUpBackgroundImage:(YDColorPopoverType )_type
{
	UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
	if (_type == YDColorPopoverMoreType)
	{
		[bg setImage:[UIImage imageNamed:@"BackgroundPopover_01.png"]];
	}
	else if (_type == YDColorPopoverSingleType)
	{
		[bg setImage:[UIImage imageNamed:@"BackgroundPopover_02.png"]];
	}
	[self addSubview:bg];
	[bg release];
}

- (void)didMoveToSuperview
{
	[self setUpInterface:popoverType_];
}

- (void)setUpInterface:(YDColorPopoverType )_type
{
	NSInteger count = 1;
	if (_type == YDColorPopoverMoreType)
	{
		count = 3;
	}
//	else if (_type == YDColorPopoverSingleType)
//	{
//		
//	}
		for (int i =0; i<count; i++)
		{
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			[button setBackgroundColor:[UIColor clearColor]];
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
			[button setBackgroundImage:[UIImage imageNamed:@"ButtonPopoverSelected.png"] forState:UIControlStateHighlighted];
			[button setFrame:CGRectMake(2, 10 +(36 +4)*i, 160, 36)];
			if (i== 0)
			{
				[button setTitle:@"更改色级名字" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(modifyColorLevelName:) forControlEvents:UIControlEventTouchUpInside];
			}
			else if (i== 1)
			{
				[button setTitle:@"取消标记" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(cancelTab:) forControlEvents:UIControlEventTouchUpInside];

			}
			else if (i== 2)
			{
				[button setTitle:@"更改色级" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(modifyColorLevel:) forControlEvents:UIControlEventTouchUpInside];

			}
			[self addSubview:button];
		}

}
//更改色级名字
- (void)modifyColorLevelName:(UIButton *)_sender
{
//	[self performSelector:@selector(popover) withObject:nil afterDelay:1.0f];
    if (delegate != nil && [delegate respondsToSelector:@selector(tabColorPopover:modifyColorName:)])
    {
        [delegate tabColorPopover:self modifyColorName:YES];
    }

}
//取消标记
- (void)cancelTab:(UIButton *)_sender
{
//	NSLog(@"取消标记");
	if (delegate != nil && [delegate respondsToSelector:@selector(tabColorPopover:cancelTab:)])
	{
        [delegate tabColorPopover:self cancelTab:YES];
	}
}
//更改色级
- (void)modifyColorLevel:(UIButton *)_sender
{
//	NSLog(@"更改色级");
	if (delegate != nil && [delegate respondsToSelector:@selector(tabColorPopover:changeColorName:)])
	{
        [delegate tabColorPopover:self changeColorName:YES];
	}

}



- (void)popover;
{
//	NSLog(@"更改色级名字");
	YDColorLevelAddModifyView *colorLevelMore = [[YDColorLevelAddModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) type:YDColorLevelModified];
	colorLevelMore.recieveTarget = transferTarget_;
	[colorLevelMore show:YES];
	[colorLevelMore release];colorLevelMore = nil;
}

- (void)dealloc {
	[buttonTitle_ release];
    [super dealloc];
}


@end
