//
//  YDLabColorView.m
//  YiDa
//
//  Created by Ni on 12-11-19.
//  Copyright 2012 meson.com. All rights reserved.
//

#import "YDLabColorView.h"
#import "YDPalettesRecipeView.h"
#import "YDColorLevelName.h"

#define kLastObjectTag   10000

@interface YDLabColorView ()

- (void)setUpScrollViewBackground;
- (void)setUpScrollViewBackground:(NSMutableArray *)_names;

- (void)addMoreColorLevel:(NSString *)_name;

@end



@implementation YDLabColorView

@synthesize backgroundScrollView = backgroundScrollView_;



- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self setUpScrollViewBackground];
		colorsArray = [[NSMutableArray arrayWithCapacity:0] retain];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame levelCount:(NSInteger )_count
{
	self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		colorLevelCount = _count;
		[self setUpScrollViewBackground];
		
		colorsArray = [[NSMutableArray arrayWithCapacity:_count] retain];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame levelCount:(NSInteger )_count levelName:(NSMutableArray *)_names
{
	self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		colorLevelCount = _count;
		colorNamesArray = _names;
		[self setUpScrollViewBackground:colorNamesArray];
		
		colorsArray = [[NSMutableArray arrayWithCapacity:_count] retain];
		
    }
    return self;
}


- (void)dealloc {
	[colorsArray removeAllObjects];
	[colorsArray release];colorsArray = nil;
	[backgroundScrollView_ release];backgroundScrollView_ = nil;
    [super dealloc];
}

- (void)setUpScrollViewBackground
{
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1010, 120)];
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	[scrollView setBackgroundColor:[UIColor clearColor]];
	self.backgroundScrollView = scrollView;
	[scrollView release];scrollView = nil;
	
	
	[self addSubview:backgroundScrollView_];
	
	
	for (int i = 0; i<colorLevelCount; i++)
	{
		NSInteger type = YDTabColorLevelType;
		if (i== colorLevelCount -1) {
			type = YDTabColorLevelMoreType;
		}
		YDPalettesRecipeView *r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((110 +15)*i, 0, 110, 116) recipeType:type];
		[r setColorLevelName:[NSString stringWithFormat:@"%d",i+1]];
		if (i== colorLevelCount -1) {
			r.tag =kLastObjectTag;
		}
		[backgroundScrollView_ addSubview:r];
		[colorsArray addObject:r];
		[r release];r= nil;
	}
	[backgroundScrollView_ setContentSize:CGSizeMake((110+15)*colorLevelCount, 120)];
}

- (void)setUpScrollViewBackground:(NSMutableArray *)_names
{
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1010, 120)];
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	[scrollView setBackgroundColor:[UIColor clearColor]];
	self.backgroundScrollView = scrollView;
	[scrollView release];scrollView = nil;
	
	
	[self addSubview:backgroundScrollView_];
	
	
	for (int i = 0; i<colorLevelCount; i++)
	{
		NSInteger type = YDTabColorLevelType;
		if (i== colorLevelCount -1) {
			type = YDTabColorLevelMoreType;
			YDPalettesRecipeView *r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((110 +15)*i, 0, 110, 116) recipeType:type];
			if (i== colorLevelCount -1) {
				r.tag =kLastObjectTag;
			}
			[backgroundScrollView_ addSubview:r];
			[colorsArray addObject:r];
			[r release];r= nil;
			break;
		}
		
		YDColorLevelName *name = (YDColorLevelName *)[_names objectAtIndex:i];

		YDPalettesRecipeView *r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((110 +15)*i, 0, 110, 116) 
																   recipeType:type 
																   colorNames:colorNamesArray];
		[r setColorLevelName:name.colorLvelName];
		if (i== colorLevelCount -1) {
			r.tag =kLastObjectTag;
		}
		[backgroundScrollView_ addSubview:r];
		[colorsArray addObject:r];
		[r release];r= nil;
	}
	[backgroundScrollView_ setContentSize:CGSizeMake((110+15)*colorLevelCount, 120)];
}

//一次只能加一张
- (void)addMoreColorLevel:(NSString *)_name
{
	YDPalettesRecipeView *l = (YDPalettesRecipeView*)[backgroundScrollView_ viewWithTag:kLastObjectTag];
	if (l) {
//		[l setFrame:CGRectMake((110 +15)*(colorLevelCount +1), 0, 110, 116)];
		[l setFrame:CGRectMake((110 +15)*colorLevelCount , 0, 110, 116)];
	}
	
	YDPalettesRecipeView *r = [[YDPalettesRecipeView alloc] initWithFrame:CGRectMake((110 +15)*(colorLevelCount -1), 0, 110, 116) recipeType:YDTabColorLevelType];
	[r setColorLevelName:_name];
	[backgroundScrollView_ addSubview:r];
	colorLevelCount = colorLevelCount+1;
	[colorsArray addObject:r];
	[r release];r= nil;
	
	if (colorNamesArray)
	{
		[colorNamesArray addObject:[YDColorLevelName initWith:_name state:0]];
	}
	[backgroundScrollView_ setContentSize:CGSizeMake((110+15)*colorLevelCount, 120)];
}

@end
