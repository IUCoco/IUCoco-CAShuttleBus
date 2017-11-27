//
//  CASLogTest.m
//  CAShuttleBusTests
//
//  Created by 清风 on 2017/11/27.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CASBaseUnitTest.h"
#import "NSArray+CASLog.h"
#import "NSDictionary+CASLog.h"

@interface CASLogTest : CASBaseUnitTest

@end

@implementation CASLogTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSDictionary *dic = @{
                        @"姓名":@"陈志强",
                        @"年龄":@"18哦"
                        };
    NSLog(@"%@",  [dic descriptionWithLocale:nil]);
    NSArray *arr = @[@"杭州", @"萧山", @"12杭州"];
    NSLog(@"%@",  [arr descriptionWithLocale:nil]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
