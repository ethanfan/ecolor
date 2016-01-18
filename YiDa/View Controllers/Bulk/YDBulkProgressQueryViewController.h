/*
 Created by lizhang Dong on 12-11-19
 说明：Bulk用户组中进度跟踪查询界面
 update：
 
 */

#import <UIKit/UIKit.h>
#import "YDLabQueryTableView.h"
#import "Constants.h"

@interface YDBulkProgressQueryViewController : UIViewController<YDLabQueryTableViewDelegate,UITextFieldDelegate>
{

    UIImageView *navigationBarImageView_;
    UIImageView *viewTypeImage_;
    UIImageView *userImageView_;
    UIButton    *outputButton_;
    UIButton    *cancelButton_;
    UIButton    *logoutButton_;
    UIButton    *backButton_;
    
    UIButton   *queryButton_;
    
    
    UIScrollView	*informationScrollView_;
	UILabel         *colorLabel_;  ///色号，缸号
	UITextField         *colorContentLabel_;
	UILabel			*recipeNumberLabel_;//配方号
	UILabel			*mainInfoLabel_;
    
    
    IBOutlet UILabel         *ganghaoLabel_;
    IBOutlet UILabel         *sehaoLabel_;
    IBOutlet UILabel         *shazhiLabel_;
    IBOutlet UILabel         *gangxingLabel_;
    IBOutlet UILabel         *jitaiLabel_;
    IBOutlet UILabel         *shaleiLabel_;
    IBOutlet UILabel         *jingangshijianLabel_;
    IBOutlet UILabel         *shapiLabel_;
    IBOutlet UILabel         *fubanOKshijianLabel_;
    IBOutlet UILabel         *duisheLabel_;
    IBOutlet UILabel         *chugangLabel_;
    IBOutlet UILabel         *hongganLabel_;
    IBOutlet UILabel         *songQCLabel_;
    IBOutlet UILabel         *diyiciLabel_;  //第一次进缸时间
    IBOutlet UILabel         *QCLabel_;    //qc备注
    IBOutlet UILabel         *beizhuLabel_;
    
    
    IBOutlet UILabel        *artCommentLabel_;
    
    //明细信息
    IBOutlet UILabel         *detailTipLabel_;
    IBOutlet UILabel         *dGanghaoLabel_;
    IBOutlet UILabel         *paidanLabel_;
    IBOutlet UILabel         *pinmingIDLabel_;
    IBOutlet  UILabel         *jingWLabel_;    //经向weight
    IBOutlet UILabel         *weiWLabel_;    //
    IBOutlet UILabel         *yuanshaLabel_;      //
    IBOutlet UILabel         *touranLabel_;     //
    
    YDLabQueryTableView *recipesTable;
    
    NSString    *scandedCode_;
    
    NSMutableArray  *recipesList_;
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

@property (nonatomic ,retain) IBOutlet UIScrollView   *informationScrollView;
@property (nonatomic ,retain) IBOutlet UILabel         *colorLabel;  ///色号，缸号
@property (nonatomic ,retain) IBOutlet UITextField         *colorContentLabel;
@property (nonatomic ,retain) IBOutlet UILabel			*recipeNumberLabel;//配方号
@property (nonatomic ,retain) IBOutlet UILabel			*mainInfoLabel;

@property (nonatomic ,copy) NSString *scandedCode;
@property (nonatomic ,retain) NSMutableArray *recipesList;

- (IBAction)backButtonPress:(id)_sender;
- (IBAction)logoutButtonPress:(id)_sender;
- (IBAction)cancelButtonPress:(id)_sender;
- (IBAction)outputButtonPress:(id)_sender;
- (IBAction)queryButtonPress:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCode:(NSString *)_scanedCode;

- (void)reloadRecipesData:(NSMutableArray *)_recipes;

@end
