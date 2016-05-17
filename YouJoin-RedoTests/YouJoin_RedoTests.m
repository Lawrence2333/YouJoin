//
//  YouJoin_RedoTests.m
//  YouJoin-RedoTests
//
//  Created by Lawrence on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YJ_networkTool.h"
@interface YouJoin_RedoTests : XCTestCase

@end

@implementation YouJoin_RedoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
//    [self loginTest];
//    [self getTweetsTest];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[@"0",@"181",@"1"] forKeys:@[@"tweet_id",@"id",@"time"]];
    
    [YJ_networkTool getTweetsWithParams:dict completion:^(NSArray *tweetArray, NSString *resultStr) {
        
        XCTAssert(![resultStr isEqualToString:@"success"],"wrong!");
    }];


    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
-(void)getTweetsTest{
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[@"0",@"181",@"1"] forKeys:@[@"tweet_id",@"id",@"time"]];
    
    [YJ_networkTool getTweetsWithParams:dict completion:^(NSArray *tweetArray, NSString *resultStr) {
        
        XCTAssert([resultStr isEqualToString:@"success"],"wrong!");
    }];
}
-(void)loginTest{
    [YJ_networkTool loginWithUsername:@"yy111" password:@"yy111" completion:^(NSDictionary *resultDict) {
        NSLog(@"result:%@",resultDict);
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
