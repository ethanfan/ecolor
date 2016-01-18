//
//  YDLabTabColorNameRecipe.m
//  YiDa
//
//  Created by Meson Networks on 12-12-8.
//
//

#import "YDLabTabColorNameRecipe.h"

@implementation YDLabTabColorNameRecipe

@synthesize outputState = outputState_;

@synthesize colorViewType = colorViewType_;

@synthesize recipeVale = recipeVale_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)dealloc
{
    [recipeVale_ release];recipeVale_ = nil;
    [super dealloc];
}


- (void)reloadDataWith:(YDLabTabColorNameRecipeState)_viewType
{
    
}

@end
