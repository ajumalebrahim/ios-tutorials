//
//  Item.m
//  Numberpedia
//
//  Created by Rob Eberhardt on 10/5/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Item.h"

@implementation Item

+ (id)itemWithName:(NSString *)name value:(NSNumber *)value
{
	return [[self alloc] initWithName:name value:value];
}

- (id)initWithName:(NSString *)name value:(NSNumber *)value
{
	if ((self = [super init]))
	{
		_name = name;
		_value = value;
	}
	
	return self;
}

- (NSComparisonResult)compare:(Item *)otherItem
{
	return [self.value compare:otherItem.value];
}

@end
