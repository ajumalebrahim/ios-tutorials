//
//  DataModel.h
//  Numberpedia
//
//  Created by Rob Eberhardt on 10/6/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, strong, readonly) NSArray *sortedSectionNames;
@property (nonatomic, strong, readonly) NSArray *sortedItems;

- (void)sortByValue;
- (void)clearSortedItems;

- (id)objectForKeyedSubscript:(id)key;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

@end
