//
//  HKGDataBaseSaveObjectTests.m
//  HKGDataBaseSaveObjectTests
//
//  Created by ghk on 2017/8/24.
//  Copyright © 2017年 geng hongkai. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZHMyModel.h"

@interface HKGDataBaseSaveObjectTests : XCTestCase

@end

@implementation HKGDataBaseSaveObjectTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//插入数据测试
- (void)testFMDBInsertData
{
    ZHMyModel *baseModel = [[ZHMyModel alloc] init];
    [[FMDBManager db] createWithModel:baseModel];
    for (NSInteger i=0; i<20; i++)
    {
        ZHMyModel *model = [[ZHMyModel alloc] init];
        model.modelID = [NSString stringWithFormat:@"11%zi",i];
        model.name = [NSString stringWithFormat:@"小红%zi",i];
        model.message = @"莎莎";
        model.code = @"10001";
        BOOL insert = [[FMDBManager db] addWithModel:model];
        NSLog(@"insert : %d",insert);
        
    }
}
//更新数据测试
- (void)testFMDBUpdateData
{
    for (NSInteger i=0; i<20; i++)
    {
        ZHMyModel *model = [[ZHMyModel alloc] init];
        model.modelID = [NSString stringWithFormat:@"11%zi",i];
        model.name = [NSString stringWithFormat:@"小红%zi",i];
        model.message = [NSString stringWithFormat:@"莎莎%zi",i];
        model.code = @"10001";
        BOOL update = [[FMDBManager db] updateWithModel:model];
        NSLog(@"update : %d",update);
    }
}
//删除数据测试
- (void)testFMDBRemoveData
{
    for (NSInteger i=0; i<20; i++) {
        ZHMyModel *model = [[ZHMyModel alloc] init];
        model.modelID = [NSString stringWithFormat:@"11%zi",i];
        BOOL delete = [[FMDBManager db] removeWithModel:model];
        NSLog(@"delete : %d",delete);
    }
    ZHMyModel *model = [[ZHMyModel alloc] init];
    model.modelID = @"233333";
    [[FMDBManager db] removeWithModel:model];
}

//查询数据测试
- (void)testFMDBGetData
{
    NSArray *arr = [[FMDBManager db] getModelsWithClass:[ZHMyModel class]];
    for (ZHMyModel *model in arr) {
        NSLog(@"model.name=%@",model.name);
        NSLog(@"model.message=%@",model.message);
    }
}


- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
