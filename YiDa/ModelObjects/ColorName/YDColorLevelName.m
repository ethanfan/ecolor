//
//  YDColorLevelName.m
//  YiDa
//
//  Created by Ni on 12-11-23.
//  Copyright 2012 meson.com. All rights reserved.
//

#import "YDColorLevelName.h"


@implementation YDColorLevelName

@synthesize colorLvelName = colorLvelName_;

@synthesize nameState = nameState_; 
@synthesize selected;


- (id)initWith:(NSString *)_name state:(NSInteger )_state
{
	
	if (![_name length]) 
	{
		[NSException raise:@"AttemptToAddInvalidColorLevelName" format:@"Attempted to add an nil color name"];
	
	}
	if (!(_state != 1 || _state != 0)) {
		[NSException raise:@"AttemptToAddInvalidColorLevelNameState" format:@"Attempted to add an invalid state"];

	}
	
	self = [super init];
	if (self)
	{
		self.colorLvelName = _name;
		self.nameState = _state;
		selected = _state;
	}
	return self;
	
}

+ (id)initWith:(NSString *)_name state:(NSInteger )_state
{
	YDColorLevelName *level = [[[self alloc] initWith:_name state:_state] autorelease];
	return level;
}

- (void)dealloc
{
 
	if (colorLvelName_ != nil)
	{
		[colorLvelName_ release];colorLvelName_ = nil;
	}
	[super dealloc];
	
}

@end
