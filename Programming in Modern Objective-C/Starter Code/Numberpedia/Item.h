//
//  Item.h
//  Numberpedia
//
//  Created by Rob Eberhardt on 10/5/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

+ (id)itemWithName:(NSString *)name value:(NSNumber *)value;
- (id)initWithName:(NSString *)name value:(NSNumber *)value;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *value;

@end
