//
//  YDPalettesGroupView.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDPalettesGroupView.h"

@interface YDPalettesGroupView ()

- (void)setUpBackground;

- (void)setContentWith:(Group_Head *)_group;

@end

@implementation YDPalettesGroupView

@synthesize colorImage = colorImage_;
@synthesize groupTitleLabel = groupTitleLabel_;
@synthesize yellowColorLabel = yellowColorLabel_;
@synthesize redColorLabel = redColorLabel_;
@synthesize blueColorLabel = blueColorLabel_;

@synthesize palettesGroup = paletteGroup_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpBackground];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withGroup:(Group_Head *)_groupContent
{
    self = [super initWithFrame:frame];
    if (self) {
        self.palettesGroup = _groupContent;
        [self setUpBackground];
    }
    return self;
}

- (void)dealloc
{
    [colorImage_ release];colorImage_ = nil;
    [groupTitleLabel_ release];groupTitleLabel_ = nil;
    [yellowColorLabel_ release];yellowColorLabel_ = nil;
    [redColorLabel_ release];redColorLabel_ = nil;
    [blueColorLabel_ release];blueColorLabel_ = nil;
    
    [paletteGroup_ release];
    if (scrollView) {
        [scrollView release];
        scrollView = nil;
    }
    [super dealloc];
}

- (void)setUpBackground
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
    [bg setImage:[UIImage imageNamed:@"BackgroundGroup_02.png"]];
    [self addSubview:bg];
    [bg release];
    
    if (scrollView == nil) {
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:scrollView];
    }

    
}

- (void)didMoveToSuperview
{
    if (!self.superview) return;
    [self setContentWith:paletteGroup_];
    [self setUpColorImagesWith:[paletteGroup_.valueAry count]];
}

- (void)setUpColorImagesWith:(NSInteger)_count
{
    for(int i =0;i<_count;i++)
    {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60+(20+25)*i, 22, 25)];
        NSString *imageName = [NSString stringWithFormat:@"Image0%d",i%3+1];
        [image setImage:[UIImage imageNamed:imageName]];
        [self addSubview:image];
        [image release];
    }
}

- (void)setGroupTitleWith:(NSString *)_title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 240, 25)];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[NSString stringWithFormat:@"组合%@",_title]];
    [self addSubview:label];
    [label release];label = nil;
}

- (void)setContentWith:(Group_Head *)_group
{
    if (_group)
    {
//        [self.groupTitleLabel setText:[NSString stringWithFormat:@"组合%@",_group.titleName]];
        [self setGroupTitleWith:_group.titleName];
        NSInteger count = [_group.valueAry count];
        CGSize size = CGSizeZero;
        CGSize contraint = CGSizeMake(999999, 25);
        if (count)
        {
            NSMutableArray *values = _group.valueAry;
            for (int i = 0; i<count; i++)
            {
                CGSize tempSize = CGSizeZero;
                 NSString *name = (NSString *)[values objectAtIndex:i];
                CGRect frame = CGRectMake(60, 55+(25+20)*i, 150, 25);
                UILabel *label = [[UILabel alloc] initWithFrame:frame];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:13]];
                tempSize = [name sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:contraint lineBreakMode:NSLineBreakByWordWrapping];
                if (tempSize.width >size.width) {
                    size = tempSize;
                }
                frame.size = tempSize;
                [label setFrame:frame];
                [label setText:name];
                [scrollView addSubview:label];
                [label release];label = nil;
            }
        }
        size.width = size.width+60;
        [scrollView setContentSize:size];
//            for (int i = 0; i<count; i++)
//            {
//                NSString *name = (NSString *)[values objectAtIndex:i];
//                if (i== 0) [yellowColorLabel_ setText:name];
//                if (i== 1)  [redColorLabel_ setText:name];
//                if (i== 2) [blueColorLabel_ setText:name];
//            }
//        }
    }
}

@end
