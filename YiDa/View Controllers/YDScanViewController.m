//
//  YDScanViewController.m
//  YiDa
//
//  Created by 罗 祖根 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YDScanViewController.h"
#import "YDLabColorViewController.h"
#import "YDLabPalettesViewController.h"
#import "YDLabTabViewController.h"
#import "YDLabQueryDetailViewController.h"
#import "YDBulkPalettesViewController.h"
#import "YDBulkAddictionViewController.h"
#import "YDBulkTabViewController.h"
#import "YDBulkVarietyQueryViewController.h"
#import "YDBulkProgressQueryViewController.h"
#import "YDAppDelegate.h"



#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>


//测试lbno   LB2012-2809



#define RotateDegree(x) x * M_PI / 180

@interface YDScanViewController ()


@property (nonatomic ,retain)  ZBarReaderView  *ZBarReaderView;

- (void)setUpScanAppearance:(NSInteger )_viewType;
- (CGRect)currentViewImageFrame:(NSInteger )_viewType;
- (UIImage *)buttonImage:(NSInteger )_viewType;
- (void)setUp:(NSInteger)_viewType;
- (void)updateBulkQueryOption;
- (void)bulkQueryOptionButton:(UIButton *)_sender;
- (BOOL)showCameraWith:(NSInteger )_viewType;
- (void)setupScanCamera:(BOOL)_scan;
- (BOOL)cameras;

- (void)removeCaptureWhenInput;

@end

@implementation YDScanViewController
@synthesize currentViewType = currentViewType_;
@synthesize scanBackgroundView = scanBackgroundView_;
@synthesize navigationBarBackgroundView = navigationBarBackgroundView_;
@synthesize userTypeImageView = userTypeImageView_;
@synthesize currentViewImage = currentViewImage_;
@synthesize codeInputField = codeInputField_;
@synthesize confirmButton = confirmButton_;
@synthesize reInputButton = reInputButton_;
@synthesize failTipLabel = failTipLabe_;
@synthesize backButton = backButton_;
@synthesize logoutButton = logoutButton_;
@synthesize cameraBackgroundView = cameraBackgroundView_;



@synthesize ZBarReaderView;

@synthesize currentUserType = currentUserType_;

@synthesize scanedCode = scanedCode_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentViewType=0;
    }
    return self;
}

- (void)dealloc
{
    [scanBackgroundView_ release];scanBackgroundView_ = nil;
    [navigationBarBackgroundView_ release];navigationBarBackgroundView_ = nil;
    [userTypeImageView_ release];userTypeImageView_ = nil;
    [currentViewImage_ release];currentViewImage_ = nil;
    [codeInputField_ release];codeInputField_ = nil;
    [confirmButton_ release];confirmButton_ = nil;
    [reInputButton_ release];reInputButton_ = nil;
    [failTipLabe_ release];failTipLabe_ = nil;
    [backButton_ release];backButton_ = nil;
    [logoutButton_ release];logoutButton_ = nil;
    [cameraBackgroundView_ release];cameraBackgroundView_ = nil;
    self.scanedCode = nil;
    
    self.ZBarReaderView = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
                 view:(NSInteger)_viewType
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.currentViewType = _viewType;
        UIImageView *background = [[UIImageView alloc] initWithFrame:[self currentViewImageFrame:currentViewType_]];
        [background setImage:[self buttonImage:currentViewType_]];
        self.currentViewImage = background;
        [background release];background  = nil;
    }
    return self;
}

- (void)setUp:(NSInteger)_viewType
{

}

- (CGRect)currentViewImageFrame:(NSInteger )_viewType
{
    CGRect rect = CGRectZero;
    switch (_viewType) 
    {
        case YDNavigationBarViewLabColor: 
            rect = CGRectMake(12, 43, 326, 246);
            break;
            //
        case YDNavigationBarViewLabPalettes:
            rect = CGRectMake(694, 44, 326, 246);
            break;
            //
        case YDNavigationBarViewLabTab:
           rect = CGRectMake(12, 500, 326, 246);
            
            break;
        case YDNavigationBarViewLabQuery://do nothing
            rect = CGRectMake(693, 500, 326, 246);
            break;
            //
        case YDNavigationBarViewBulkPalettes:
            rect = CGRectMake(12, 43, 326, 246);
            break;
        case YDNavigationBarViewBulkTab:
            rect = CGRectMake(694, 44, 326, 246);
            break;
        case YDNavigationBarViewBulkAddiction:
            rect = CGRectMake(12, 500, 326, 246);
            break;
        case YDNavigationBarViewBulkQuery:
            rect = CGRectMake(693, 500, 326, 246);
            break;
		case YDNavigationBarViewBulkRecipe:
			rect = CGRectMake(693, 500, 326, 246);			
			break;
		case YDNavigationBarViewBulkVariety:
			rect = CGRectMake(693, 500, 326, 246);	
			break;
		case YDNavigationBarViewBulkProgress:
			rect = CGRectMake(693, 500, 326, 246);	
			break;
            
        default:
            break;
    }
    return rect;

}

- (UIImage *)buttonImage:(NSInteger )_viewType
{
    UIImage *image = nil;
    NSInteger viewType = _viewType;
    switch (viewType) 
    {
        case YDNavigationBarViewLabColor: 
            image = [UIImage imageNamed:@"ButtonColorSelected.png"];
            break;
            //
        case YDNavigationBarViewLabPalettes:
            image = [UIImage imageNamed:@"ButtonLabPalettesSelected.png"];
            break;
            //
        case YDNavigationBarViewLabTab:
            image = [UIImage imageNamed:@"ButtonLabTabSelected.png"];

            break;
        case YDNavigationBarViewLabQuery://do nothing
            image = [UIImage imageNamed:@"ButtonQuerySelected.png"];
            break;
            //
        case YDNavigationBarViewBulkPalettes:
            image = [UIImage imageNamed:@"ButtonBulkPalettesSelected.png"];
            break;
        case YDNavigationBarViewBulkTab:
            image = [UIImage imageNamed:@"ButtonBulkTabSelected.png"];
            break;
        case YDNavigationBarViewBulkAddiction:
            image = [UIImage imageNamed:@"ButtonBulkAdditionSelected.png"];
            break;
        case YDNavigationBarViewBulkQuery:
            image = [UIImage imageNamed:@"ButtonQuerySelected.png"];
            break;
		case YDNavigationBarViewBulkRecipe:
		{
			image = [UIImage imageNamed:@"ButtonQuerySelected.png"];			
		}
			break;
		case YDNavigationBarViewBulkVariety:
		{
			image = [UIImage imageNamed:@"ButtonQuerySelected.png"];	
			
		}
			break;
		case YDNavigationBarViewBulkProgress:
		{
			image = [UIImage imageNamed:@"ButtonQuerySelected.png"];	
			
		}
			break;

        default:
            break;
    }
    return image;
}

- (void)setUpScanAppearance:(NSInteger )_viewType
{
    switch (_viewType)
    {
            //
        case YDNavigationBarViewLabColor: 
            
            break;
            //
        case YDNavigationBarViewLabPalettes:
            break;
            //
        case YDNavigationBarViewLabTab:
        {
            
        }
            break;
        case YDNavigationBarViewLabQuery:
        {
			reInputButton_.hidden = YES;
			failTipLabe_.hidden = YES;
			[codeInputField_ setPlaceholder:@"输入缸号/色号"];
            [codeInputField_ setFrame:CGRectMake(328, 300, 280, 45)];
            [confirmButton_ setBackgroundImage:[UIImage imageNamed:@"ButtonQueryImage.png"] forState:UIControlStateNormal];
            [confirmButton_ setFrame:CGRectMake(615, 305, 78, 31)];
			[cameraBackgroundView_ setFrame:CGRectMake(236, 196, 552, 355)];
//			[cameraBackgroundView_ setFrame:CGRectMake(378, 249, 225, 175)];
			[cameraBackgroundView_ setImage:[UIImage imageNamed:@"BackgroundInput.png"]];
            cameraBackgroundView_.hidden = NO;

        }
            break;
            //
        case YDNavigationBarViewBulkPalettes:
            break;
        case YDNavigationBarViewBulkTab:
            break;
        case YDNavigationBarViewBulkAddiction:
            break;
        case YDNavigationBarViewBulkQuery:
        {
//            [codeInputField_ setFrame:CGRectMake(328, 300, 280, 45)];
//            [confirmButton_ setFrame:CGRectMake(615, 300, 79, 41)];
//			[cameraBackgroundView_ setFrame:CGRectMake(236, 196, 552, 355)];
//			[cameraBackgroundView_ setFrame:CGRectMake(378, 249, 225, 175)];
//			[self updateBulkQueryOption];
//			codeInputField_.hidden = YES;
//			confirmButton_.hidden = YES;
			[cameraBackgroundView_ setImage:[UIImage imageNamed:@"BackgroundInput.png"]];
             cameraBackgroundView_.hidden = NO;
        }
            break;
		case YDNavigationBarViewBulkRecipe:
		{
			reInputButton_.hidden = YES;
			failTipLabe_.hidden = YES;
			[codeInputField_ setFrame:CGRectMake(328, 300, 280, 45)];
			[codeInputField_ setPlaceholder:@"输入缸号/色号"];
            [confirmButton_ setFrame:CGRectMake(615, 305, 78, 31)];
            [confirmButton_ setBackgroundImage:[UIImage imageNamed:@"ButtonQueryImage.png"] forState:UIControlStateNormal];
			[cameraBackgroundView_ setFrame:CGRectMake(236, 196, 552, 355)];
//			[codeInputField_ setBackground:[UIImage imageNamed:@"BackgroundCodeInput_01.png"]];
			[cameraBackgroundView_ setImage:[UIImage imageNamed:@"BackgroundInput.png"]];
             cameraBackgroundView_.hidden = NO;

		}
			break;
		case YDNavigationBarViewBulkVariety:
		{
			reInputButton_.hidden = YES;
			failTipLabe_.hidden = YES;
			[codeInputField_ setFrame:CGRectMake(328, 300, 280, 45)];
			[codeInputField_ setPlaceholder:@"输入缸号/色号/品名"];
            [confirmButton_ setFrame:CGRectMake(615, 305, 78, 31)];
            [confirmButton_ setBackgroundImage:[UIImage imageNamed:@"ButtonQueryImage.png"] forState:UIControlStateNormal];
			[cameraBackgroundView_ setFrame:CGRectMake(236, 196, 552, 355)];
//			[codeInputField_ setBackground:[UIImage imageNamed:@"BackgroundCodeInput_01.png"]];
			[cameraBackgroundView_ setImage:[UIImage imageNamed:@"BackgroundInput.png"]];
             cameraBackgroundView_.hidden = NO;

		}
			break;
		case YDNavigationBarViewBulkProgress:
		{
			reInputButton_.hidden = YES;
			failTipLabe_.hidden = YES;
			[codeInputField_ setFrame:CGRectMake(328, 300, 280, 45)];
			[codeInputField_ setPlaceholder:@"输入缸号"];
            [confirmButton_ setBackgroundImage:[UIImage imageNamed:@"ButtonQueryImage.png"] forState:UIControlStateNormal];
            [confirmButton_ setFrame:CGRectMake(615, 305, 78, 31)];
			[cameraBackgroundView_ setFrame:CGRectMake(236, 196, 552, 355)];
//			[codeInputField_ setBackground:[UIImage imageNamed:@"BackgroundCodeInput_01.png"]];
			[cameraBackgroundView_ setImage:[UIImage imageNamed:@"BackgroundInput.png"]];
             cameraBackgroundView_.hidden = NO;

		}
			break;

        default:
            break;
    }

}

- (void)removeCaptureWhenInput
{
//    if (self.capture)
//    {
//        [self.capture.layer removeFromSuperlayer];
//        [self.capture stop];
//        
//        self.capture = nil;
//    }
}

- (BOOL)cameras
{
    BOOL hasCamera = NO;
    NSArray *deviecs = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if ([deviecs count])
    {
        hasCamera = YES;
    }
    
    return hasCamera;
}
- (BOOL)showCameraWith:(NSInteger )_viewType
{
    BOOL show = YES;
    if (_viewType == YDNavigationBarViewBulkProgress ||
        _viewType == YDNavigationBarViewBulkVariety ||
        _viewType == YDNavigationBarViewBulkQuery ||
        _viewType == YDNavigationBarViewLabQuery ||
        _viewType == YDNavigationBarViewBulkRecipe)
    {
        show = NO;
        cameraBackgroundView_.hidden  = NO;
    }
    return  show;
}

- (void)setupScanCamera:(BOOL)_scan
{
#if !TARGET_IPHONE_SIMULATOR
    if (_scan)
    {
        if (!self.ZBarReaderView)
        {
            
        
        ZBarImageScanner *scaner = [[ZBarImageScanner alloc] init];
        
        [scaner setSymbology: ZBAR_I25
                      config: ZBAR_CFG_ENABLE
                          to: 0];
            [scaner setSymbology: ZBAR_CODE128
                          config: ZBAR_CFG_ENABLE
                              to: 0];
            [scaner setSymbology: ZBAR_CODE93
                          config: ZBAR_CFG_ENABLE
                              to: 0];

        
        ZBarReaderView *reader = [[ZBarReaderView alloc] initWithImageScanner:scaner];
        reader.readerDelegate = self;
        self.ZBarReaderView = reader;
            
            if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                [ self.ZBarReaderView setPreviewTransform:CGAffineTransformMakeRotation(RotateDegree(90) )];
            }
            else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
            {
                [ self.ZBarReaderView setPreviewTransform:CGAffineTransformMakeRotation(RotateDegree(-90) )];
                
            }
        
        
        reader.frame = CGRectMake(328, 232, 376, 372);
        [self.view addSubview:reader];
//        [reader start];
        
        [reader release];
        [scaner release];
        }
        
/*
        if (scanedSound)
        {
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"aiff"];
            NSLog(@"AudioServicesCreateSystemSoundID before %ld",scanedSound);
            AudioServicesCreateSystemSoundID((CFURLRef)[NSURL URLWithString:soundPath], &scanedSound);
            NSLog(@"AudioServicesCreateSystemSoundID after %ld",scanedSound);
        }
        
        
        self.capture = [[[ZXCapture alloc] init] autorelease];
        self.capture.delegate = self;
        //    如果是拍一维码就不需要旋转
        //    self.capture.rotation = 90.0f;
        
        
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
            [self.capture setTransform:CGAffineTransformMakeRotation(RotateDegree(90) )];
        }
        else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        {
            [self.capture setTransform:CGAffineTransformMakeRotation(RotateDegree(-90) )];
            
        }
        //    self.capture.torch = YES;
        
        // Use the back camera
        self.capture.camera = self.capture.back;
        
        self.capture.layer.frame = CGRectMake(328, 232, 376, 372);
        [self.view.layer addSublayer:self.capture.layer];
        
        [self.capture start];
        NSLog(@"capture did appear!!!!");
 */
    }
 
#endif
}

- (void) initAudio
{
    if(scanSound_)
        return;
    NSError *error = nil;
    scanSound_ = [[AVAudioPlayer alloc]
            initWithContentsOfURL:
            [[NSBundle mainBundle]
             URLForResource: @"beep-beep"
             withExtension: @"aiff"]
            error: &error];
    if(!scanSound_)
        NSLog(@"声音加载失败   %@",[error localizedDescription]);
    else {
        scanSound_.volume = .5f;
        [scanSound_ prepareToPlay];
    }
}

- (void) playBeep
{
    if(!scanSound_)
        [self initAudio];
    [scanSound_ play];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:kColor];

    // Do any additional setup after loading the view from its nib.
	
    NSInteger userType = [[self YDAppDelegate] currentUserType];
 
    
	if (userType == YDUserTypeLab)
	{
		userTypeImageView_.image = [UIImage imageNamed:@"ButtonNavigationBarLabUser.png"];
	}
	else if (userType == YDUserTypeBulk)
	{
		userTypeImageView_.image = [UIImage imageNamed:@"ButtonNavigationBarBulkUser.png"];

	}
    [self setUpScanAppearance:currentViewType_];
   
    
//    [self setupScanCamera:[self cameras]];
     [self setupScanCamera:[self showCameraWith:currentViewType_]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.currentViewImage];
	
//	userTypeImageView_
//	if (currentViewType_ == ) {
//		<#statements#>
//	}
    
//    cameraBackgroundView_.hidden  = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if ([self cameras]) 
    {
//        [self setupScanCamera:[self showCameraWith:currentViewType_]];

    }
    else if ([self showCameraWith:currentViewType_])
    {
        failTipLabe_.hidden = NO;
        [failTipLabe_ setText:@"没有检测到摄像设备"];
    }
    
    if (self.ZBarReaderView)
    {
        [self.ZBarReaderView start];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
    if (self.ZBarReaderView) {
        [self.ZBarReaderView stop];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

	return interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orient
                                 duration: (NSTimeInterval) duration
{
    // compensate for view rotation so camera preview is not rotated
    //    [readerView willRotateToInterfaceOrientation: orient
    //                                        duration: duration];
    if (orient==UIInterfaceOrientationLandscapeLeft || orient == UIInterfaceOrientationLandscapeRight) {
        [self.ZBarReaderView willRotateToInterfaceOrientation:orient duration:0];
    }
}




- (void)updateBulkQueryOption
{
	for (int i =0; i<3; i++)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = i+1;
		[button setBackgroundColor:[UIColor colorWithRed:222/255.0 green:218/255.0 blue:209/255.0 alpha:1.0]];
		[button addTarget:self action:@selector(bulkQueryOptionButton:) forControlEvents:UIControlEventTouchUpInside];
//		[button setTitle:@"111" forState:UIControlStateNormal];
		if (i== 0) [button setTitle:@"配方进度查询" forState:UIControlStateNormal];
		if (i== 1) [button setTitle:@"品种进度查询" forState:UIControlStateNormal];
		if (i== 2) [button setTitle:@"进度跟踪查询" forState:UIControlStateNormal];

		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button setFrame:CGRectMake(400, 260+55*i, 180, 35)];
		[self.view addSubview:button];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    NSLog(@"textFieldShouldEndEditing");
    self.scanedCode = [textField text];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    NSLog(@"textFieldShouldBeginEditing");
    return YES;
}






#pragma mark -------------- 
#pragma mark ----  ZBarReaderViewDelegate

- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    for(ZBarSymbol *sym in symbols)
    {
        self.scanedCode = sym.data;
        break;
    }
    [self.ZBarReaderView stop];
    [self playBeep];
//    NSLog(@"out put  scanner");
//    NSLog(@"symbols  %@   code %@",symbols,self.scanedCode);
    codeInputField_.text = self.scanedCode;
    
    [self performSelector:@selector(confirmButtonPress:) withObject:nil afterDelay:0.5];
}


- (YDAppDelegate *)YDAppDelegate
{
    return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark---------------------------------
#pragma mark button action

- (void)bulkQueryOptionButton:(UIButton *)_sender
{
	
}

- (IBAction)backButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutButtonPress:(id)sender
{
    [[self YDAppDelegate] logOut];

}


#pragma mark -----
#pragma mark 确定按钮
- (IBAction)confirmButtonPress:(id)sender
{
	[codeInputField_ resignFirstResponder];
	if (![codeInputField_.text length]) 
	{
		return;
	}
    switch (currentViewType_) 
    {
            //lab选料
        case YDNavigationBarViewLabColor: 
        {
            YDLabColorViewController *labController = [[YDLabColorViewController alloc] initWithNibName:@"YDLabColorViewController" bundle:nil withCode:scanedCode_];
            [self.navigationController pushViewController:labController animated:YES];
            [labController release];labController = nil;
        }
            break;
            //lab调方
        case YDNavigationBarViewLabPalettes:
        {
            YDLabPalettesViewController *labController = [[YDLabPalettesViewController alloc] initWithNibName:@"YDLabPalettesViewController" bundle:nil withCode:scanedCode_];
            [self.navigationController pushViewController:labController animated:YES];
            [labController release];labController = nil;

        }
            break;
            //lab标记
        case YDNavigationBarViewLabTab:
        {
            YDLabTabViewController *tabViewController = [[YDLabTabViewController alloc ] initWithNibName:@"YDLabTabViewController" bundle:nil withCode:scanedCode_];
            [self.navigationController pushViewController:tabViewController animated:YES];
            [tabViewController release];tabViewController = nil;
        }
            
            break;
            //lab查询
        case YDNavigationBarViewLabQuery://
		{
			YDLabQueryDetailViewController *queryViewController = [[YDLabQueryDetailViewController alloc] initWithNibName:@"YDLabQueryDetailViewController" bundle:nil withCode:scanedCode_];
			[self.navigationController pushViewController:queryViewController animated:YES];
			[queryViewController release];queryViewController = nil;
		}
            break;
            //bulk调方
        case YDNavigationBarViewBulkPalettes:
		{
			YDBulkPalettesViewController *bulkPalettesViewController = [[YDBulkPalettesViewController alloc] initWithNibName:@"YDBulkPalettesViewController" bundle:nil withCode:scanedCode_];
			[self.navigationController pushViewController:bulkPalettesViewController animated:YES];
			[bulkPalettesViewController release];bulkPalettesViewController = nil;
		}
            break;
            //bulk标记
        case YDNavigationBarViewBulkTab:
		{
			YDBulkTabViewController *tabViewController = [[YDBulkTabViewController alloc] initWithNibName:@"YDBulkTabViewController" bundle:nil withCode:scanedCode_];
			[self.navigationController pushViewController:tabViewController animated:YES];
			[tabViewController release];tabViewController = nil;
		}
            break;
            //bulk加成
        case YDNavigationBarViewBulkAddiction:
		{
			YDBulkAddictionViewController *addictionViewController = [[YDBulkAddictionViewController alloc] initWithNibName:@"YDBulkAddictionViewController" bundle:nil withCode:scanedCode_];
			[self.navigationController pushViewController:addictionViewController animated:YES];
			[addictionViewController release];addictionViewController = nil;
		}
            break;
        case YDNavigationBarViewBulkQuery:
		{
			[self updateBulkQueryOption];
		}
            break;
            //bulk配方进度查询
        case YDNavigationBarViewBulkRecipe:
        {
            YDLabQueryDetailViewController *queryViewController = [[YDLabQueryDetailViewController alloc] initWithNibName:@"YDLabQueryDetailViewController" bundle:nil withCode:scanedCode_];
			[self.navigationController pushViewController:queryViewController animated:YES];
			[queryViewController release];queryViewController = nil;

        }
            break;
            //bulk进度跟踪查询
        case YDNavigationBarViewBulkProgress:
        {
            YDBulkProgressQueryViewController *progress = [[YDBulkProgressQueryViewController alloc] initWithNibName:@"YDBulkProgressQueryViewController" bundle:nil withCode:scanedCode_];
            [self.navigationController pushViewController:progress animated:YES];
            [progress release];progress = nil;

        }
            break;
            //bulk品种跟踪查询
        case YDNavigationBarViewBulkVariety:
        {
//            YDLabQueryDetailViewController *queryViewController = [[YDLabQueryDetailViewController alloc] initWithNibName:@"YDLabQueryDetailViewController" bundle:nil];
//			[self.navigationController pushViewController:queryViewController animated:YES];
//			[queryViewController release];queryViewController = nil;
            YDBulkVarietyQueryViewController *variety = [[YDBulkVarietyQueryViewController alloc] initWithNibName:@"YDBulkVarietyQueryViewController" bundle:nil withCode:scanedCode_];
            [self.navigationController pushViewController:variety animated:YES];
            [variety release];
        }
            break;
            
        default:
            break;
    }

    
    
}

- (IBAction)reScanButtonPress:(id)sender
{

}

@end
