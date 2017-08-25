//
//  FMDBManager.h
//  Demo-Custom
//
//  Created by ZPP on 2017/3/18.
//  Copyright © 2017年 com.jiutian.com. All rights reserved.
//

#import "FMDatabase.h"

@protocol modelProtocol <NSObject>
/** 唯一标示，比如：uid */
@property (nonatomic, copy) NSString *modelID;

@end

@interface FMDBManager : FMDatabase



+ (instancetype)db;
/**
 创建数据库

 @param model 数据模型
 @return 是否成功
 */
- (BOOL)createWithModel:(id <modelProtocol>) model;
- (BOOL)createWithTableName:(NSString *)tableName;
- (BOOL)createWithModel:(id<modelProtocol>)model withTableName:(NSString *)tableName;
/**
 添加数据
 
 @param model 数据模型对象(必传)
 @return 是否添加成功
 */
- (BOOL)addWithModel:(id <modelProtocol>) model;
/**
 添加数据
 
 @param model 数据模型对象(必传)
 @return 是否添加成功
 */
- (BOOL)removeWithModel:(id <modelProtocol>) model;
/**
 添加数据
 
 @param model 数据模型对象(必传)
 @return 是否添加成功
 */
- (BOOL)updateWithModel:(id <modelProtocol>) model;

/**
 查询所有数据

 @return 查到的数据
 */
- (NSArray <id<modelProtocol>> *)getModelsWithClass:(Class) modelClass;

/**
 分页查询数据

 @param page 页码
 @return 当前页数据
 */
- (NSArray <id<modelProtocol>> *)getModelsWithClass:(Class) modelClass WithPage:(int) page;
@end
