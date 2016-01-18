//
//  YDCustomNavigationBar.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDCustomNavigationBar.h"
#import "Constants.h"

@interface YDCustomNavigationBar ()

- (void)setUpAppearance;
- (void)setUpRightItem:(NSInteger)_userType;
- (void)setUpLeftItem:(NSInteger)_number viewType:(NSInteger)_viewType;
- (void)navigationButtonTouch:(UIButton *)sender;
- (UIImage *)buttonImage:(NSInteger )_viewType;
@end


@implementation YDCustomNavigationBar

@synthesize touchRespondAction;
@synthesize currentUserType;
@synthesize navigationBarViewType = navigationBarViewType_;
@synthesize delegate = delegate_;
@synthesize buttons = buttons_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithLeftButtonNumber:(NSInteger )_numbers 
                      viewType:(NSInteger)_viewType 
                      userType:(NSInteger )_userType 
                      delegate:(id<YDCustomNavigationBarButtonDelegate>)_delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, 1024, 39)];
    if (self)
    {
        currentUserType = _userType;
        self.navigationBarViewType = _viewType;
        [self setUpAppearance];
        [self setUpRightItem:_userType];
        [self setUpLeftItem:_numbers viewType:_viewType];
    }
    return self;
}

- (UIImage *)buttonImage:(NSInteger )_viewType
{
    UIImage *image = nil;
//    NSInteger viewType = _viewType;
//    switch (viewType) 
//    {
//            //选料
//        case YDNavigationBarViewColor:
//            image = [UIImage imageNamed:@"ButtonNavigationBarColor.png"];
//            break;
//            //调方
//        case YDNavigationBarViewPalettes:
//            if (currentUserType == YDUserTypeLab)
//            {
//                image = [UIImage imageNamed:@"ButtonNavigationBarLabPalettes.png"];
//            }
//            else if (currentUserType == YDUserTypeBulk)
//            {
//                image = [UIImage imageNamed:@"ButtonNavigationBarBulkPalettes.png"];
//            }
//            
//            break;
//            //标记
//        case YDNavigationBarViewTab:
//            image = [UIImage imageNamed:@"ButtonNavigagtionBarTab.png"];
//            break;
//            //加成
//        case YDNavigationBarViewAddiction:
//            image = [UIImage imageNamed:@"ButtonNavigagtionBarTab.png"];
//            break;
//            //查询
//        case YDNavigationBarViewQuery:
//            image = [UIImage imageNamed:@"ButtonNavigationBarQuery.png"];
//        default:
//            break;
//    }
    return image;
}
- (void)setUpAppearance
{
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.bounds];
    [background setImage:[UIImage imageNamed:@"NavigationBackground.png"]];
    [self addSubview:background];
    [background release];
}
- (void)setUpRightItem:(NSInteger)_userType
{
    if (_userType == YDUserTypeLab) 
    {
        UIImageView *userGroupImage = [[UIImageView alloc] initWithFrame:CGRectMake(861, 1, 106, 33)];
        [userGroupImage setImage:[UIImage imageNamed:@"ButtonNavigationBarLabUser.png"]];
        [self addSubview:userGroupImage];
        [userGroupImage release];
        
        
    }
    else if (_userType == YDUserTypeBulk)
    {
        UIImageView *userGroupImage = [[UIImageView alloc] initWithFrame:CGRectMake(861, 1, 106, 33)];
        [userGroupImage setImage:[UIImage imageNamed:@"ButtonNavigationBarBulkUser.png"]];
        [self addSubview:userGroupImage];
        [userGroupImage release];
    }
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.tag = YDNavigationBarButtonLogout;
    [logoutButton setFrame:CGRectMake(967, 1, 53, 33)];
    [logoutButton addTarget:self action:@selector(navigationButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"ButtonNavigationBarLogout.png"] forState:UIControlStateNormal];
    [self addSubview:logoutButton];
}
- (void)setUpLeftItem:(NSInteger)_number viewType:(NSInteger)_viewType
{
    //只有一个返回按钮
    if (_number == 1)
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.tag = YDNavigationBarButtonLogout;
        [backButton setFrame:CGRectMake(4, 1, 53, 33)];
        [backButton addTarget:self action:@selector(navigationButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"ButtonNavigationBarBackOnly.png"] forState:UIControlStateNormal];
        [self addSubview:backButton];
    }
    else if (_number >1)
    {
        
//        for (int i = 0; i<4; i++)
//        {
        int i = 0;
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.tag = YDNavigationBarButtonTitle;
        [backButton setFrame:CGRectMake(4+53*i, 1, 53, 33)];
        i +=1;
        [backButton addTarget:self action:@selector(navigationButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[self buttonImage:navigationBarViewType_] forState:UIControlStateNormal];
        [self addSubview:backButton];
        backButton = nil;
//        }
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.tag = YDNavigationBarButtonOutput;
        [backButton setFrame:CGRectMake(4+53*i, 1, 53, 33)];
        i +=1;
        [backButton addTarget:self action:@selector(navigationButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage: [UIImage imageNamed:@"ButtonNavigationBarOutput.png"]forState:UIControlStateNormal];
        [self addSubview:backButton];
        backButton = nil;
        
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
         backButton.tag = YDNavigationBarButtonCancel;
        [backButton setFrame:CGRectMake(4+53*i, 1, 53, 33)];
        i +=1;
        [backButton addTarget:self action:@selector(navigationButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage: [UIImage imageNamed:@"ButtonNavigationBarCancel.png"]forState:UIControlStateNormal];
        [self addSubview:backButton];
        backButton = nil;
        
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
         backButton.tag = YDNavigationBarButtonBack;
        [backButton setFrame:CGRectMake(4+53*i, 1, 53, 33)];
        i +=1;
        [backButton addTarget:self action:@selector(navigationButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage: [UIImage imageNamed:@"ButtonNavigationBarBack.png"]forState:UIControlStateNormal];
        [self addSubview:backButton];
        backButton = nil;
        
    }
}

//button action distinguished by button's tag
- (void)navigationButtonTouch:(UIButton *)sender
{
    NSInteger buttonType = sender.tag;
    switch (buttonType)
    {
            //返回按钮
        case YDNavigationBarButtonBack: 
            
            break;
            //取消按钮
        case YDNavigationBarButtonCancel:
            break;
            //注销按钮
        case YDNavigationBarButtonLogout:
            break;
        case YDNavigationBarButtonTitle://do nothing
            break;
            //output按钮
        case YDNavigationBarButtonOutput:
            break;
        default:
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
