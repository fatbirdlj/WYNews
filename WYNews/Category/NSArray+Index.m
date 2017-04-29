//
//  NSArray+Index.m
//  WYNews
//
//  Created by 刘江 on 2017/4/26.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "NSArray+Index.h"

@implementation NSArray (Index)

- (NSInteger)indexOfSpecialValue{
    if ([self count] > 2) {
        NSInteger specialValueIndex = [self count]-1;
        for (NSInteger i = [self count] -2; i >= 0; i--) {
            if (self[specialValueIndex] != self[i]) {
                if (specialValueIndex == [self indexOfObject:self[specialValueIndex]])
                    return specialValueIndex;
                else return i;
            }
        }
    }
    return NSNotFound;
}

- (NSInteger)firstIndexOfNormalValue{
    if ([self count] > 2) {
        NSInteger specialValueIndex = [self indexOfSpecialValue];
        if (specialValueIndex == NSNotFound) return 0;
        
        id specialValue = [self objectAtIndex:specialValueIndex];
        __block NSInteger normalValueIndex = 0;
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL *stop) {
            if (obj != specialValue){
                normalValueIndex = idx;
                *stop = YES;
            }
        }];
        return normalValueIndex;
    }
    return NSNotFound;
}

@end
