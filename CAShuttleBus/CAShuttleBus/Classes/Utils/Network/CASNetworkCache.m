//
//  CASNetworkCache.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/28.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "CASNetworkCache.h"
#import <YYCache.h>

static NSString *const kCASNetworkCacheName = @"kCASNetworkCacheName";

@implementation CASNetworkCache
static YYCache *_dataCache;

/**
 创建子类对象时，首先要创建父类对象，所以会调用一次父类的initialize方法，然后创建子类时，尽管自己没有实现initialize方法，但还是会调用到父类的方法。
 */
+ (void)initialize {
    if (self == [CASNetworkCache class]) {//防止子类调用自己的initialize方法
        _dataCache = [YYCache cacheWithName:kCASNetworkCacheName];
    }
}

+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(id)parameters {
    NSString *cacheMD5Key = [self cacheMD5KeyWithURL:URL parameters:parameters];
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:httpData forKey:cacheMD5Key withBlock:nil];
}

+ (id)httpCacheForURL:(NSString *)URL parameters:(id)parameters {
    NSString *cacheMD5Key = [self cacheMD5KeyWithURL:URL parameters:parameters];
    //同步读取
    return [_dataCache objectForKey:cacheMD5Key];
}

+ (NSInteger)getAllHttpCacheSize {
    return [_dataCache.diskCache totalCost];

}

+ (void)removeAllHttpCache {
    [_dataCache.diskCache removeAllObjects];
}

#pragma mark - 私有方法
/**
 key中结合parameters原因：
 如果params中是分页的数据，每次请求url是一样的，但是params中的分页page不一样
 这时候如果不联合url和params一起判断，取缓存就取错了
 @param URL 请求URL地址
 @param parameters 请求参数
 @return 返回URL与parameters结合的MD5 NSString
 */
+ (NSString *)cacheMD5KeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    if (!parameters || parameters.count == 0) {return URL;};//没有参数就只用url
    NSData *strData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paramsStr = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    NSString *combinationStr = [NSString stringWithFormat:@"%@%@", URL, paramsStr];
    return [combinationStr md5String];
}

@end
