//
//  NSDictionary+MutableCopy.m
//  Anyview
//
//  Created by zzk on 14-10-16.
//  Copyright (c) 2014年 Anyview Team. All rights reserved.
//

#import "NSDictionary+MutableCopy.h"

@implementation NSDictionary (MutableCopy)
- (NSMutableDictionary *) mutableDeepCopy {
    NSMutableDictionary * returnDict = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    NSArray * keys = [self allKeys];
    
    for(id key in keys) {
        id oneValue = [self objectForKey:key];
        id oneCopy = nil;
        if (oneValue) {
            if ([oneValue isKindOfClass:[NSDictionary class]]) {
                oneCopy = [oneValue mutableDeepCopy];
            }else{
                oneCopy = oneValue;
            }
        }
        [returnDict setValue:oneCopy forKey:key];
    }
    return returnDict;
}
@end
