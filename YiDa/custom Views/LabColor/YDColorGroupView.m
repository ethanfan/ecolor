//
//  YDColorGroupView.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDColorGroupView.h"
#import "YDGroupModifyView.h"
#import "DataKit.h"
#import "YDPostNotificationName.h"


#define kLabColorGroupWith  160

@interface YDColorGroupView()

- (void)setUpBackground;

- (void)upDateSelctedButtonState:(BOOL)_selcted;
- (void)touchButtonAction:(UIButton *)_sender;

@end;

@implementation YDColorGroupView

@synthesize titelLabel = titleLabel_;
@synthesize redColorLabel = redColorLabel_;
@synthesize yellowColorLabel = yellowColorLabel_;
@synthesize blueColorLabel = blueColorLabel_;
@synthesize moreColorLabel = moreColorLabe_ ;

@synthesize selectedButton = selectedButton_;
@synthesize deleteButton = deleteButton_;

@synthesize selected;
@synthesize modify;

@synthesize touchButton = touchButton_;

@synthesize groupViewType = groupViewType_ ;

@synthesize delegate;

@synthesize datasList = datasList_;

@synthesize usages = usages_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        modify = NO;
        [self setUpDeepestBackgroup];
//        [self setUpBackground];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)_viewTitle
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpDeepestBackgroup];
        modify = NO;
        [self setUpBackground];
        selected = NO;
        self.titelLabel.text = _viewTitle;
		groupViewType_ = YDGroupViewTypeNone;
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame datas:(NSArray *)_datas
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpDeepestBackgroup];
        modify = NO;
        self.datasList = _datas;
        [self setUpBackground];
        selected = NO;
		groupViewType_ = YDGroupViewTypeNone;
        
    }
    return self;
}

- (void)dealloc
{
    [titleLabel_ release];titleLabel_ = nil;
    [redColorLabel_ release];redColorLabel_ = nil;
    [yellowColorLabel_ release];yellowColorLabel_ = nil;
    [blueColorLabel_ release];blueColorLabel_ = nil;
    [moreColorLabe_ release];moreColorLabe_ = nil;
    [selectedButton_ release];selectedButton_ = nil;
    [deleteButton_ release];deleteButton_= nil;
	[touchButton_ release];touchButton_ = nil;
    [datasList_ release];datasList_ = nil;
    [usages_ release];usages_ = nil;
    [super dealloc];
}

-(BOOL)isSelected
{
    return selected;
}
- (void)setselectedWith:(BOOL)_selected
{
    selected = _selected;
    [self upDateSelctedButtonState:selected];
}
- (void)upDateSelctedButtonState:(BOOL)_selcted
{
    [selectedButton_ setSelected:_selcted];
    [deleteButton_ setSelected:_selcted];
}

- (void)didMoveToSuperview
{
    if (!self.superview) return;
    
    if (touchButton_ == nil && groupViewType_ == YDGroupViewLabColor)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setFrame:CGRectMake(0, 30, self.bounds.size.width, self.bounds.size.height)];
		self.touchButton = button;
		[button addTarget:self action:@selector(touchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:touchButton_];
		
	}
}

- (void)setUpDeepestBackgroup
{
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundGroup_03.png"]];
    [bg setFrame:self.bounds];
    [self addSubview:bg];
    [bg release];
}

//化学材料值
- (void)setContentLabels:(NSInteger)_count
{
    for (int i = 0; i<_count; i++)
    {
         BGI_Atr_BestGroupInfo *group = (BGI_Atr_BestGroupInfo *)[datasList_ objectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(68, 50+(20+25)*i, kLabColorGroupWith, 25)];
        [label setFont:[UIFont systemFontOfSize:13]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:group.Chemical_Name];
        [self addSubview:label];
        [label release];label = nil;
    }
}

//左边的三个颜色值
- (void)setColorImages:(NSInteger)_count
{
    for(int i =0;i<_count;i++)
    {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(28, 50+(20+25)*i, 22, 25)];
        NSString *imageName = [NSString stringWithFormat:@"Image0%d",i%3+1];
        [image setImage:[UIImage imageNamed:imageName]];
        [self addSubview:image];
        [image release];
    }
}

//设置组合的名字
- (void)setGroupTitle:(NSString *)_groupId
{
    UILabel  *label = [[UILabel alloc] initWithFrame:CGRectMake(91, 9, kLabColorGroupWith, 25)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[NSString stringWithFormat:@"组合%@",_groupId]];
//    self.titelLabel = label;
    [self addSubview:label];
    [label release];label = nil;
}

- (void)setUpBackground
{
   
    
    NSInteger count = [datasList_ count];
    
    [self setColorImages:count];
    [self setContentLabels:count];
    if (count) {
         BGI_Atr_BestGroupInfo *group = (BGI_Atr_BestGroupInfo *)[datasList_ objectAtIndex:0];
        [self setGroupTitle:group.Group_ID];
    }
    
//    BGI_Atr_BestGroupInfo *group = nil;
//    int i = 0;
//    
//    if (i<count) {
//        group = (BGI_Atr_BestGroupInfo *)[datasList_ objectAtIndex:i];
//        i++;
//    }
//    
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(68, 66, kLabColorGroupWith, 25)];
//    [label setFont:[UIFont systemFontOfSize:13]];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setText:group.Chemical_Name];
//    self.yellowColorLabel = label;
//    [label release];label = nil;
//    
//    
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(91, 9, kLabColorGroupWith, 25)];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setText:[NSString stringWithFormat:@"组合%@",group.Group_ID]];
//    self.titelLabel = label;
//    [label release];label = nil;
//    
//    if (i<count) {
//        group = (BGI_Atr_BestGroupInfo *)[datasList_ objectAtIndex:i];
//        i++;
//    }
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(68, 111, kLabColorGroupWith, 25)];
//    [label setFont:[UIFont systemFontOfSize:13]];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setText:group.Chemical_Name];
//    self.redColorLabel = label;
//    [label release];label = nil;
//    
//    if (i<count) {
//        group = (BGI_Atr_BestGroupInfo *)[datasList_ objectAtIndex:i];
//        i++;
//    }
//    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(68, 165, kLabColorGroupWith, 25)];
//    [label setFont:[UIFont systemFontOfSize:13]];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setText:group.Chemical_Name];
//    self.blueColorLabel = label;
//    [label release];label = nil;
    
    
    
	if (groupViewType_ == YDGroupViewLabColor)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setFrame:CGRectMake(6, 9, 26, 26)];
		[button addTarget:self action:@selector(selectedButtonPress:) forControlEvents:UIControlEventTouchUpInside];
		[button setBackgroundImage:[UIImage imageNamed:@"BackgroundSelect.png"] forState:UIControlStateNormal];
		[button setBackgroundImage:[UIImage imageNamed:@"BackgroundSelected.png"] forState:UIControlStateSelected];
		self.selectedButton = button;
		button = nil;
		
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setFrame:CGRectMake(212, 9, 26, 26)];
		[button addTarget:self action:@selector(deleteButtonPress:) forControlEvents:UIControlEventTouchUpInside];
		[button setBackgroundImage:[UIImage imageNamed:@"BackgroundSelect.png"] forState:UIControlStateNormal];
//		[button setBackgroundImage:[UIImage imageNamed:@"BackgroundDeleteSelected.png"] forState:UIControlStateSelected];
		self.deleteButton = button;
		button = nil;
		
		
		[self addSubview:selectedButton_];
		[self addSubview:deleteButton_];
	}
  
    
    [self addSubview:titleLabel_];
    [self addSubview:redColorLabel_];
    [self addSubview:yellowColorLabel_];
    [self addSubview:blueColorLabel_];
  
    
}

- (void)setSelectButton:(BOOL)_selected
{
    if (selectedButton_ == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(6, 9, 26, 26)];
        button.selected = YES;
        [button addTarget:self action:@selector(newSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BackgroundSelect.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"BackgroundSelected.png"] forState:UIControlStateSelected];
        self.selectedButton = button;
        button = nil;
        
        [self addSubview:selectedButton_];
    }
    else
    {
        [selectedButton_ setSelected:NO];
    }

}

//新建的组合才有这个  用于决定是否可以output
- (void)newSelectedButton:(UIButton *)_sender
{
    selected = _sender.selected = !_sender.selected;
    if (delegate != nil && [delegate respondsToSelector:@selector(colorGroupDidSelect:colorGroup:)])
    {
        [delegate colorGroupDidSelect:selected colorGroup:self];
    }
}

- (void)selectedButtonPress:(UIButton *)_sender
{
    if (selected) return;
    selected = _sender.selected = !_sender.selected;
    deleteButton_.selected = selected;
}

- (void)deleteButtonPress:(UIButton *)_sender
{
    if (selected) 
    {
         selected = _sender.selected = !_sender.selected;
        selectedButton_.selected = selected;
    }
}

- (NSString *)chemicalIds
{
    NSMutableString *chemicalIDs = [NSMutableString stringWithCapacity:3];
    NSInteger count = [datasList_ count];
    for (int i = 0; i<count; i++)
        {
            BGI_Atr_BestGroupInfo *group = (BGI_Atr_BestGroupInfo *)[datasList_ objectAtIndex:i];
            if (i== 0) {
                [chemicalIDs appendString:[NSString stringWithFormat:@"%@",group.Chemical_ID]];
            }
            else {
                [chemicalIDs appendString:[NSString stringWithFormat:@",%@",group.Chemical_ID]];
            }
        }
    return chemicalIDs;
}

- (NSString *)groupId
{
    NSInteger count = [datasList_ count];
    NSString *groupid = nil;
    if (count) {
        BGI_Atr_BestGroupInfo *group = (BGI_Atr_BestGroupInfo *)[datasList_ objectAtIndex:0];
        groupid = group.Group_ID;
    }
    return groupid;
}

- (void)touchButtonAction:(UIButton *)_sender
{
    if ([datasList_ count])
    {
//        NSMutableDictionary *groupDictioary = [NSMutableDictionary dictionary];
//        NSMutableString *chemicalIDs = [NSMutableString stringWithCapacity:0];
//        BGI_Atr_BestGroupInfo *tempGroup = (BGI_Atr_BestGroupInfo *)[datasList_ objectAtIndex:0];
//        NSString     *groupID = tempGroup.Group_ID;
//        
//        NSInteger count = [datasList_ count];
//        for (int i = 0; i<count; i++)
//        {
//            BGI_Atr_BestGroupInfo *group = (BGI_Atr_BestGroupInfo *)[datasList_ objectAtIndex:i];
//            if (i== 0) {
//                [chemicalIDs appendString:[NSString stringWithFormat:@"%@",group.Chemical_ID]];
//            }
//            else {
//                [chemicalIDs appendString:[NSString stringWithFormat:@",%@",group.Chemical_ID]];
//            }
//        }
//        [groupDictioary setObject:chemicalIDs forKey:YDLabColorChemicalIdKey];
//        [groupDictioary setObject:groupID forKey:YDLabColorGroupIdKey];
        
        YDGroupModifyView *modifyView = [[YDGroupModifyView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        modifyView.delegate = self;
        modifyView.usages = self.usages;
        modifyView.chemicalList = datasList_;
//        [modifyView setChemicalListWith:datasList_];
        [modifyView show:YES];
        [modifyView release];
        
    }

}
- (void)finishModifyGroupWith:(NSString *)_usages
{
    self.usages = _usages;
    [self setSelectButton:YES];
    if (delegate != nil && [delegate respondsToSelector:@selector(colorGroupDidSelect:colorGroup:)])
    {
        [delegate colorGroupDidSelect:YES colorGroup:self];
    }
}

@end
