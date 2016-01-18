//
//  YDColorLevelModifyView.m
//  YiDa
//
//  Created by Ni on 12-11-21.
//  Copyright 2012 meson.com. All rights reserved.
//

#import "YDColorLevelModifyView.h"
#import "YDPalettesRecipeView.h"

@interface YDColorLevelModifyView ()

- (void)setUpBackgroundImage;
- (void)setUpInterface;
- (void)buttonAction:(UIButton *)_sender;

@end


@implementation YDColorLevelModifyView

@synthesize containerView = containerView_;

@synthesize colorNameScrollView = colorNameScrollView_;

@synthesize receiveTarget = receiveTarget_;

@synthesize recipeValue = recipeValue_ ;
@synthesize groupId = groupId_;

@synthesize delegate;

//@synthesize caller;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self)
	{
		UIView *a = [[UIView alloc] initWithFrame:self.bounds];
		[a setBackgroundColor:[UIColor blackColor]];
		a.alpha = 0.2;
		[self addSubview:a];
		[a release];
		a = nil;
		
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(295, 199, 460, 288)];
        [view setBackgroundColor:[UIColor clearColor]];
        self.containerView = view;
        [view release];view = nil;
        [self addSubview:containerView_];
        [self setUpBackgroundImage];
		
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame names:(NSMutableArray *)_namesArray
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
		names = _namesArray;
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(295, 199, 460, 288)];
        [view setBackgroundColor:[UIColor clearColor]];
        self.containerView = view;
        [view release];view = nil;
        [self addSubview:containerView_];
        [self setUpBackgroundImage];
//        scrollview 开始时默认设置只有两行色级时的高度
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 85, 430, 175)];
        [containerView_ addSubview:scroll];
        [scroll setBackgroundColor:[UIColor clearColor]];
        self.colorNameScrollView = scroll;
        [scroll release];scroll = nil;
		
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame names:(NSMutableArray *)_namesArray
           delegate:(id<YDColorLevelModifyViewDelegate>)_delegate
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
		names = _namesArray;
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(295, 199, 460, 288)];
        [view setBackgroundColor:[UIColor clearColor]];
        self.containerView = view;
        [view release];view = nil;
        [self addSubview:containerView_];
        [self setUpBackgroundImage];
        //        scrollview 开始时默认设置只有两行色级时的高度
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 85, 430, 175)];
        [containerView_ addSubview:scroll];
        [scroll setBackgroundColor:[UIColor clearColor]];
        self.colorNameScrollView = scroll;
        [scroll release];scroll = nil;
		self.delegate = _delegate;
    }
    return self;
}

- (void)dealloc {
	[containerView_ release];containerView_ = nil;
    [colorNameScrollView_ release];colorNameScrollView_ = nil;
    
    [recipeValue_ release];recipeValue_ = nil;
    [groupId_ release];groupId_ = nil;
    [super dealloc];
}


- (void)didMoveToSuperview
{
	[self setUpInterface];
}

- (void)setUpBackgroundImage
{
	UIImageView *image = [[UIImageView alloc] initWithFrame:containerView_.bounds];
    [image setImage:[UIImage imageNamed:@"BackgroundModify_11.png"]];
    [containerView_ addSubview:image];
    [image release];
	
}

- (void)setUpInterface
{
	NSInteger count = [names count];
	for (int i = 0; i<count; i++)
	{
//		char *name = "A"+1;
//		NSString *name_ = [NSString stringWithCString:name];
		YDColorLevelName *name = (YDColorLevelName *)[names objectAtIndex:i];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setTitle:name.colorLvelName forState:UIControlStateNormal];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        左右间隔是18，上下间隔是30
		[button setFrame:CGRectMake(3+(70+18)*(i%5), 2+(55+30)*(int)floor(i/5), 70, 55)];
//		[button setBackgroundColor:[UIColor blueColor]];
//		[button setba]
//		button.enabled = !name.nameState;
		button.tag = i;
		button.userInteractionEnabled = !name.nameState;
		button.selected = name.nameState;
		[button setBackgroundImage:[UIImage imageNamed:@"BackgroundColorTab_01.png"] forState:UIControlStateNormal];
		[button setBackgroundImage:[UIImage imageNamed:@"BackgroundColorTab_02.png"] forState:UIControlStateSelected];
		[button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
		[colorNameScrollView_ addSubview:button];
		button = nil;
	}
    
    NSInteger height = (55+23)*(int)ceil(count/5.0);
    [colorNameScrollView_ setContentSize:CGSizeMake(430, height)];
	

}

- (void)show:(BOOL)_animated
{
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) 
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	[[[window subviews] objectAtIndex:0] addSubview:self]; 
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	CGRect rect = containerView_.frame;
	if (!CGRectContainsPoint(rect, point))
	{
		[self removeFromSuperview];
	}
}

- (void)buttonAction:(UIButton *)_sender
{
	YDColorLevelName *name = (YDColorLevelName *)[names objectAtIndex:_sender.tag];
	name.nameState = 1;
    
    
    
    NSString *colorName = name.colorLvelName;
    
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
//    [dictionary setObject:colorName forKey:YDLabTabColorNameKey];
//    if (recipeValue_) {
//        [dictionary setObject:recipeValue_ forKey:YDLabTabColorRecipeValueKey];
//    }
//	if (groupId_)
//    {
//        [dictionary setObject:groupId_ forKey:YDLabColorGroupIdKey];
//    }
//    
//    [dictionary setObject:receiveTarget_ forKey:YDBulkTabOriginalRecipeKey];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:YDLabTabColorNameNotification
//                                                        object:nil userInfo:dictionary];
    
    
    
	
    
    
    if (delegate!= nil && [delegate respondsToSelector:@selector(didTabColorName:name:)]) {
        [delegate didTabColorName:self name:colorName];
    }
//    
//    if (receiveTarget_ != nil && [receiveTarget_ respondsToSelector:@selector(updateBackgroundImage:)])
//	{
//		[receiveTarget_ updateBackgroundImage:YDTabCandidateSelectedType];
//	}
    
	[self removeFromSuperview];
}

@end
