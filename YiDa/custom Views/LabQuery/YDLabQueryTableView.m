//
//  YDLabQueryTableView.m
//  YiDa
//
//  Created by Ni on 12-11-15.
//  Copyright 2012 meson.com. All rights reserved.
//

#import "YDLabQueryTableView.h"

@interface YDLabQueryTableView ()

- (void)setUptableView;

@end



@implementation YDLabQueryTableView

@synthesize recipeTableView = recipeTableView_;

@synthesize delegate;
@synthesize progress;

@synthesize datas =datas_;
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        progress = NO;
		[self setUptableView];
		[self setBackgroundColor:[UIColor colorWithRed:188/255.0 green:181/255.0 blue:165.0/255. alpha:1.0]];
    }
    return self;
}

- (void)setUptableView
{
	UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
	[tableView setBackgroundColor:[UIColor clearColor]];
	tableView.dataSource = self;
	tableView.delegate = self;
	self.recipeTableView = tableView;
	[tableView release];
	
	[self addSubview:recipeTableView_];
}


- (void)reloadTableData:(NSMutableArray *)_datas
{
    self.datas = _datas;
    [recipeTableView_ reloadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [datas_ count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *myCell = @"cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
	if (cell == nil)
	{
//        if (progress) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myCell] autorelease];
//        }
//        else {
//            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell] autorelease];
//        }
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 24, 110, 24)];
        [label setTextAlignment:UITextAlignmentRight];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setFont:[UIFont systemFontOfSize:11]];
		label.tag = 10000;
		[[cell contentView] addSubview:label];
		[label release];
		        
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell.detailTextLabel setTextAlignment:UITextAlignmentRight];
	}
	[cell.textLabel setTextAlignment:UITextAlignmentCenter];
//	cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
	[cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    
    if (indexPath.row < [datas_ count])
    {
        id object = [datas_ objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[YDRecipeForIndex class]])
        {
            YDRecipeForIndex *recipe = (YDRecipeForIndex *)[datas_ objectAtIndex:indexPath.row];
            //        cell.textLabel.text = [datas_ objectAtIndex:indexPath.row];
            cell.textLabel.text = recipe.recipeNO;
//            if (progress)
//            {
                UILabel *l = (UILabel *)[cell viewWithTag:10000];
                if (l)
                {
                    [l setText:recipe.remark];
                }
//            }
        }
        else {
//            如果是大货交期就直接取出日期来
            cell.textLabel.text = [datas_ objectAtIndex:indexPath.row];
        }
        
    }
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (delegate != nil && [delegate respondsToSelector:@selector(queryTabelView:didSelectRow:)])
//    {
//        [delegate queryTabelView:self didSelectRow:indexPath.row];
//    }
    NSString *recipeNo = nil;
    id object = [datas_ objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[YDRecipeForIndex class]])
    {
        YDRecipeForIndex *recipe = (YDRecipeForIndex *)[datas_ objectAtIndex:indexPath.row];
        recipeNo = recipe.recipeNO;
            }
    else {
        //            如果是大货交期就直接取出日期来
        recipeNo = [datas_ objectAtIndex:indexPath.row];
    }
    

    
    if (delegate != nil && [delegate respondsToSelector:@selector(queryTabelView:didSelectRow:withRecipe:)])
    {
        [delegate queryTabelView:self didSelectRow:indexPath.row withRecipe:recipeNo];
    }
}

- (void)dealloc {
	[recipeTableView_ release];recipeTableView_ = nil;
    [datas_ release];datas_ = nil;
    [super dealloc];
}


@end
