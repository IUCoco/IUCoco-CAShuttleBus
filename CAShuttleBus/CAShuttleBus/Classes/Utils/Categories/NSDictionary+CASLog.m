//
//  NSDictionary+CASLog.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/27.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "NSDictionary+CASLog.h"

@implementation NSDictionary (CASLog)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *mStr = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [mStr appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    [mStr appendString:@"}"];
    NSRange range = [mStr rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound){
        [mStr deleteCharactersInRange:range];
    }
    return mStr;
}

@end
