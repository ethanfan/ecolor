//
//  YDTabPopoverView.m
//  YiDa
//
//  Created by Ni on 12-11-22.
//  Copyright 2012 meson.com. All rights reserved.
//

#import "YDTabPopoverView.h"
#import "YDPostNotificationName.h"


@interface YDTabPopoverView ()

- (void)setUpBackgroundImage:(YDTabPopoverType )_type;
- (void)setUpInterface:(YDTabPopoverType )_type;
- (void)normalSimple:(UIButton *)_sender;
- (void)remodifySimple:(UIButton *)_sender;
- (void)cancelTab:(UIButton *)_sender;

@end

@implementation YDTabPopoverView


@synthesize popoverType= popoverType_;


@synthesize delegate;

@synthesize transferTarget = transferTarget_;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
			   type:(YDTabPopoverType )_type 
		   delegate:(id<YDTabPopoverViewDelegate>)_delegate
{
	self = [super initWithFrame:frame];
    if (self) {
		popoverType_ = _type;
		self.delegate =_delegate;
		[self setUpBackgroundImage:_type];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}



- (void)didMoveToSuperview
{
	[self setUpInterface:popoverType_];
}

- (void)setUpBackgroundImage:(YDTabPopoverType )_type
{
	UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
	if (_type == YDTabPopoverTwoType)
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




- (void)setUpInterface:(YDTabPopoverType )_type
{
	NSInteger count = 1;
	if (_type == YDTabPopoverTwoType)
	{
		count = 2;
		for (int i =0; i<count; i++)
		{
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			[button setBackgroundColor:[UIColor clearColor]];
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
			[button setBackgroundImage:[UIImage imageNamed:@"ButtonPopoverSelected.png"] forState:UIControlStateHighlighted];
			[button setFrame:CGRectMake(2, 20 +(36 +10)*i, 160, 36)];
			if (i== 0)
			{
				[button setTitle:@"回修小样OK方" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(remodifySimple:) forControlEvents:UIControlEventTouchUpInside];
			}
			else if (i== 1)
			{
				[button setTitle:@"正常小样OK方" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(normalSimple:) forControlEvents:UIControlEventTouchUpInside];
			}
			[self addSubview:button];
		}
	}
	else if (_type == YDTabPopoverSingleType)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setBackgroundColor:[UIColor clearColor]];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
		[button setBackgroundImage:[UIImage imageNamed:@"ButtonPopoverSelected.png"] forState:UIControlStateHighlighted];
		[button setFrame:CGRectMake(2, 20 , 160, 36)];
		[button addTarget:self action:@selector(cancelTab:) forControlEvents:UIControlEventTouchUpInside];
		[button setTitle:@"取消标记" forState:UIControlStateNormal];
		[self addSubview:button];
	}
	
}
	

//正常小样ok方
- (void)normalSimple:(UIButton *)_sender
{
	if (delegate != nil && [delegate respondsToSelector:@selector(tabPopover:normalSimple:)])
	{
		[delegate tabPopover:self normalSimple:YES];
	}
}
//回修小样ok方
- (void)remodifySimple:(UIButton *)_sender
{
	if (delegate != nil && [delegate respondsToSelector:@selector(tabPopover:remodifySimple:)])
	{
		[delegate tabPopover:self remodifySimple:YES];
	}
}

//取消标记
- (void)cancelTab:(UIButton *)_sender
{
	if (delegate != nil && [delegate respondsToSelector:@selector(tabPopover:cancelTab:)])
	{
		[delegate tabPopover:self cancelTab:YES];
	}
}

@end
