//
//  YDLabTabView.m
//  YiDa
//
//  Created by Ni on 12-11-19.
//  Copyright 2012 meson.com. All rights reserved.
//

#import "YDLabTabView.h"
#import "YDPalettesRecipeView.h"
#import "YDLabTabGroupView.h"


@interface YDLabTabView ()
	
- (void)setUpRecipeScrollView;

- (void)setUpRecipeWith:(NSInteger )_recipeCount;
	

@end



@implementation YDLabTabView

@synthesize recipeScrollView = recipeScrollView_;
@synthesize recipeCount = recipeCount_;

@synthesize recipeViewType = recipeViewType_;

@synthesize recipeInfo = recipeInfo_;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame recipeCount:(NSInteger )_recipeCount
{
	self = [super initWithFrame:frame];
	if (self)
	{
		recipeCount_ = _recipeCount;
		[self setUpRecipeScrollView];
		[self setBackgroundColor:kUpColor];
		
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame 
		recipeCount:(NSInteger )_recipeCount 
		 recipeType:(YDPalettesRecipeType)_recipeType
{
	self = [super initWithFrame:frame];
	if (self)
	{
		recipeCount_ = _recipeCount;
		self.recipeViewType = _recipeType;
		[self setUpRecipeScrollView];
		[self setBackgroundColor:kUpColor];
		
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame recipeCount:(NSInteger )_recipeCount 
		 recipeType:(YDPalettesRecipeType)_recipeType 
			  names:(NSMutableArray *)_names
{
	self = [super initWithFrame:frame];
	if (self)
	{
		recipeCount_ = _recipeCount;
		colorLevelName = _names;
		self.recipeViewType = _recipeType;
		[self setUpRecipeScrollView];
		[self setBackgroundColor:kUpColor];
		
		
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame recipeCount:(NSInteger )_recipeCount
		 recipeType:(YDPalettesRecipeType)_recipeType
              names:(NSMutableArray *)_names
         recipeInfo:(ChemicalInfo *)_recipeInfo
{
    self = [super initWithFrame:frame];
	if (self)
	{
        self.recipeInfo = _recipeInfo;
		recipeCount_ = _recipeCount;
		colorLevelName = _names;
		self.recipeViewType = _recipeType;
		[self setUpRecipeScrollView];
		[self setBackgroundColor:kUpColor];
		
		
	}
	return self;
}








- (void)dealloc {
    
    [recipeScrollView_ removeFromSuperview];
    [recipeScrollView_ release];recipeScrollView_ = nil;
    [recipeInfo_ release];recipeInfo_ = nil;
    [super dealloc];
}

- (void)didMoveToSuperview
{
    if (!self.superview) return;
    
	[self setUpRecipeWith:recipeCount_];
	
//	YDColorGroupView *group = [[YDColorGroupView alloc] initWithFrame:CGRectMake(0,4 , 245, 230) 
//																title:[NSString stringWithFormat:@"组合%d",5]];
//	[self addSubview:group];
//	[group release];
    
    YDLabTabGroupView *group = [[YDLabTabGroupView alloc] initWithFrame:CGRectMake(0, 4, 245, 230) with:recipeInfo_.group_Head];
    [self addSubview:group];
    [group release];
    group = nil;
}


- (void)setUpRecipeScrollView
{
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(270, 4, 740, 230)];
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	[scrollView setBackgroundColor:[UIColor clearColor]];
	self.recipeScrollView = scrollView;
	[scrollView release];scrollView = nil;
	
	
	[self addSubview:recipeScrollView_];
}


- (void)setUpRecipeWith:(NSInteger )_recipeCount
{
	//用于限制scrollview中只有两行的
	NSInteger count = 5;
	if (_recipeCount>10) {
		count = (int)ceil(_recipeCount/2.0);
	}
	
    NSInteger i = 0;
    for (; i<_recipeCount; i++) 
    {
//        YDPalettesRecipeView *group = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((136+13)*(i%count), (109+5)*(int)floor(i/count)+6, 136, 109) 
//																	   recipeType:recipeViewType_ names:colorLevelName];
//        
//        [recipeScrollView_ addSubview:group];
//        [group release];
        
        YDPalettesRecipeView *recipeView = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((136+13)*(i%count), (109+5)*(int)floor(i/count)+6, 136, 109) recipeType:recipeViewType_ names:colorLevelName];
        if ([recipeInfo_.groupInfoAry count])
        {
            CI_Atrb_GroupInfo *groupInfo = (CI_Atrb_GroupInfo *)[recipeInfo_.groupInfoAry objectAtIndex:0];
            recipeView.groupId = groupInfo.GroupID;
//            NSLog(@"色级组合的id  %@",groupInfo.GroupID);
        }
        [recipeView setRecipeValueWith:(Group_List *)[recipeInfo_.grouplistAry objectAtIndex:i]];
        [recipeScrollView_ addSubview:recipeView];
        [recipeView release];recipeView = nil;
        
            
            
    }
    if (_recipeCount >5) {
        NSInteger wight = (136+16)*count;
        [recipeScrollView_ setContentSize:CGSizeMake(wight, 230)];
    }
   
	
	
}


@end
