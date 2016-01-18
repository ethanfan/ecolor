//
//  YDBulkPalettesView.h
//  YiDa
//
//  Created by Ni on 12-11-15.
//  Copyright 2012 meson.com. All rights reserved.
//

 /*
  Created by lizhang Dong on 12-11-15
  说明：bulk用户组中的调方界面中缸号和品名选择的界面
 */

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "YDPopoverViewController.h"
#import "DataKit.h"
#import "DataMember.h"

@protocol YDBulkPalettesViewDelegate <NSObject>

@optional
- (void)didFinishQueryBatchInfo:(NSString *)_colorCode withRato:(NSString *)_rato firstDye:(NSString *)_dye;

@end

@interface YDBulkPalettesView : UIView <UIPopoverControllerDelegate,YDPopoverViewDelegate>
{
	//content
	IBOutlet UILabel *sehaoLabel_;
	IBOutlet UILabel *pishaLabel_;
	IBOutlet UILabel *gangxingLabel_;
	IBOutlet UILabel *yubiLabel_;
	IBOutlet UILabel *weightLabel_;
	IBOutlet UILabel *colorLabel_;
	IBOutlet UILabel *so4Label_;
	IBOutlet UILabel *co3Label_;
	IBOutlet UILabel *dateLabel_;
	IBOutlet UILabel *clearLabel_;
	IBOutlet UILabel *clientLabel_;
	IBOutlet UILabel *backupLabel_;  //工艺备注
	IBOutlet UILabel *computerLabel_;
    IBOutlet UILabel *batchLabel_;
	
	//tip
	IBOutlet UILabel *sehaoLabelTip_;
	IBOutlet UILabel *pishaLabelTip_;
	IBOutlet UILabel *gangxingLabelTip_;
	IBOutlet UILabel *yubiLabelTip_;
	IBOutlet UILabel *weightLabelTip_;
	IBOutlet UILabel *colorLabelTip_;
	IBOutlet UILabel *so4LabelTip_;
	IBOutlet UILabel *co3LabelTip_;
	IBOutlet UILabel *dateLabelTip_;
	IBOutlet UILabel *clearLabelTip_;
	IBOutlet UILabel *clientLabelTip_;
	IBOutlet UILabel *backupLabelTip_;  //工艺备注
	IBOutlet UILabel *computerLabelTip_;
    
    IBOutlet UILabel *batchTip_;
	
	IBOutlet UIButton *ganghaoButton_;
	IBOutlet UIButton *pinmingButton_;
	
	
	IBOutlet UIImageView *image1_;
	IBOutlet UIImageView *image2_;
	IBOutlet UIImageView *image3_;
	IBOutlet UIImageView *image4_;
	IBOutlet UIImageView *image5_;
	IBOutlet UIImageView *image6_;
	IBOutlet UIImageView *image7_;
	IBOutlet UIImageView *image8_;
	IBOutlet UIImageView *image9_;
	IBOutlet UIImageView *image10_;
	IBOutlet UIImageView *image11_;
	IBOutlet UIImageView *image12_;
	IBOutlet UIImageView *image13_;
    IBOutlet UIImageView *image14_;
	
	UIView  *containerView_;
	
	UIPopoverController *popover;
	YDPopoverTargetTypeOption popoverTargetType_;

    NSString    *scanedCode_;
//    色号和浴比
    NSString    *colorCode_;
    NSString    *ratio_;
//    是否染棉
    NSString    *firsDyeCotton_;
    NSMutableArray      *pinmingList_;
    
    id<YDBulkPalettesViewDelegate>delegate;
    dispatch_queue_t bulkPalettesQueue;
	
}

@property (nonatomic, retain) UIView *containerView;

@property (nonatomic ,assign) id<YDBulkPalettesViewDelegate> delegate;

@property (nonatomic ,copy) NSString *scanedCode;
@property (nonatomic ,copy) NSString *colorCode;
@property (nonatomic ,copy) NSString *ratio;
@property (nonatomic ,copy) NSString    *firsDyeCotton;

- (id)initWithFrame:(CGRect)frame withCode:(NSString *)_scanedCode;
- (IBAction)ganghaoButton:(UIButton *)_sender;
- (IBAction)pingmingButton:(UIButton *)_sender;

- (void)reloadDatas;

@end
