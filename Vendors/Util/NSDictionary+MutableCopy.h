//
//  NSDictionary+MutableCopy.h
//  Anyview
//
//  Created by zzk on 14-10-16.
//  Copyright (c) 2014年 Anyview Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MutableCopy)
- (NSMutableDictionary *)mutableDeepCopy;
@end
