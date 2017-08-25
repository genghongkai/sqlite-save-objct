//
//  ZHMyModel.h
//  ZHFinance
//
//  Created by 耿宏凯 on 2017/8/23.
//  Copyright © 2017年 com.jiutian.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBManager.h"

@interface ZHMyModel : NSObject <modelProtocol>

@property (nonatomic, copy) NSString *modelID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) float height;

@property (nonatomic, copy) NSNumber *number;

@property (nonatomic, assign) NSInteger age;

@end
