//
//  CASBaseUnitTest.h
//  CAShuttleBusTests
//
//  Created by 清风 on 2017/11/24.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import <XCTest/XCTest.h>

#define CASAssertTrue(expr)              XCTAssertTrue((expr), @"")
#define CASAssertFalse(expr)             XCTAssertFalse((expr), @"")
#define CASAssertNil(a1)                 XCTAssertNil((a1), @"")
#define CASAssertNotNil(a1)              XCTAssertNotNil((a1), @"")
#define CASAssertEqual(a1, a2)           XCTAssertEqual((a1), (a2), @"")
#define CASAssertEqualObjects(a1, a2)    XCTAssertEqualObjects((a1), (a2), @"")
#define CASAssertNotEqual(a1, a2)        XCTAssertNotEqual((a1), (a2), @"")
#define CASAssertNotEqualObjects(a1, a2) XCTAssertNotEqualObjects((a1), (a2), @"")
#define CASAssertAccuracy(a1, a2, acc)   XCTAssertEqualWithAccuracy((a1),(a2),(acc))

#define WAIT                                                                \
do {                                                                        \
[self expectationForNotification:@"LCUnitTest" object:nil handler:nil]; \
[self waitForExpectationsWithTimeout:60 handler:nil];                   \
} while(0);

#define NOTIFY                                                                            \
do {                                                                                      \
[[NSNotificationCenter defaultCenter] postNotificationName:@"LCUnitTest" object:nil]; \
} while(0);

@interface CASBaseUnitTest : XCTestCase

@end
