
/*
 Created by lizhang Dong on 12-11-19
 说明：Bulk用户组中品种进度查询界面
 update：
 
 */

#import <UIKit/UIKit.h>
#import "YDLabQueryTableView.h"
#import "Constants.h"

@interface YDBulkVarietyQueryViewController : UIViewController<YDLabQueryTableViewDelegate,UITextFieldDelegate>
{
    UIImageView *navigationBarImageView_;
    UIImageView *viewTypeImage_;
    UIImageView *userImageView_;
    UIButton    *outputButton_;
    UIButton    *cancelButton_;
    UIButton    *logoutButton_;
    UIButton    *backButton_;
    
    UIButton    *queryButton_;
    
    NSInteger first;
	UIScrollView	*informationScrollView_;
	UILabel         *colorLabel_;  ///色号，缸号
	UITextField         *colorContentLabel_;
	UILabel			*recipeNumberLabel_;//大货交期
	UILabel			*mainInfoLabel_;
    
//    表格中有18列 需要有十八个宽度
    CGFloat column1;
    CGFloat column2;
    CGFloat column3;
    CGFloat column4;
    CGFloat column5;
    CGFloat column6;
    CGFloat column7;
    CGFloat column8;
    CGFloat column9;
    CGFloat column10;
    CGFloat column11;
    CGFloat column12;
    CGFloat column13;
    CGFloat column14;
    CGFloat column15;
    CGFloat column16;
    CGFloat column17;
    CGFloat column18;
    
    
    
    IBOutlet UILabel         *ranshaLabel_;
    IBOutlet UILabel         *jingweiLabel_;
    IBOutlet UILabel         *gangxingLabel_;
    IBOutlet UILabel         *jitaiLabel_;
    IBOutlet UILabel         *ganghaoLabel_;
    IBOutlet UILabel         *sehaoLabel_;
    IBOutlet UILabel         *zhuangtaiLabel_;
    IBOutlet UILabel         *yubiLabel_;
    IBOutlet UILabel         *fubanLabel_;
    IBOutlet UILabel         *touranLabel_;
    IBOutlet UILabel         *touranNumLabel_;
    IBOutlet UILabel         *tongziLabel_;
    IBOutlet UILabel         *neiduiseLabel_;
    IBOutlet UILabel         *duisejielunLabel_;
    IBOutlet UILabel         *pinmingLabel_;
    IBOutlet UILabel         *shapiLabel_;
    IBOutlet UILabel         *QCjielunLabel_;
 
    YDLabQueryTableView *tableView_;
    
    NSString    *scanedCode_;
    
//    大货交期列表
    NSMutableArray  *recipesList_;
//    数据列表
    NSMutableArray  *datasList_;
    dispatch_queue_t         queryNetworkQueue;
}

@property (nonatomic ,retain) IBOutlet  UIImageView *navigationBarImageView;
@property (nonatomic ,retain) IBOutlet  UIImageView *viewTypeImage;
@property (nonatomic ,retain) IBOutlet  UIImageView *userImageView;
@property (nonatomic ,retain) IBOutlet  UIButton    *outputButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *cancelButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *logoutButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *backButton;

@property (nonatomic ,retain) IBOutlet  UIButton    *queryButton;

@property (nonatomic ,retain) YDLabQueryTableView *tableView;

@property (nonatomic ,retain) IBOutlet UIScrollView   *informationScrollView;
@property (nonatomic ,retain) IBOutlet UILabel         *colorLabel;  ///色号，缸号
@property (nonatomic ,retain) IBOutlet UITextField         *colorContentLabel;
@property (nonatomic ,retain) IBOutlet UILabel			*recipeNumberLabel;//配方号
@property (nonatomic ,retain) IBOutlet UILabel			*mainInfoLabel;

@property (nonatomic ,copy) NSString  *scanedCode;

- (IBAction)backButtonPress:(id)_sender;

- (IBAction)logoutButtonPress:(id)_sender;
- (IBAction)cancelButtonPress:(id)_sender;
- (IBAction)outputButtonPress:(id)_sender;

- (IBAction)queryButtonPress:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode;

- (void)reloadRecipesData:(NSMutableArray *)_recipes;
@end
