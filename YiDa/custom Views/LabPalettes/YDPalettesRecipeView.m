//
//  YDPalettesRecipeView.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDPalettesRecipeView.h"
#import "YDNewRecipeModifyView.h"
#import "YDOldRecipeModifyView.h"
#import "PopoverView.h"
#import "YDColorPopoverView.h"
#import "YDColorLevelModifyView.h"
#import "YDColorLevelAddModifyView.h"
#import "YDPostNotificationName.h"
#import "YDAddictions.h"



@interface YDPalettesRecipeView ()




- (void)setUpNewRecipeBackground;

- (void)setUpCandicateRecipeBackground;
- (void)setUpRecipeSelectedBackground;
- (void)setUpColorLevelBackground;
- (void)setUpColorLevelMoreBackground;

- (void)touchAction:(UIButton *)_sender;

- (void)updateModifyTabWith:(BOOL)_remodifyed;

- (void)queryDataWith:(YDUserType)_userType;

//设置调方配方值
- (void)setContentWith:(Group_List *)_recipeValue;

//设置 标记 选中的配方值 
- (void)setTabContentWith:(Group_List *)_recipeValue;



- (void)queryLabAuxiliariesWith:(NSString *)_chemicalIds withUsage:(NSString *)_usages;

- (void)queryLabAuxiliariesWith:(NSString *)_chemicalIds withUsage:(NSString *)_usages block:(void (^)(LabAuxiliariesInfo *))block;



- (void)longPress:(UILongPressGestureRecognizer *)_press;

@end


@implementation YDPalettesRecipeView

@synthesize recipeType = recipeType_;
@synthesize touchButton = touchButton_;
@synthesize recipeTitle = recipeTitle_;
@synthesize yellowColorLabel = yellowColorLabel_;
@synthesize redColorLabel = redColorLabel_;
@synthesize blueColorLabel = blueColorLabel_;

@synthesize moreLabel = moreLabel_;

@synthesize colorLevelLabel  = colorLevelLabel_;
@synthesize groupNameLabel = groupNameLabel_;

@synthesize selectedButton = selectedButton_;
@synthesize deleteButton = deleteButton_;
@synthesize reModifyButton = reModifyButton_;

@synthesize selected;
@synthesize remodified;

@synthesize backgroundImageView = backgroundImageView_;

@synthesize colorLevelNameString = colorLevelNameString_;          //色级名称
@synthesize recipeNameString = recipeNameString_;          //配方名字
@synthesize groupNameString = groupNameString_;        //组合名字
@synthesize yellowString = yellowString_;
@synthesize redString = redString_;
@synthesize blueString = blueString_;	

@synthesize userType = userType_;

@synthesize delegate ;

@synthesize recipeVale = recipeVale_;
@synthesize additives = additives_;

@synthesize tabName = tabName_;

@synthesize originalRecipe ;

@synthesize oldAndNewUsages;
@synthesize chemicalIds ,oldUsages;


//@synthesize newUsages ;
@synthesize usagesNew;

@synthesize groupId;

@synthesize state;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
		 recipeType:(NSInteger )_recipeType userType:(YDUserType)_userType
{
	self = [super initWithFrame:frame];
    if (self) 
    {
		self.userType = _userType;
        self.recipeType = _recipeType;
        [self setUpBackgroundWith:recipeType_];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame recipeType:(NSInteger )_recipeType
{
    self = [super initWithFrame:frame];
    if (self) 
    {
		self.userType = YDUserTypeNone;
        self.recipeType = _recipeType;
        [self setUpBackgroundWith:recipeType_];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
		 recipeType:(NSInteger )_recipeType 
			  names:(NSMutableArray *)_colorLevelNames
{
	self = [super initWithFrame:frame];
    if (self) 
    {
		self.userType = YDUserTypeNone;
        self.recipeType = _recipeType;
		colorLevelName = _colorLevelNames;
        [self setUpBackgroundWith:recipeType_];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
		 recipeType:(NSInteger )_recipeType 
		 colorNames:(NSMutableArray *)_colorLevelNames
{
	self = [super initWithFrame:frame];
    if (self) 
    {
		self.userType = YDUserTypeNone;
        self.recipeType = _recipeType;
		colorLevelName = _colorLevelNames;
        [self setUpBackgroundWith:recipeType_];
    }
    return self;
}

- (void)dealloc
{
    [touchButton_ release];touchButton_ = nil;
    [recipeTitle_ release];recipeTitle_ = nil;
    [yellowColorLabel_ release];yellowColorLabel_ = nil;
    [redColorLabel_ release];redColorLabel_ = nil;
    [blueColorLabel_ release];blueColorLabel_ = nil;
    
    [moreLabel_ release];moreLabel_ = nil;
    
    [colorLevelLabel_ release];colorLevelLabel_ = nil;
    
    [groupNameLabel_ release];groupNameLabel_  = nil;
    
    [selectedButton_ release];selectedButton_ = nil;
    [deleteButton_ release];deleteButton_ = nil;
	[reModifyButton_ release];reModifyButton_= nil;
	
	[backgroundImageView_ removeFromSuperview];
	[backgroundImageView_ release];backgroundImageView_ = nil;

	[colorLevelNameString_ release];colorLevelNameString_ = nil;
	[recipeNameString_ release];recipeNameString_ = nil;
	[groupNameString_ release];groupNameString_ = nil;
	[yellowString_ release];yellowString_ = nil;
	[redString_ release];redString_ = nil;
	[blueString_ release];blueString_ = nil;
	
    [recipeVale_ release];recipeVale_ = nil;
    [additives_ release];additives_ = nil;
    [tabName_ release];tabName_ = nil;
    
    originalRecipe = nil;
    
    self.chemicalIds = nil;
    self.oldUsages = nil;
    self.usagesNew = nil;
    self.oldAndNewUsages = nil;
    
    [super dealloc];
}

-(BOOL)isSelected
{
    return selected;
}
- (void)setselectedWith:(BOOL)_selected
{
    selected = _selected;
//    [self upDateSelctedButtonState:selected];
    selectedButton_.selected = _selected;
}

-(BOOL)isRemodified
{
	return remodified;
}
- (void)setremodifiedWith:(BOOL)_modified
{
	remodified = _modified;
	[self updateModifyTabWith:remodified];
}

- (void)setRecipeValueWith:(Group_List *)_recipeValue
{
    self.recipeVale = _recipeValue;
    self.oldUsages = [self generateOldUsage:recipeVale_];
}

- (void)setColorLevelName:(NSString *)_name
{
	self.colorLevelNameString = _name;
	colorLevelLabel_.text = colorLevelNameString_;
}


- (void)didMoveToSuperview
{
    if (!self.superview) return;
    
    if (touchButton_ == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = recipeType_;
        [button setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y+30, self.bounds.size.width, self.bounds.size.height-30)];
        [button addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
        self.touchButton = button;
        [self addSubview:touchButton_];
        button = nil;
    }
	
	UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
	[self addGestureRecognizer:press];
	[press release];
    
    
    
//    newrecipe的时候 调方
    if (recipeType_  == YDPalettesRecipeTypeNone)
    {
        [self setupNoneRecipeBackground];
    }
//    调方
    else if (recipeType_ == YDPalettesOldRecipeType || recipeType_ == YDPalettesNewRecipeType)
    {
        [self setContentWith:recipeVale_];
    }
    else if (recipeType_ == YDBulkTabRecipeSelectedType)
    {
        [self setTabContentWith:recipeVale_];
    }
    else
    {
        [self setUpRecipeValueInTab:recipeVale_];
    }
//    由服务器那边返回来的数据是没有新的用量的，因为新的用量是用户输入的，
//    根据这个去判定需不需要去查询计算助剂，因为如果是用户在新增或者修改原有配方生成新的配方的时候，这个值是存在的
    if (!self.usagesNew)
    {
        if (self.chemicalIds && self.oldUsages) {
//            [self queryLabAuxiliariesWith:self.chemicalIds withUsage:self.oldUsages];
            [self queryDataWith:userType_];

        }
    }
    
    self.selectedButton.selected = selected;
}

- (void)queryDataWith:(YDUserType)_userType
{
    /*
    if (userType_ == YDUserTypeLab) {
        [self queryLabAuxiliariesWith:self.chemicalIds withUsage:self.oldUsages];
    }
    else if (userType_ == YDUserTypeBulk)
    {
        
    }
     */
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

//设置在标记界面的配方的值
- (void)setUpRecipeValueInTab:(Group_List *)_recipeValue
{
    if (_recipeValue)
    {
//        [self.recipeTitle setText:_recipeValue.titleName];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, 125, 20)];
        [label setTextAlignment:UITextAlignmentLeft];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:16]];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setText:_recipeValue.titleName];
        [self addSubview:label];
        self.recipeTitle = label;
        
        
        if ([_recipeValue.titleName length])
        {
            NSString *f = [_recipeValue.titleName substringToIndex:1];
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
        
        NSMutableArray *values = _recipeValue.valueAry ;
        NSInteger count = [values count];
        NSInteger height = 20;
        if (count == 4 ) {
            height = 15;
        }
        for (int i = 0; i<count; i++)
        {
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 27+(height +5)*i, 100, height)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setFont:[UIFont systemFontOfSize:16]];
            [label setText:[values objectAtIndex:i]];
//            [label setText:@"FDFD"];
            [self addSubview:label];
            
            if (i == 0) self.yellowColorLabel = label;
            if (i == 1)self.redColorLabel = label;
            if (i == 2) self.blueColorLabel = label ;
            if (i == 3) self.moreLabel = label;
            
            
            
//            if (i == 0) [yellowColorLabel_ setText:[values objectAtIndex:i]];
//            if (i == 1) [redColorLabel_ setText:[values objectAtIndex:i]];
//            if (i == 2) [blueColorLabel_ setText:[values objectAtIndex:i]];
            
            [label release];label = nil;
        }
    }
}

#pragma mark -------------
#pragma mark 设置 标记 配方值
- (void)setTabContentWith:(Group_List *)_recipeValue
{
    
    if (_recipeValue)
    {
        //        [self.recipeTitle setText:_recipeValue.titleName];
//        配方标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4, 35, 130, 20)];
        [label setTextAlignment:UITextAlignmentLeft];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:16]];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setMinimumFontSize:10.0];
        [label setText:_recipeValue.titleName];
        
        if ([_recipeValue.titleName length]) {
            NSString *f = [_recipeValue.titleName substringToIndex:1];
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

        [self addSubview:label];
        self.recipeTitle = label;
        [label release];label = nil;
//        色级名称
        label = [[UILabel alloc] initWithFrame:CGRectMake(2, 4, 30, 20)];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setNumberOfLines:0];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setMinimumFontSize:10];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:16]];
//        [label setText:@"A"];
        [self addSubview:label];
        self.colorLevelLabel = label;
        [label release];label = nil;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(40, 4, 65, 20)];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:label];
        self.groupNameLabel = label;
        [label release];label = nil;
        
        NSMutableArray *values = _recipeValue.valueAry ;
        NSInteger count = [values count];
        NSInteger height = 20;
        if (count == 4 ) {
            height = 15;
        }
        for (int i = 0; i<count; i++)
        {
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4, 60+(height +5)*i, 100, height)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setFont:[UIFont systemFontOfSize:16]];
            [label setText:[values objectAtIndex:i]];
//            [label setText:@"FDFD"];
            [self addSubview:label];
            
            if (i == 0) self.yellowColorLabel = label;
            if (i == 1)self.redColorLabel = label;
            if (i == 2) self.blueColorLabel = label ;
            if (i == 3) self.moreLabel = label;
            
            
            
            //            if (i == 0) [yellowColorLabel_ setText:[values objectAtIndex:i]];
            //            if (i == 1) [redColorLabel_ setText:[values objectAtIndex:i]];
            //            if (i == 2) [blueColorLabel_ setText:[values objectAtIndex:i]];
            
            [label release];label = nil;
        }
    }

    

}

#pragma mark ----------------
#pragma mark 设置 调方 配方值
- (void)setContentWith:(Group_List *)_recipeValue
{
//    if (_recipeValue)
//    {
//        [self.recipeTitle setText:_recipeValue.titleName];
//        NSMutableArray *values = _recipeValue.valueAry ;
//        NSInteger count = [values count];
//        for (int i = 0; i<count; i++)
//        {
//            if (i == 0) [yellowColorLabel_ setText:[values objectAtIndex:i]];
//            if (i == 1) [redColorLabel_ setText:[values objectAtIndex:i]];
//            if (i == 2) [blueColorLabel_ setText:[values objectAtIndex:i]];
//        }
//    }

    if (_recipeValue)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(38, 5, 130, 30)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:16]];
        [label setText:_recipeValue.titleName];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setMinimumFontSize:10.0];
        
        if ([_recipeValue.titleName length]) {
            NSString *f = [_recipeValue.titleName substringToIndex:1];
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

        
        [self addSubview:label];
        [label release];label = nil;
        
        NSMutableArray *values = _recipeValue.valueAry ;
//        NSLog(@"YDPalettesRecipeView  values  -----%@",values);
        NSInteger count = [values count];
        for (int i = 0; i<count; i++)
        {
            //            if (i == 0) [yellowColorLabel_ setText:[values objectAtIndex:i]];
            //            if (i == 1) [redColorLabel_ setText:[values objectAtIndex:i]];
            //            if (i == 2) [blueColorLabel_ setText:[values objectAtIndex:i]];
            //            (15, 62+(35 +20)*i, 147, 35)
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 50+(30 +15)*i, 147, 30)];
            [label setBackgroundColor:kInputFieldColor];
            [label setText:[values objectAtIndex:i]];
            [label setTextAlignment:UITextAlignmentCenter];
            
            [self addSubview:label];
            //    self.yellowColorLabel = label;
            [label release];label = nil;
            
        }
    }


}

#pragma mark ==========
#pragma mark 增加回修标记
- (void)updateModifyTabWith:(BOOL)_remodifyed
{
	if (_remodifyed)
	{
		if (reModifyButton_ ==  nil) 
		{
			CGRect rect = CGRectMake(107, 175, 59, 31);
			if (recipeType_ ==YDTabCandidateSelectedType || recipeType_ == YDTabCandidateType||recipeType_ == YDTabCandidateLongPressType ) 
			{
				rect = CGRectMake(100, 80, 30, 20);
			}
			else if(recipeType_ == YDBulkTabRecipeSelectedType)
			{
				rect = CGRectMake(77, 120, 30, 20);
//				4, 60+(20 +5)*2, 100, 20
			}

			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			[button setBackgroundImage:[UIImage imageNamed:@"BackgroundRemodify.png"] forState:UIControlStateNormal];
			[button setFrame:rect];

			self.reModifyButton = button;
			[self addSubview:reModifyButton_];
		}
	}
	else {
		if (reModifyButton_)
		{
			[reModifyButton_ removeFromSuperview];
			[reModifyButton_ release];
			reModifyButton_ = nil;
		}
	}

}


#pragma mark ------------ 选中触发的事件
#pragma mark -------------- touchAction
- (void)touchAction:(UIButton *)_sender
{
//    NSInteger actionType = _sender.tag;
//    switch (actionType)
	switch (recipeType_)
    {
        case YDPalettesRecipeTypeNone:
        {
			//新建配方
            YDNewRecipeModifyView *newRecipe = [[YDNewRecipeModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) userType:userType_];
            newRecipe.recipeValues = recipeVale_;
            newRecipe.chemicalIds = self.chemicalIds;
            newRecipe.addictives = additives_;
            [newRecipe show:YES];
            [newRecipe release];
        }
            break;
        case YDPalettesOldRecipeType:
        {
			//修改历史配方
            YDOldRecipeModifyView *oldRecipe = [[YDOldRecipeModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) userType:userType_];
            oldRecipe.recipeValue = recipeVale_;
            oldRecipe.addictives = additives_;
            oldRecipe.chemicalIds = self.chemicalIds;
            [oldRecipe show:YES];
            [oldRecipe release];oldRecipe = nil;
        }
            break;
        case YDPalettesNewRecipeType:
        {
//            YDOldRecipeModifyView *oldRecipe = [[YDOldRecipeModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) userType:userType_];
//            oldRecipe.recipeValue = recipeVale_;
//            oldRecipe.addictives = additives_;
//            oldRecipe.chemicalIds = self.chemicalIds;
//            [oldRecipe show:YES];
//            [oldRecipe release];oldRecipe = nil;
            YDNewRecipeModifyView *newRecipe = [[YDNewRecipeModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) userType:userType_];
            newRecipe.recipeValues = recipeVale_;
            newRecipe.chemicalIds = self.chemicalIds;
            newRecipe.addictives = additives_;
            [newRecipe show:YES];
            [newRecipe release];

        }
			break;
        case YDTabCandidateType:
        {
			//标记为色级 改为长按
//			YDColorLevelModifyView *colorLevelSelect = [[YDColorLevelModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) names:colorLevelName];
//			colorLevelSelect.receiveTarget = self;
//			[colorLevelSelect show:YES];
//			[colorLevelSelect release];colorLevelSelect = nil;
        }
            break;
        case YDTabRecipeSelectedTyep:
        {

        }
            break;
        case YDTabColorLevelType:
        {

        }
            break;
        case YDTabColorLevelMoreType:
        {
			//新增色级
			YDColorLevelAddModifyView *colorLevelMore = [[YDColorLevelAddModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) type:YDColorLevelAddType delegate:self];
			colorLevelMore.recieveTarget = self.superview.superview;
			[colorLevelMore show:YES];
			[colorLevelMore release];colorLevelMore = nil;
        }
            break;
        default:
            break;
    }
}

#pragma mark ---------
#pragma mark 设置背景图片

- (void)setUpDeepBackgroundWith:(NSInteger)_recipeType
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
    [bg setImage:[self backgroundImageWith:_recipeType]];
    [self addSubview:bg];
    self.backgroundImageView = bg;
    [bg release];
}

- (void)setUpBackgroundWith:(NSInteger)_recipeType
{
    NSInteger type = _recipeType;
    switch (type)
    {
        case YDPalettesRecipeTypeNone:
        {
//            [self setBackgroundColor:[UIColor colorWithPatternImage:[self backgroundImageWith:type]]];
            UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
            [bg setImage:[self backgroundImageWith:type]];
            [self addSubview:bg];
			self.backgroundImageView = bg;
            [bg release];
//            [self setupNoneRecipeBackground];
        }
            break;
        case YDPalettesOldRecipeType:
        {
//            [self setBackgroundColor:[UIColor colorWithPatternImage:[self backgroundImageWith:type]]];
            UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
            [bg setImage:[self backgroundImageWith:type]];
            self.backgroundImageView = bg;
			[self addSubview:bg];
            [bg release];
            [self setUpOldRecipeBackground];
        }
            break;
        case YDPalettesNewRecipeType:
        {
//            [self setBackgroundColor:[UIColor colorWithPatternImage:[self backgroundImageWith:type]]];
            UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
            [bg setImage:[self backgroundImageWith:type]];
            [self addSubview:bg];
			self.backgroundImageView = bg;
            [bg release];
            [self setUpNewRecipeBackground];
        }
			break;
        case YDTabCandidateType:
        {
            UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
            [bg setImage:[self backgroundImageWith:type]];
            [self addSubview:bg];
			self.backgroundImageView = bg;
            [bg release];
			[self setUpCandicateRecipeBackground];
        }
            break;
        case YDTabRecipeSelectedTyep:
        {
            UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
            [bg setImage:[self backgroundImageWith:type]];
            [self addSubview:bg];
			self.backgroundImageView = bg;
            [bg release];
            [self setUpRecipeSelectedBackground];
        }
            break;
		case YDBulkTabRecipeSelectedType:
		{
            UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
            [bg setImage:[self backgroundImageWith:type]];
            [self addSubview:bg];
			self.backgroundImageView = bg;
            [bg release];
            [self setUpRecipeSelectedBackground];
        }
			break;

        case YDTabColorLevelType:
        {
            UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
            [bg setImage:[self backgroundImageWith:type]];
            [self addSubview:bg];
			self.backgroundImageView = bg;
            [bg release];
            [self setUpColorLevelBackground];
        }
            break;
        case YDTabColorLevelMoreType:
        {
            UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
            [bg setImage:[self backgroundImageWith:type]];
            [self addSubview:bg];
			self.backgroundImageView = bg;
            [bg release];
            [self setUpColorLevelMoreBackground];
        }
            break;
		case YDTabCandidateLongPressType:
		{
			UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
            [bg setImage:[self backgroundImageWith:type]];
			self.backgroundImageView = bg;
            [self addSubview:bg];
            [bg release];
			[self setUpCandicateRecipeBackground];
		}
			break;

        default:
            break;
    }
}

- (UIImage *)backgroundImageWith:(NSInteger)_recipeType
{
    NSInteger type = _recipeType;
    UIImage *image = nil;
    switch (type)
    {
        case YDPalettesRecipeTypeNone:
            image = [UIImage imageNamed:@"BackgroundGroup_04.png"];
            break;
        case YDPalettesOldRecipeType:
             image = [UIImage imageNamed:@"BackgroundGroup_05.png"];
            break;
        case YDPalettesNewRecipeType:
             image = [UIImage imageNamed:@"BackgroundGroup_05.png"];
            break;
        case YDTabCandidateType:
        {
            image = [UIImage imageNamed:@"BackgroundTabGroup_05.png"];
        }
            break;
        case YDTabRecipeSelectedTyep:
        {
//            image = [UIImage imageNamed:@"BackgroundTabGroup_01.png"];
			image = [UIImage imageNamed:@"BackgroundTabGroup_02.png"];
        }
            break;
		case YDBulkTabRecipeSelectedType:
		{
			image = [UIImage imageNamed:@"BackgroundTabGroup_02.png"];
		}
			break;

        case YDTabColorLevelType:
        {
            image = [UIImage imageNamed:@"BackgroundTabGroup_03.png"];
        }
            break;
        case YDTabColorLevelMoreType:
        {
            image = [UIImage imageNamed:@"BackgroundTabGroup_04.png"];
        }
            break;
		case YDTabCandidateLongPressType:
		{
            image = [UIImage imageNamed:@"BackgroundTabGroup_05.png"];
        }
			break;
		case YDTabCandidateSelectedType:
		{
			image = [UIImage imageNamed:@"BackgroundTabGroup_06.png"];

		}
			break;


        default:
            break;
    }
    return  image;
}

#pragma mark--------
#pragma mark 新建的配方
- (void)setUpNewRecipeBackground
{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(55, 57, 147, 30)];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"12121"];
//    self.yellowColorLabel = label;
//    [label release];label = nil;
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(55, 57+(20 +30)*1, 147, 30)];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"12121"];
//    self.redColorLabel = label;
//    [label release];label = nil;
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(55, 57+(20 +30)*2, 147, 30)];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"12121"];
//    self.blueColorLabel = label;
//    [label release];label = nil;
//    
//    
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(38, 5, 100, 30)];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setText:@"BBBBBB"];
//    self.recipeTitle = label;
//    [label release];label = nil;
	
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(6, 5, 26, 26)];
	[button addTarget:self action:@selector(selectedButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = YES;
    selected     = YES;
	[button setBackgroundImage:[UIImage imageNamed:@"BackgroundSelect.png"] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:@"BackgroundSelected.png"] forState:UIControlStateSelected];
	self.selectedButton = button;
	button = nil;
	
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(140, 5, 26, 26)];
	[button addTarget:self action:@selector(deleteButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = YES;
	[button setBackgroundImage:[UIImage imageNamed:@"BackgroundSelect.png"] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:@"BackgroundDeleteSelected.png"] forState:UIControlStateSelected];
	self.deleteButton = button;
	button = nil;
	
	
	[self addSubview:selectedButton_];
	[self addSubview:deleteButton_];
    
//    [self addSubview:recipeTitle_];
//    [self addSubview:yellowColorLabel_];
//    [self addSubview:redColorLabel_];
//    [self addSubview:blueColorLabel_];
}

#pragma mark ---------------------------
#pragma mark --- 历史配方
- (void)setUpOldRecipeBackground
{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 57, 147, 30)];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setTextAlignment:UITextAlignmentCenter];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"12121"];
//    self.yellowColorLabel = label;
//    [label release];label = nil;
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 57+(20 +30)*1, 147, 30)];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setTextAlignment:UITextAlignmentCenter];
//
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"12121"];
//    self.redColorLabel = label;
//    [label release];label = nil;
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 57+(20 +30)*2, 147, 30)];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setTextAlignment:UITextAlignmentCenter];
//
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"12121"];
//    self.blueColorLabel = label;
//    [label release];label = nil;
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(38, 5, 100, 30)];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"BBBBBB"];
//    self.recipeTitle = label;
//    [label release];label = nil;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(6, 5, 26, 26)];
	[button addTarget:self action:@selector(selectedButtonPress:) forControlEvents:UIControlEventTouchUpInside];
	[button setBackgroundImage:[UIImage imageNamed:@"BackgroundSelect.png"] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:@"BackgroundSelected.png"] forState:UIControlStateSelected];
	self.selectedButton = button;
	button = nil;
    
	[self addSubview:selectedButton_];

//	
//    [self addSubview:recipeTitle_];
//    [self addSubview:yellowColorLabel_];
//    [self addSubview:redColorLabel_];
//    [self addSubview:blueColorLabel_];
}

#pragma mark--------
#pragma mark 空白配方 点击弹出新增s
- (void)setupNoneRecipeBackground
{
//该情况没有配方号设置
    if (recipeVale_)
    {
        NSMutableArray *values = recipeVale_.valueAry ;
//        NSLog(@"YDPalettesRecipeView  values  -----%@",values);
        NSInteger count = [values count];
        for (int i = 0; i<count; i++)
        {
//            if (i == 0) [yellowColorLabel_ setText:[values objectAtIndex:i]];
//            if (i == 1) [redColorLabel_ setText:[values objectAtIndex:i]];
//            if (i == 2) [blueColorLabel_ setText:[values objectAtIndex:i]];
//            (15, 62+(35 +20)*i, 147, 35)
            UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(15, 50+(30 +15)*i, 147, 30)];
            label.borderStyle = UITextBorderStyleLine;
            label.userInteractionEnabled  = NO;
            [label setBackgroundColor:kInputFieldColor];
            [label setText:[values objectAtIndex:i]];
            [label setTextAlignment:UITextAlignmentCenter];
            
            [self addSubview:label];
            //    self.yellowColorLabel = label;
            [label release];label = nil;

        }
    }

//    
//    UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(15, 62, 147, 35)];
//    label.borderStyle = UITextBorderStyleLine;
//    [label setBackgroundColor:kInputFieldColor];
//    
//    [self addSubview:label];
////    self.yellowColorLabel = label;
//    [label release];label = nil;
//    
//    label = [[UITextField alloc] initWithFrame:CGRectMake(15, 62+(35 +20)*1, 147, 35)];
//    label.borderStyle = UITextBorderStyleLine;
//    [label setBackgroundColor:kInputFieldColor];
//    
//    [self addSubview:label];
//    [label release];label = nil;
//    
//    label = [[UITextField alloc] initWithFrame:CGRectMake(15, 62+(35 +20)*2, 147, 35)];
//    label.borderStyle = UITextBorderStyleLine;
//    [label setBackgroundColor:kInputFieldColor];
//    
//    [self addSubview:label];
//    [label release];label = nil;
    
//    [self addSubview:yellowColorLabel_];
//    [self addSubview:redColorLabel_];
//    [self addSubview:blueColorLabel_];
}

#pragma mark ========
#pragma mark 候选配方
- (void)setUpCandicateRecipeBackground
{
//	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 29, 100, 20)];
//    [label setBackgroundColor:[UIColor clearColor]];
//	[label setTextAlignment:UITextAlignmentCenter];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"1.254847"];
//    self.yellowColorLabel = label;
//    [label release];label = nil;
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(18, 29+(20 +5)*1, 100, 20)];
//    [label setBackgroundColor:[UIColor clearColor]];
//	[label setTextAlignment:UITextAlignmentCenter];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"1.254315"];
//    self.redColorLabel = label;
//    [label release];label = nil;
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(18, 29+(20 +5)*2, 100, 20)];
//    [label setBackgroundColor:[UIColor clearColor]];
//	[label setTextAlignment:UITextAlignmentCenter];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"3.584"];
//    self.blueColorLabel = label;
//    [label release];label = nil;
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(18, 4, 100, 20)];
//	[label setTextAlignment:UITextAlignmentCenter];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"R181313"];
//    self.recipeTitle = label;
//    [label release];label = nil;
//    
//    [self addSubview:recipeTitle_];
//    [self addSubview:yellowColorLabel_];
//    [self addSubview:redColorLabel_];
//    [self addSubview:blueColorLabel_];
}

//色级栏选中
#pragma mark ------
#pragma mark 色级栏选中设置
- (void)setUpRecipeSelectedBackground
{
//	[self setBackgroundColor:[UIColor blueColor]];
    
//	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4, 60, 100, 20)];
//    [label setBackgroundColor:[UIColor clearColor]];
//	[label setTextAlignment:UITextAlignmentCenter];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"211"];
//    self.yellowColorLabel = label;
//    [label release];label = nil;
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(4, 60+(20 +5)*1, 100, 20)];
//    [label setBackgroundColor:[UIColor clearColor]];
//	[label setTextAlignment:UITextAlignmentCenter];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"211"];
//    self.redColorLabel = label;
//    [label release];label = nil;
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(4, 60+(20 +5)*2, 100, 20)];
//    [label setBackgroundColor:[UIColor clearColor]];
//	[label setTextAlignment:UITextAlignmentCenter];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"211"];
//    self.blueColorLabel = label;
//    [label release];label = nil;
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(4, 35, 100, 20)];
//	[label setTextAlignment:UITextAlignmentCenter];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"Recipe"];
//    self.recipeTitle = label;
//    [label release];label = nil;
//    
//	label = [[UILabel alloc] initWithFrame:CGRectMake(2, 4, 30, 20)];
//	[label setTextAlignment:UITextAlignmentCenter];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"A"];
//    self.colorLevelLabel = label;
//    [label release];label = nil;
//	
//	label = [[UILabel alloc] initWithFrame:CGRectMake(40, 4, 65, 20)];
//	[label setTextAlignment:UITextAlignmentCenter];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setText:@"Group"];
//    self.groupNameLabel = label;
//    [label release];label = nil;
//	
//    [self addSubview:recipeTitle_];
//    [self addSubview:yellowColorLabel_];
//    [self addSubview:redColorLabel_];
//    [self addSubview:blueColorLabel_];
//	[self addSubview:colorLevelLabel_];
//	[self addSubview:groupNameLabel_];
	
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 62, 147, 35)];
//    [label setBackgroundColor:[UIColor blueColor]];
//    self.yellowColorLabel = label;
//    [label release];label = nil;
//	[]
}

#pragma mark ------
#pragma mare 色级
- (void)setUpColorLevelBackground
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 100, 50)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor grayColor]];
    [label setMinimumFontSize:10];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setNumberOfLines:0];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:40]];
    [label setText:@"C"];
    self.colorLevelLabel = label;
    [label release];label = nil;
    
    [self addSubview:colorLevelLabel_];
}

#pragma mark ------------
#pragma mark 色级增加
- (void)setUpColorLevelMoreBackground
{
    
}

#pragma mark ---------
#pragma mark 长按响应事件
- (void)longPress:(UILongPressGestureRecognizer *)_press
{
//	NSLog(@"prrrrrrrrrr");
//	CGPoint point = CGPointMake(0, 0);
	switch (recipeType_)
    {
        case YDTabCandidateType:
        {
			//标记为色级-------lab tab界面
			if (_press.state == UIGestureRecognizerStateBegan)
			{
				YDColorLevelModifyView *colorLevelSelect = [[YDColorLevelModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) names:colorLevelName delegate:self];
				colorLevelSelect.receiveTarget = self;
                colorLevelSelect.groupId = self.groupId;
                colorLevelSelect.recipeValue = self.recipeVale;
				[colorLevelSelect show:YES];
				[colorLevelSelect release];colorLevelSelect = nil;
			}
        }
            break;
        case YDTabRecipeSelectedTyep:
        {
//            三个选项弹出的，已经被标记色级的recipe
			if (_press.state == UIGestureRecognizerStateBegan)
			{
				CGPoint point = CGPointMake(self.bounds.size.width/2+30,self.bounds.size.height+40);
				YDColorPopoverView *popover = [[YDColorPopoverView alloc] 
											   initWithFrame:CGRectMake(0, 0, 164, 142) 
											   type:YDColorPopoverMoreType];
                popover.delegate = self;
				[PopoverView showPopoverAtPoint:point inView:self withTitle:@"" withContentView:popover delegate:self];
				
				[popover release];
				//				[PopoverView showPopoverAtPoint:point inView:self withContentView:popover delegate:self];
			}
        }
            break;
		case YDBulkTabRecipeSelectedType:
		{
			//取消标记
			if (_press.state == UIGestureRecognizerStateBegan)
			{
				CGPoint point = CGPointMake(self.bounds.size.width/2,self.bounds.size.height+50);
//				CGPoint point = CGPointMake(self.screenViewX +5, self.screenViewY+self.height);

				//				YDColorPopoverView *popover = [[YDColorPopoverView alloc] 
				//											   initWithFrame:CGRectMake(0, 0, 164, 57) 
				//											   type:YDColorPopoverSingleType];
				//				popover.transferTarget = self;
				//				[PopoverView showPopoverAtPoint:point inView:self withTitle:@"" withContentView:popover delegate:self];
				//				
				//				[popover release];
				YDTabPopoverView *popover = [[YDTabPopoverView alloc] initWithFrame:CGRectMake(0, 0, 164, 57) 
																			   type:YDTabPopoverSingleType 
																		   delegate:self];
				[PopoverView showPopoverAtPoint:point inView:self withTitle:@"" withContentView:popover delegate:self];
				[popover release];
			}
		}
			break;

        case YDTabColorLevelType:
        {
			//更改色级名称
			if (_press.state == UIGestureRecognizerStateBegan)
			{
				CGPoint point = CGPointMake(self.bounds.size.width/2+30,self.bounds.size.height+40);

				YDColorPopoverView *popover = [[YDColorPopoverView alloc] 
											   initWithFrame:CGRectMake(0, 0, 164, 57) 
											   type:YDColorPopoverSingleType];
//				popover.transferTarget = self;
                popover.delegate = self;
				[PopoverView showPopoverAtPoint:point inView:self withTitle:@"" withContentView:popover delegate:self];
				
				[popover release];
//				[PopoverView showPopoverAtPoint:point inView:self withContentView:popover delegate:self];
			}
        }
            break;
        case YDTabColorLevelMoreType:
        {
			
        }
            break;
		case YDTabCandidateLongPressType:
		{
			//回修小样OK方，正常小样ok方
			if (_press.state == UIGestureRecognizerStateBegan)
			{
				CGPoint point = CGPointMake(self.bounds.size.width/2,self.bounds.size.height*2-40);
				
//				YDColorPopoverView *popover = [[YDColorPopoverView alloc] 
//											   initWithFrame:CGRectMake(0, 0, 164, 57) 
//											   type:YDColorPopoverSingleType];
//				popover.transferTarget = self;
//				[PopoverView showPopoverAtPoint:point inView:self withTitle:@"" withContentView:popover delegate:self];
//				
//				[popover release];
				YDTabPopoverView *popover = [[YDTabPopoverView alloc] initWithFrame:CGRectMake(0, 0, 164, 142) 
																			   type:YDTabPopoverTwoType 
																		   delegate:self];
				[PopoverView showPopoverAtPoint:point inView:self withTitle:@"" withContentView:popover delegate:self];
				[popover release];
			}
			
		}
			break;

        default:
            break;
	}
			
}
#pragma mark ---------------------------

- (void)selectedButtonPress:(UIButton *)_sender
{
//    if (selected) return;
//    NSLog(@"dddddddd");
    selected = _sender.selected = !_sender.selected;
//    deleteButton_.selected = selected;
    
    if (delegate != nil && [delegate respondsToSelector:@selector(palettesRecipe:didSelected:)])
    {
        [delegate palettesRecipe:self didSelected:selected];
    }
}

- (void)deleteButtonPress:(UIButton *)_sender
{
//    if (selected) 
//    {
		selected = _sender.selected = !_sender.selected;
//        selectedButton_.selected = selected;
//    }
//     [[NSNotificationCenter defaultCenter] postNotificationName:YDLabPalettesRemoveRecipeNotification object:nil userInfo:nil];
    if (delegate != nil && [delegate respondsToSelector:@selector(palettesRecipe:didRemove:)])
    {
        [delegate palettesRecipe:self didRemove:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:YDBulkAddictionRemoveRecipeNotification object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:YDBulkPalettesRemoveRecipeNotification object:nil userInfo:nil];
    [self removeFromSuperview];
}

//更新配方的状态
//长按被选择后（标记）如果没有取消标记，下一次长按就不会响应，知道取消
- (void)updateBackgroundImage:(NSInteger )_recipeType
{
//	[]
	recipeType_ = _recipeType;
	[backgroundImageView_ setImage:[self backgroundImageWith:_recipeType]];
}


#pragma mark ----------- 
#pragma mark ==== //修改色级名称

- (void)updateColorLevelName:(NSString *)_name
{
//	NSString *name = [NSString stringWithFormat:@"%@",colorLevelLabel_.text];
//	[self setColorLevelName:_name];
    
    NSPredicate *colorNamePred = [NSPredicate predicateWithFormat:
                              @"colorLvelName == %@",_name];
    NSArray *existColorName = [colorLevelName filteredArrayUsingPredicate:colorNamePred];
    
    NSLog(@"existColorName  %@  count %d",existColorName,[existColorName count]);
	if (colorLevelName)
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.colorLvelName contains[c] %@",_name];
		NSArray *tempArray = [colorLevelName filteredArrayUsingPredicate:predicate];
		//不存在的就，才添加进去
		if (![tempArray count])
		{
			YDColorLevelName *level = (YDColorLevelName *)[tempArray objectAtIndex:0];
			level.colorLvelName = _name;
            [self setColorLevelName:_name];
		}
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"色级名已经存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    
		
	}
}

#pragma mark ----------- 
#pragma mark ==== YDTabPopoverViewDelegate
//标记为正常小样ok方
- (void)tabPopover:(YDTabPopoverView *)_tabPopoverView normalSimple:(BOOL)_normal
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:YDBulkTabCancelSelectedRecipeNotification object:nil];
	recipeType_ = YDTabCandidateSelectedType;
	[self setremodifiedWith:NO];
	[self updateBackgroundImage:YDTabCandidateSelectedType];
    
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary setObject:recipeVale_ forKey:YDLabTabColorRecipeValueKey];
    if (groupId) {
        [dictionary setObject:groupId forKey:YDLabColorGroupIdKey];
    }
    [dictionary setObject:self forKey:YDBulkTabOriginalRecipeKey];
    [dictionary setObject:@"正常" forKey:YDBulkTabRecipeOKNameKey];
    
    
	[[NSNotificationCenter defaultCenter] postNotificationName:YDBulkTabAddSelectedRecipeNotification object:nil userInfo:dictionary];
}



//标记为回修小样ok方
- (void)tabPopover:(YDTabPopoverView *)_tabPopoverView remodifySimple:(BOOL)_remodify
{
	recipeType_ = YDTabCandidateSelectedType;
	[self setremodifiedWith:YES];
	[self updateBackgroundImage:YDTabCandidateSelectedType];
    
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary setObject:recipeVale_ forKey:YDLabTabColorRecipeValueKey];
    if (groupId) {
        [dictionary setObject:groupId forKey:YDLabColorGroupIdKey];
    }
    [dictionary setObject:@"回修" forKey:YDBulkTabRecipeOKNameKey];
    [dictionary setObject:self forKey:YDBulkTabOriginalRecipeKey];

    
	[[NSNotificationCenter defaultCenter] postNotificationName:YDBulkTabAddSelectedRecipeNotification object:nil userInfo:dictionary];

}

//取消标记
- (void)tabPopover:(YDTabPopoverView *)_tabPopoverView cancelTab:(BOOL)_cancel
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:YDBulkTabCancelSelectedRecipeNotification object:nil userInfo:nil];
    
    if (delegate != nil && [delegate respondsToSelector:@selector(tabRecipe:didRemove:)]) {
        [delegate tabRecipe:self didRemove:YES];
    }
    if (originalRecipe) {
        [originalRecipe updateBackgroundImage:YDTabCandidateLongPressType];
        [originalRecipe setremodifiedWith:NO];
    }
    
	[self removeFromSuperview];
}


#pragma mark --------------------------
#pragma mark YDColorPopoverViewDelegate   -----------------------
//更改色级名字  选择更改色级
- (void)tabColorPopover:(YDColorPopoverView *)_colorPopoverView modifyColorName:(BOOL )_modifyName
{
	YDColorLevelAddModifyView *colorLevelMore = [[YDColorLevelAddModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) type:YDColorLevelModified delegate:self];
	[colorLevelMore show:YES];
	[colorLevelMore release];colorLevelMore = nil;

}
//取消标记   选择取消标记
//这时的取消标记其实是状态的更换
- (void)tabColorPopover:(YDColorPopoverView *)_colorPopoverView cancelTab:(BOOL)_cancelTab
{
//    if (recipeType_  == YDTabCandidateSelectedType)
    if (originalRecipe)
    {
        [originalRecipe updateBackgroundImage:YDTabCandidateType];
    }
//    取消标记后还要把该色级的状态改为可用
    
    if (colorLevelName)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"colorLvelName == %@",self.colorLevelNameString];
        NSArray *preNames = [colorLevelName filteredArrayUsingPredicate:predicate];
        if ([preNames count])
        {
            YDColorLevelName *name = (YDColorLevelName *)[preNames objectAtIndex:0];
            name.nameState = 0;
        }
    }
    
    [self transformToUnSelect];
}
//更改色级  选择更改色级
- (void)tabColorPopover:(YDColorPopoverView *)_colorPopoverView changeColorName:(BOOL )_changeName
{

    
    YDColorLevelModifyView *colorLevelSelect = [[YDColorLevelModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) names:colorLevelName delegate:self];
    colorLevelSelect.receiveTarget = self;
    colorLevelSelect.groupId = self.groupId;
    colorLevelSelect.recipeValue = self.recipeVale;
    [colorLevelSelect show:YES];
    [colorLevelSelect release];colorLevelSelect = nil;

}

- (void)removeContenets
{
//    [self addSubview:recipeTitle_];
//    [self addSubview:yellowColorLabel_];
//    [self addSubview:redColorLabel_];
//    [self addSubview:blueColorLabel_];
//	[self addSubview:colorLevelLabel_];
//	[self addSubview:groupNameLabel_];
    
    [recipeTitle_ removeFromSuperview];
    [yellowColorLabel_ removeFromSuperview];
    [redColorLabel_ removeFromSuperview];
    [blueColorLabel_ removeFromSuperview];
    [colorLevelLabel_ removeFromSuperview];
    [groupNameLabel_ removeFromSuperview];
    [moreLabel_ removeFromSuperview];

}

- (void)transformToSelect
{
    self.recipeType = YDTabRecipeSelectedTyep;
    [colorLevelLabel_ removeFromSuperview];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 110, 148)];
    [self.backgroundImageView setImage:[self backgroundImageWith:recipeType_]];
    [self.backgroundImageView setFrame:self.bounds];
//    [self setUpRecipeSelectedBackground];
    [self setTabContentWith:recipeVale_];
//    [self setContentWith:recipeVale_];
//    [self setUpRecipeValueInTab:recipeVale_];
    [self setColorLevelName:self.colorLevelNameString];
     [groupNameLabel_ setText:self.groupId];
//    NSLog(@"转化选中状态");
}

- (void)transformToUnSelect
{
//    NSLog(@"转化为未选中状态");
    self.recipeType = YDTabColorLevelType;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 110, 116)];
    [self.backgroundImageView setImage:[self backgroundImageWith:recipeType_]];
    [self.backgroundImageView setFrame:self.bounds];
    [self removeContenets];
    [self setUpColorLevelBackground];
   
    [self setColorLevelName:self.colorLevelNameString];
//    [self setRecipeVale:recipeVale_];
}


#pragma mark ---------
#pragma mark 色级标记  YDColorLevelModifyViewDelegate


//标记为色级
- (void)didTabColorName:(YDColorLevelModifyView *)_modifyView name:(NSString *)_tabedName
{
//    NSLog(@"标记为色级      %@",_tabedName);
    
    if (recipeType_ == YDTabCandidateType)
    {
//        NSLog(@"候选配方标记色级");
//        recipeType_ = YDTabCandidateSelectedType;
        
        [self updateBackgroundImage:YDTabCandidateSelectedType];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
        [dictionary setObject:_tabedName forKey:YDLabTabColorNameKey];
        if (recipeVale_) {
            [dictionary setObject:recipeVale_ forKey:YDLabTabColorRecipeValueKey];
        }
        if (self.groupId)
        {
            [dictionary setObject:self.groupId forKey:YDLabColorGroupIdKey];
        }
        
        [dictionary setObject:self forKey:YDBulkTabOriginalRecipeKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:YDLabTabColorNameNotification
                                                            object:nil userInfo:dictionary];
        


        
    }
//    如果是已经被标记的配方再重新标记色级的话，该配方的状态需要重新改变
    if (recipeType_ == YDTabRecipeSelectedTyep)
    {
//        NSLog(@"标记配方 更换色级");
        
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
        [dictionary setObject:_tabedName forKey:YDLabTabColorNameKey];
        if (recipeVale_) {
            [dictionary setObject:recipeVale_ forKey:YDLabTabColorRecipeValueKey];
        }
        if (self.groupId)
        {
            [dictionary setObject:self.groupId forKey:YDLabColorGroupIdKey];
        }
        
        [dictionary setObject:originalRecipe forKey:YDBulkTabOriginalRecipeKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:YDLabTabColorNameNotification
                                                            object:nil userInfo:dictionary];
        //        这种状态的标记色级还需要把它之前所在的色级给释放掉,改为可用状态
        if (colorLevelName)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                      @"colorLvelName == %@",self.colorLevelNameString];
            NSArray *preNames = [colorLevelName filteredArrayUsingPredicate:predicate];
            if ([preNames count])
            {
                YDColorLevelName *name = (YDColorLevelName *)[preNames objectAtIndex:0];
                name.nameState = 0;
            }
        }
        
        [self transformToUnSelect];
    }
}

#pragma mark ---------
#pragma mark 修改色级名称或者新增色级  YDColorLevelAddModifyViewDelegate

//修改色级名字  最终修改色级名字
- (void)didchooseModifyName:(YDColorLevelAddModifyView *)_modifyView name:(NSString *)_newColorName
{
//	YDColorLevelAddModifyView *colorLevelMore = [[YDColorLevelAddModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) type:YDColorLevelModified delegate:self];
//	[colorLevelMore show:YES];
//	[colorLevelMore release];colorLevelMore = nil;
//    NSLog(@"修改色级名称   %@",_newColorName);
 
	if (colorLevelName)
	{
//		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.colorLvelName contains[c] %@",_newColorName];
//		NSArray *tempArray = [colorLevelName filteredArrayUsingPredicate:predicate];
//        判断修改的色级名称是否已经存在了.
        NSPredicate *colorNamePred = [NSPredicate predicateWithFormat:
                                      @"colorLvelName == %@",_newColorName];
        NSArray *existColorName = [colorLevelName filteredArrayUsingPredicate:colorNamePred];
		//不存在的就，才添加进去
		if (![existColorName count])
		{
			
            
//            首先找到之前的色级名称所在的位置
            NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                          @"colorLvelName == %@",self.colorLevelNameString];
            NSArray *preNames = [colorLevelName filteredArrayUsingPredicate:predicate];
            if ([preNames count])
            {
                YDColorLevelName *level = (YDColorLevelName *)[preNames objectAtIndex:0];
                level.colorLvelName = _newColorName;
                [self setColorLevelName:_newColorName];
            }
            
			
		}
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"色级名已经存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
		
	}

}

//新增色级
- (void)didchooseAddNewColorName:(YDColorLevelAddModifyView *)_modifyView name:(NSString *)_newColorName
{
//    NSLog(@"新增色级    %@",_newColorName);

	if (colorLevelName)
	{
//		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.colorLvelName contains[c] %@",_newColorName];
//		NSArray *tempArray = [colorLevelName filteredArrayUsingPredicate:predicate];
        NSPredicate *colorNamePred = [NSPredicate predicateWithFormat:
                                      @"colorLvelName == %@",_newColorName];
        NSArray *existColorName = [colorLevelName filteredArrayUsingPredicate:colorNamePred];
		//不存在的就，才添加进去
		if (![existColorName count])
		{
            if (delegate != nil && [delegate respondsToSelector:@selector(recipeDidChangeColorLevelName:)]) {
                [delegate recipeDidChangeColorLevelName:_newColorName];
            }
		}
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"色级名已经存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
		
	}
    

}



- (void)setGroupId:(NSString *)_groupId tabName:(NSString *)_name
{

    self.groupId = _groupId;
    self.tabName = _name;
    
    [colorLevelLabel_ setText:_groupId];
    [groupNameLabel_ setText:_name];

}


#pragma mark ---------------------
#pragma mark PopoverViewDelegate
//Delegate receives this call as soon as the item has been selected
- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
	popoverView.delegate = nil;
	[popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}

//Delegate receives this call once the popover has begun the dismissal animation
- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
}

- (NSString *)getOldUsages
{
    return [self generateOldUsage:recipeVale_];
}

- (NSString *)getNewUsage
{
    return self.usagesNew;

}

- (NSString *)getRecipeNo
{
    if (recipeVale_) {
        return recipeVale_.titleName;
    }
    return nil;

}

- (NSString *)getNa2Co3
{
    if (additives_)
    {
        return additives_.NA2CO3;
    }
    return nil;

}

- (NSString *)getNa2So4
{
    if (additives_)
    {
        return additives_.NA2SO4;
    }
    return nil;

}

- (NSString *)getKeepWarnTime
{
    if (additives_) {
        return additives_.keepWarnTime;
    }
    return nil;

}



//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context{
//    if ([keyPath isEqualToString:@"state"]) {
//        NSLog(@"keyPath   %@",keyPath);
//        NSLog(@"change    %@  key %@  value %@",change,[change allKeys],[change allValues]);
//        NSDictionary *_NewValue = [change valueForKey:@"new"];
//        if ([_NewValue isKindOfClass:[NSDictionary class]]) {
//            //用户登陆或者续期了
//        }
//        else{
//            //用户登出
//        }
//    }
//}
//
//
//
//- (void)updateViewState:(NSInteger)_state
//{
//    [self willChangeValueForKey:@"state"];
//    self.state = state;
//    [self didChangeValueForKey:@"state"];
//}


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
        self.additives = auxiliar.laiUIData;
    }];
}

- (void)queryLabAuxiliariesWith:(NSString *)_chemicalIds withUsage:(NSString *)_usages block:(void (^)(LabAuxiliariesInfo *))block
{
//    NSLog(@"_chemicalIds %@  _usages %@",_chemicalIds,_usages);
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    [self addSubview:loadingView];
    [loadingView release];
    DataMember  *networkDataMemberHandle = [DataMember shareInstance];
    //    dispatch_queue_t kdnoqueue = dispatch_queue_create("YDKDNOQueue", NULL);
    dispatch_queue_t networkProcessQueue = dispatch_queue_create("netquery.palettes", NULL);
    dispatch_async(networkProcessQueue,^{
        LabAuxiliariesInfo *aux = [networkDataMemberHandle GetLabAuxiliariesInfo:_chemicalIds UsageStr:_usages];
//        NSLog(@"aut.so4 %@ so3 %@ warnTime %@",aux.laiUIData.NA2SO4,aux.laiUIData.NA2CO3,aux.laiUIData.keepWarnTime);
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView removeFromSuperview];
//            NSLog(@"获取计算助剂   。。。。。");
            //            NSLog(@"lab获取调方信息信息   。。。。GroupInfoAry.count。 %d  ChemicalInfoAry.count .%d",resutl.GroupInfoAry.count,resutl.ChemicalInfoAry.count);
            block(aux);
        });
        
    });
    
    dispatch_release(networkProcessQueue);

}

#pragma mark ------------------------------------------
#pragma mark ----------- 查询计算助剂 bulk用户



@end
