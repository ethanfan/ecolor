 


/*Created by lizhang Dong on 12-11-20
 说明:色级名字
 update:
 
 */

#import <Foundation/Foundation.h>
#import "YDLabTabColorNameRecipe.h"


@interface YDColorLevelName : NSObject {

	NSString *colorLvelName_;
	
	NSInteger nameState_;   //0代表未标记，1代表已标记
	
	BOOL  selected;
}
@property (nonatomic ,retain) NSString *colorLvelName;
@property (nonatomic ,assign) NSInteger nameState;


@property (nonatomic ,getter = isSelected) BOOL   selected;

- (id)initWith:(NSString *)_name state:(NSInteger )_state;

+ (id)initWith:(NSString *)_name state:(NSInteger )_state;

@end
