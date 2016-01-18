//
//  YDViewController.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDViewController.h"
#import "Constants.h"

@interface YDViewController ()
- (void)logoutButtonPress:(id)_sender;
- (void)navigationButtonTouch:(id)sender;


@end

@implementation YDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)logoutButtonPress:(id)_sender
{
    NSInteger buttonType = ((UIButton *)_sender).tag;
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

- (void)navigationButtonTouch:(id)sender
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end
