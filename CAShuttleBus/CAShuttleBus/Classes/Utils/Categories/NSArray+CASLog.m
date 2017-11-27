//
//  NSArray+CASLog.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/27.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "NSArray+CASLog.h"

@implementation NSArray (CASLog)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *mStr = [NSMutableString stringWithString:@"[\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mStr appendFormat:@"\t%@,\n", obj];
    }];
    [mStr appendString:@"]"];
    NSRange range = [mStr rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound){
        [mStr deleteCharactersInRange:range];
    }
    return mStr;
}

@end
