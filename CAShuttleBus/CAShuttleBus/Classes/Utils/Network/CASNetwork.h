//
//  CASNetwork.h
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/28.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef kIsNetwork
#define kIsNetwork     [CASNetwork isNetwork]  // 一次性判断是否有网的宏
#endif

#ifndef kIsWWANNetwork
#define kIsWWANNetwork [CASNetwork isWWANNetwork]  // 一次性判断是否为手机网络的宏
#endif

#ifndef kIsWiFiNetwork
#define kIsWiFiNetwork [CASNetwork isWiFiNetwork]  // 一次性判断是否为WiFi网络的宏
#endif

typedef NS_ENUM(NSInteger, CASNetworkReachabilityStatus) {
    CASNetworkReachabilityStatusUnknown  = -1,
    CASNetworkReachabilityStatusNotReachable = 0,
    CASNetworkReachabilityStatusViaWWAN = 1,
    CASNetworkReachabilityStatusViaWiFi = 2,
};

typedef NS_ENUM(NSUInteger, CASRequestSerializer) {
    CASRequestSerializerHttp,
    CASRequestSerializerJSON
};

typedef NS_ENUM(NSUInteger, CASResponseSerializer) {
    CASResponseSerializerJSON,
    CASResponseSerializerHTTP
};

// 请求成功的Block
//typedef void(^CASHttpRequestSuccess)(id responseObject);
typedef void(^CASHttpRequestSuccess)(id responseObject, REQUEST_RESULT_STATE resultState);


// 请求失败的Block
typedef void(^CASHttpRequestFailed)(NSError *error);

// 缓存的Block
typedef void(^CASHttpRequestCache)(id responseCache);

// 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小
typedef void (^CASHttpProgress)(NSProgress *progress);

// 网络状态的Block
typedef void(^CASNetworkStatus)(CASNetworkReachabilityStatus status);

@class AFHTTPSessionManager;
@interface CASNetwork : NSObject

// 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
+ (void)networkStatusWithBlock:(CASNetworkStatus)networkStatus;

// 有网YES, 无网:NO
+ (BOOL)isNetwork;

// 手机网络:YES, 反之:NO
+ (BOOL)isWWANNetwork;

// WiFi网络:YES, 反之:NO
+ (BOOL)isWiFiNetwork;

// 取消所有HTTP请求
+ (void)cancelAllRequest;

// 取消指定URL的HTTP请求
+ (void)cancelRequestWithURL:(NSString *)URL;

// 开启日志打印 (Debug级别)
+ (void)openLog;

// 关闭日志打印,默认关闭
+ (void)closeLog;

/**
 GET请求,无缓存

 @param URL 请求地址
 @param parameters 请求参数
 @param success 请求成功的回调
 @param failure 请求失败的回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id)parameters
                           success:(CASHttpRequestSuccess)success
                           failure:(CASHttpRequestFailed)failure;

/**
 GET请求,自动缓存

 @param URL 请求地址
 @param parameters 请求参数
 @param responseCache 缓存数据的回调
 @param success 请求成功的回调
 @param failure 请求失败的回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id)parameters
                     responseCache:(CASHttpRequestCache)responseCache
                           success:(CASHttpRequestSuccess)success
                           failure:(CASHttpRequestFailed)failure;

/**
 POST请求,无缓存

 @param URL 请求地址
 @param parameters 请求参数
 @param success 请求成功的回调
 @param failure 请求失败的回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                            success:(CASHttpRequestSuccess)success
                            failure:(CASHttpRequestFailed)failure;

/**
 POST请求,自动缓存

 @param URL 请求地址
 @param parameters 请求参数
 @param responseCache 缓存数据的回调
 @param success 请求成功的回调
 @param failure 请求失败的回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                      responseCache:(CASHttpRequestCache)responseCache
                            success:(CASHttpRequestSuccess)success
                            failure:(CASHttpRequestFailed)failure;

/**
 上传文件

 @param URL 请求地址
 @param parameters 请求参数
 @param name 文件对应服务器上的字段
 @param filePath 文件本地的沙盒路径
 @param progress 上传进度信息
 @param success 请求成功的回调
 @param failure 求失败的回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                                      parameters:(id)parameters
                                            name:(NSString *)name
                                        filePath:(NSString *)filePath
                                        progress:(CASHttpProgress)progress
                                         success:(CASHttpRequestSuccess)success
                                         failure:(CASHttpRequestFailed)failure;

/**
 上传单/多张图片

 @param URL 请求地址
 @param parameters 请求参数
 @param name 图片对应服务器上的字段
 @param images 图片数组
 @param fileNames 图片文件名数组, 可以为nil, 数组内的文件名默认为当前日期时间"yyyyMMddHHmmss"
 @param imageScale 图片文件压缩比 范围 (0.f ~ 1.f)
 @param imageType 图片文件的类型,例:png、jpg(默认类型,由于iPhone手机相册照片格式为.jpg)....
 @param progress 上传进度信息
 @param success 请求成功的回调
 @param failure 请求失败的回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                                        parameters:(id)parameters
                                              name:(NSString *)name
                                            images:(NSArray<UIImage *> *)images
                                         fileNames:(NSArray<NSString *> *)fileNames
                                        imageScale:(CGFloat)imageScale
                                         imageType:(NSString *)imageType
                                          progress:(CASHttpProgress)progress
                                           success:(CASHttpRequestSuccess)success
                                           failure:(CASHttpRequestFailed)failure;

/**
 下载文件

 @param URL 请求地址
 @param fileDir 文件存储目录(默认存储目录为Download)
 @param progress 文件下载的进度信息
 @param success 下载成功的回调(回调参数filePath:文件的路径)
 @param failure 下载失败的回调
 @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(CASHttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(CASHttpRequestFailed)failure;

#pragma mark - 设置AFHTTPSessionManager相关属性
/**
 在开发中,如果以下的设置方式不满足项目的需求,就调用此方法获取AFHTTPSessionManager实例进行自定义设置

 @param sessionManager AFHTTPSessionManager的实例
 */
+ (void)setAFHTTPSessionManagerProperty:(void(^)(AFHTTPSessionManager *sessionManager))sessionManager;

/**
 *  设置网络请求参数的格式:默认为二进制格式
 *
 *  @param requestSerializer CASRequestSerializerHttp(JSON格式),CASRequestSerializerHTTP(二进制格式),
 */
+ (void)setRequestSerializer:(CASRequestSerializer)requestSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializer PPResponseSerializerJSON(JSON格式),PPResponseSerializerHTTP(二进制格式)
 */
+ (void)setResponseSerializer:(CASResponseSerializer)responseSerializer;

/**
 *  设置请求超时时间:默认为30S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

// 设置请求头
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 *  是否打开网络状态转圈菊花:默认打开
 *
 *  @param open YES(打开), NO(关闭)
 */
+ (void)openNetworkActivityIndicator:(BOOL)open;

/**
 配置自建证书的Https请求, 参考链接: http://blog.csdn.net/syg90178aw/article/details/52839103
 
 @param cerPath 自建Https证书的路径
 @param validatesDomainName 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO; 即服务器使用其他可信任机构颁发
 的证书，也可以建立连接，这个非常危险, 建议打开.validatesDomainName=NO, 主要用于这种情况:客户端请求的是子域名, 而证书上的是另外
 一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;

@end
