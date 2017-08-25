//
//  ViewController.m
//  HKGDataBaseSaveObject
//
//  Created by ghk on 2017/8/24.
//  Copyright © 2017年 geng hongkai. All rights reserved.
//

#import "ViewController.h"
#import "ZHMyModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    // Do any additional setup after loading the view, typically from a nib.
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
