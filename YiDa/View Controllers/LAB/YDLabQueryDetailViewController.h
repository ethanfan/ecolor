//
//  YDLabQueryDetailViewController.h
//  YiDa
//
//  Created by 罗 祖根 on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

 /*
  Created by lizhang Dong on 12-11-14
  说明：查询的详情界面,配方进度查询
 */

#import <UIKit/UIKit.h>
#import "YDLabQueryTableView.h"
#import "Constants.h"
#import "DataMember.h"
#import "RecipetTraceInfo.h"
#import "DataKit.h"

@interface YDLabQueryDetailViewController : UIViewController<YDLabQueryTableViewDelegate,UITextFieldDelegate>
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
	UILabel			*recipeNumberLabel_;//配方号
	UILabel			*mainInfoLabel_;
    
    NSInteger      currentQueryType;
    
    IBOutlet UILabel         *jihuashazhiLabel_;
    IBOutlet UILabel         *gongyiLabel_;
    IBOutlet UILabel         *jihuapishaLabel_;
    IBOutlet UILabel         *fubanpishaLabel_;
    IBOutlet UILabel         *kaibanshijianLabel_;
    IBOutlet UILabel         *anpaishiliaoLabel_;
    IBOutlet UILabel         *anpaishiliaoMenLabel_;
    IBOutlet UILabel         *chengshaLabel_;
    IBOutlet UILabel         *chengshaMenLabel_;
    IBOutlet UILabel         *jingongshiLabel_;
    IBOutlet UILabel         *jingongMenLabel_;
    IBOutlet UILabel         *jialiaoLabel_;
    IBOutlet UILabel         *jialiaoMenLabel_;
    IBOutlet UILabel         *chugangLabel_;
    IBOutlet UILabel         *chugangMenLabel_;
    IBOutlet UILabel         *songyangLabel_;
    IBOutlet UILabel         *songyangMenLabel_;
    IBOutlet UILabel         *shouyangLabel_;
    IBOutlet UILabel         *shouyangMenLabel_;
    IBOutlet UILabel         *tiaosheshiLabel_;
    
    IBOutlet UILabel         *colorCodeLabel_;
    
    YDLabQueryTableView       *recipeTableView;
    dispatch_queue_t         queryNetworkQueue;
    
    NSString                    *scandedCode_;
    
//    表格上面的四个标题
   IBOutlet  UILabel         *nameLabel_;    //化料名
    IBOutlet UILabel         *nameIdLabel_;    //化料id
    IBOutlet UILabel         *costLabel_;      //单位用量
    IBOutlet UILabel         *unitLabel_;     //单位
    
    
//    datas 
    NSMutableArray          *recipesList_;
}

@property (nonatomic ,retain) IBOutlet  UIImageView *navigationBarImageView;
@property (nonatomic ,retain) IBOutlet  UIImageView *viewTypeImage;
@property (nonatomic ,retain) IBOutlet  UIImageView *userImageView;
@property (nonatomic ,retain) IBOutlet  UIButton    *outputButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *cancelButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *logoutButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *backButton;
@property (nonatomic ,retain) IBOutlet  UIButton    *queryButton;

@property (nonatomic ,copy) NSString  *scandedCode;

@property (nonatomic ,retain) IBOutlet UIScrollView   *informationScrollView;
@property (nonatomic ,retain) IBOutlet UILabel         *colorLabel;  ///色号，缸号
@property (nonatomic ,retain) IBOutlet UITextField         *colorContentLabel;
@property (nonatomic ,retain) IBOutlet UILabel			*recipeNumberLabel;//配方号
@property (nonatomic ,retain) IBOutlet UILabel			*mainInfoLabel;

@property (nonatomic ,retain) NSMutableArray *recipesList;

- (IBAction)backButtonPress:(id)_sender;

- (IBAction)logoutButtonPress:(id)_sender;
- (IBAction)cancelButtonPress:(id)_sender;
- (IBAction)outputButtonPress:(id)_sender;
- (IBAction)queryButtonPress:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil queryType:(NSInteger )_queryType;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
             withCode:(NSString *)_scanedCode;

- (void)reloadRecipesData:(NSMutableArray *)_recipes;

@end
