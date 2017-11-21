//
//  CASKeychainWrapper.h
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/21.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CASKeychainWrapper : NSObject

@property (nonatomic, copy)NSString *service;
@property (nonatomic, copy)NSString *account;
@property (nonatomic, copy)NSString *accessGroup;

/**
 初始化方法
 
 @param service 服务
 @param account 账号
 @param accessGroup 可以在应用之间共享keychain中的数据
 @return instancetype
 */
- (instancetype)initWithSevice:(NSString *)service account :(NSString *)account accessGroup:(NSString *)accessGroup;

- (void)savePassword:(NSString *)password;
- (BOOL)deleteItem;

/**
 读取原始密码
 
 @return 返回原始密码
 */
- (NSString *)readPassword;

/**
 返回所有的Keychain

 @param service 服务
 @param accessGroup 可以在应用之间共享keychain中的数据
 @return 所有的Keychain
 */
+ (NSArray *)passwordItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup;



/*!
 关于 query 与 attributesToUpdate 的解释
 
 @param query:
             A dictionary containing an item class specification and
 optional attributes for controlling the search. See the "Attribute
 Constants" and "Search Constants" sections for a description of
 currently defined search attributes.
 
 @param attributesToUpdate:
                           A dictionary containing one or more attributes
 whose values should be set to the ones specified. Only real keychain
 attributes are permitted in this dictionary (no "meta" attributes are
 allowed.) See the "Attribute Key Constants" section for a description of
 currently defined value attributes.
 
 @discussion Attributes defining a search are specified by adding key/value
 pairs to the query dictionary.
 */
//OSStatus SecItemUpdate(CFDictionaryRef query, CFDictionaryRef attributesToUpdate)




@end
