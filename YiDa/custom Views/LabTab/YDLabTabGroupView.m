//
//  YDLabTabGroupView.m
//  YiDa
//
//  Created by Meson Networks on 12-12-8.
//
//

#import "YDLabTabGroupView.h"

@implementation YDLabTabGroupView

@synthesize groupValue = groupValue_;


- (id)initWithFrame:(CGRect)frame with:(Group_Head *)_groupInfo
{
    self= [super initWithFrame:frame];
    if (self)
    {
//        [self setUpDeepestBackgroup];
        self.groupValue = _groupInfo;
    }
    return self;
}

- (void)dealloc
{
    [groupValue_ release];groupValue_ = nil;
    [super dealloc];
}


- (void)didMoveToSuperview
{
    if (!self.superview) return;
    [self setContentWith:groupValue_];
}

- (void)setContentWith:(Group_Head *)_group
{
    if (_group)
    {
        [self setGroupTitle:_group.titleName];
//        [self.titelLabel setText:[NSString stringWithFormat:@"组合%@",_group.titleName]];
        NSInteger count = [_group.valueAry count];
        [self setColorImages:count];
        if (count)
        {
            NSMutableArray *values = _group.valueAry;
            for (int i = 0; i<count; i++){
            NSString *name = (NSString *)[values objectAtIndex:i];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(68, 50+(20+25)*i, 160, 25)];
            [label setFont:[UIFont systemFontOfSize:13]];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:name];
            [self addSubview:label];
            [label release];label = nil;
            
//            for (int i = 0; i<count; i++)
//            {
//                NSString *name = (NSString *)[values objectAtIndex:i];
//                if (i== 0) [yellowColorLabel_ setText:name];
//                if (i== 1)  [redColorLabel_ setText:name];
//                if (i== 2) [blueColorLabel_ setText:name];
//            }
            }
        }
    }
}

@end
