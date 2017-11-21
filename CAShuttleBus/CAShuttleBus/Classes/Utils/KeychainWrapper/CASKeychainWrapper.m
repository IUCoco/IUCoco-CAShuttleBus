//
//  CASKeychainWrapper.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/21.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "CASKeychainWrapper.h"
#import <Security/Security.h>

@interface CASKeychainWrapper ()

@end

@implementation CASKeychainWrapper

- (instancetype)initWithSevice:(NSString *)service account :(NSString *)account accessGroup:(NSString *)accessGroup {
    if (self = [super init]) {
        _service = service;
        _account = account;
        _accessGroup = accessGroup;
    }
    return self;
}

- (void)savePassword:(NSString *)password {
    NSData *encodePasswordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    // if password was existed, update
    NSString *originPassword = [self readPassword];
    
    if (originPassword.length > 0) {
        NSMutableDictionary *updateAttributes = [NSMutableDictionary dictionary];
        updateAttributes[(__bridge id)kSecValueData] = encodePasswordData;
        
        NSMutableDictionary *query = [self keychainQueryWithService:_service account:_account accessGroup:_accessGroup];
        OSStatus statusCode = SecItemUpdate(
                                            (__bridge CFDictionaryRef)query,
                                            (__bridge CFDictionaryRef)updateAttributes);
        NSAssert(statusCode == noErr, @"Couldn't update the Keychain Item." );
    }else{
        // else , add
        NSMutableDictionary *attributes = [self keychainQueryWithService:_service account:_account accessGroup:_accessGroup];
        attributes[(__bridge id)kSecValueData] = encodePasswordData;
        //添加
        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
        
        NSAssert(status == noErr, @"Couldn't add the Keychain Item.");
    }
}

- (NSString *)readPassword {
    NSMutableDictionary *attributes = [self keychainQueryWithService:_service account:_account accessGroup:_accessGroup];
    attributes[(__bridge id)kSecMatchLimit] = (__bridge id)(kSecMatchLimitOne);
    attributes[(__bridge id)kSecReturnAttributes] = (__bridge id _Nullable)(kCFBooleanTrue);
    attributes[(__bridge id)kSecReturnData] = (__bridge id _Nullable)(kCFBooleanTrue);
    
    CFMutableDictionaryRef queryResult = nil;
    OSStatus keychainError = noErr;
    //查询
    keychainError = SecItemCopyMatching((__bridge CFDictionaryRef)attributes,(CFTypeRef *)&queryResult);
    if (keychainError == errSecItemNotFound) {
        if (queryResult) CFRelease(queryResult);
        return nil;
    }else if (keychainError == noErr) {
        
        if (queryResult == nil){return nil;}
        
        NSMutableDictionary *resultDict = (__bridge NSMutableDictionary *)queryResult;
        NSData *passwordData = resultDict[(__bridge id)kSecValueData];
        
        NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        
        return password;
    }else
    {
        NSAssert(NO, @"Serious error.\n");
        if (queryResult) CFRelease(queryResult);
    }
    
    return nil;
}

/**
 查询指定account的Keychain字典

 @param service 服务
 @param account 账号
 @param accessGroup 可以在应用之间共享keychain中的数据
 @return return key/value pairs to the query dictionary
 */
- (NSMutableDictionary *)keychainQueryWithService:(NSString *)service account:(NSString *)account accessGroup:(NSString *)accessGroup {
    
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    
    query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    
    query[(__bridge id)kSecAttrService] = service;
    
    query[(__bridge id)kSecAttrAccount] = account;
    
    query[(__bridge id)kSecAttrAccessGroup] = accessGroup;
    
    return query;
}

+ (NSArray *)passwordItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup {
    NSMutableDictionary *query = [[[self alloc]init] keychainQueryWithService:service account:nil accessGroup:accessGroup];
    
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitAll;
    query[(__bridge id)kSecReturnAttributes] = (__bridge id _Nullable)(kCFBooleanTrue);
    query[(__bridge id)kSecReturnData] = (__bridge id _Nullable)(kCFBooleanFalse);
    
    CFMutableArrayRef queryResult = nil;
    OSStatus status = noErr;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query,(CFTypeRef *)&queryResult);
    
    if (status == errSecItemNotFound) {
        return @[];
    }else if (status == noErr) {
        
        NSArray<NSDictionary *> *resultArray = (__bridge NSArray<NSDictionary *> *)queryResult;
        
        if (resultArray.count == 0){return @[];}
        
        NSMutableArray *passwordItems = [NSMutableArray array];
        
        for (NSDictionary *result in resultArray) {
            NSString *acount = result[(__bridge id)kSecAttrAccount];
            
            if (acount.length > 0) {
                CASKeychainWrapper *item = [[CASKeychainWrapper alloc] initWithSevice:service account:acount accessGroup:accessGroup];
                [passwordItems addObject:item];
            }
        }
        
        return passwordItems;
    }else {
        NSAssert(NO, @"Serious error.\n");
        if (queryResult) CFRelease(queryResult);
        return @[];
    }
}

- (BOOL)deleteItem {
    // Delete the existing item from the keychain.
    NSMutableDictionary *query = [self keychainQueryWithService:self.service account:self.account accessGroup:self.accessGroup];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    
    if (status != noErr && status != errSecItemNotFound) {
        return NO;
    }
    return true;
}

@end
