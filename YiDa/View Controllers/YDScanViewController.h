//
//  YDScanViewController.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

 /*
  Created by lizhang.dong on 12－11－10
  说明，扫描界面，调方／调料等共用
 */
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "Constants.h"

#import "ZBarSDK.h"

@interface YDScanViewController : UIViewController<UITextFieldDelegate,ZBarReaderViewDelegate>
{
    NSInteger currentViewType_;
    
    UIImageView *scanBackgroundView_;
    UIImageView *navigationBarBackgroundView_;
    UIImageView *userTypeImageView_;
    UIImageView  *currentViewImage_;
    UITextField  *codeInputField_;
    UIButton   *confirmButton_;
    UIButton   *reInputButton_;
    UIButton   *backButton_;
    UIButton   *logoutButton_;
    UILabel   *failTipLabe_;
    
    UIImageView *cameraBackgroundView_;
	
	YDUserType  currentUserType_;
    
    SystemSoundID  scanedSound;
    
    NSString     *scanedCode_;
    
    AVAudioPlayer *scanSound_;
}


@property (nonatomic ,assign) NSInteger currentViewType;
@property (nonatomic ,retain) IBOutlet  UIImageView *scanBackgroundView;
@property (nonatomic ,retain) IBOutlet  UIImageView *navigationBarBackgroundView;
@property (nonatomic ,retain) IBOutlet  UIImageView *userTypeImageView;
@property (nonatomic ,retain) UIImageView *currentViewImage;
@property (nonatomic ,retain) IBOutlet UITextField *codeInputField;
@property (nonatomic ,retain) IBOutlet UIButton   *confirmButton;
@property (nonatomic ,retain) IBOutlet UIButton   *reInputButton;
@property (nonatomic ,retain) IBOutlet  UIButton   *backButton;
@property (nonatomic ,retain) IBOutlet  UIButton   *logoutButton;
@property (nonatomic ,retain) IBOutlet  UILabel   *failTipLabel;
@property (nonatomic ,retain) IBOutlet  UIImageView *cameraBackgroundView;

@property (nonatomic ,assign) YDUserType  currentUserType;

@property (nonatomic ,copy) NSString     *scanedCode;


- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
                 view:(NSInteger)_viewType;

- (IBAction)backButtonPress:(id)sender;

- (IBAction)logoutButtonPress:(id)sender;

- (IBAction)confirmButtonPress:(id)sender;

- (IBAction)reScanButtonPress:(id)sender;

@end
