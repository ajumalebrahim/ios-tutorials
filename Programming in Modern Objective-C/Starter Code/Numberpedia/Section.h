//
//  Section.h
//  Numberpedia
//
//  Created by Rob Eberhardt on 10/6/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject

@property (nonatomic, strong, readonly) NSArray *items;

- (id)initWithArray:(NSArray *)array;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

@end
