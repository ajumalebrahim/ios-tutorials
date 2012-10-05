//
//  NSDictionary+RWFlatten.m
//  Numberpedia
//
//  Created by Rob Eberhardt on 10/4/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "NSDictionary+RWFlatten.h"

@implementation NSDictionary (RWFlatten)

- (NSArray *)rw_flattenIntoArray
{
	NSMutableArray *allValues = [NSMutableArray arrayWithCapacity:[self count]];
	
	[self enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *array, BOOL *stop) {
		[allValues addObjectsFromArray:array];
	}];
	
	return allValues;
}

@end
