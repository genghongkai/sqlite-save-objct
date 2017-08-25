# sqlite-save-objct
数据库存储OC对象
************************************************************************************
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 注意: 本人对 MJExtension 框架 和 FMDB 框架有修改代码,用原生的框架会崩溃!!!!!!!!!!!
*
* * * MJExtension 框架修改地方如下：

* #pragma mark - --公共方法--
+ (void)mj_enumerateProperties:(MJPropertiesEnumeration)enumeration
{
    // 获得成员变量
    NSArray *cachedProperties = [self properties];
    
    // 遍历成员变量
    BOOL stop = NO;
    for (MJProperty *property in cachedProperties) {
        
#warning 防止遍历到当前类的父类属性，@"hash" 属性是NSObject 中的。
        if (!property.type.typeClass && [property.name isEqualToString:@"hash"]) break;
        
        enumeration(property, &stop);
        if (stop) break;
    }
}    
*
* * * FMDB 框架修改如下：
*
*#pragma mark Execute updates

- (BOOL)executeUpdate:(NSString*)sql error:(NSError**)outErr withArgumentsInArray:(NSArray*)arrayArgs orDictionary:(NSDictionary *)dictionaryArgs orVAList:(va_list)args {
    
    if (![self databaseExists]) {
        return NO;
    }
    
    if (_isExecutingStatement) {
        [self warnInUse];
        return NO;
    }
    
    _isExecutingStatement = YES;
    
    int rc                   = 0x00;
    sqlite3_stmt *pStmt      = 0x00;
    FMStatement *cachedStmt  = 0x00;
    
    if (_traceExecution && sql) {
        NSLog(@"%@ executeUpdate: %@", self, sql);
    }
    //**************************************************************
#warning 对sql语句的修改，为了在数据库中插入模型
    if ([sql containsString:@"INTO ?"]) {
        NSMutableString *muSql = [NSMutableString stringWithString:sql];
        NSString *tableName = [NSString stringWithFormat:@"INTO %@",arrayArgs[0]];
       sql = [muSql stringByReplacingOccurrencesOfString:@"INTO ?" withString:tableName];
        NSMutableArray *muArgs = [NSMutableArray arrayWithArray:arrayArgs];
        [muArgs removeObjectAtIndex:0];
        arrayArgs = [muArgs copy];
    }
    
    if (_shouldCacheStatements) {
        cachedStmt = [self cachedStatementForQuery:sql];
        pStmt = cachedStmt ? [cachedStmt statement] : 0x00;
        [cachedStmt reset];
    }
    
*
*
**************************************************************************************
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
************************************************************************
#import "ZHMyModel.h"
#import "MJExtension.h"

@implementation ZHMyModel

@synthesize modelID=_modelID;


MJCodingImplementation


@end


#import "FMDatabase.h"

/*协议*/
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

//
//  FMDBManager.m
//  Demo-Custom
//
//  Created by ZPP on 2017/3/18.
//  Copyright © 2017年 com.jiutian.com. All rights reserved.
//

#import "FMDBManager.h"
#import "TransformDictModel.h"
#import <objc/runtime.h>
static FMDBManager *_db;
static FMDBManager *_userDB;
/**
 获取默认缓存路径(内敛函数，函数调用更快)

 @return 默认路径
 */
static inline NSString * defaultCachePath()
{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] copy];
}
/**
 获取默认路径(内敛函数，函数调用更快)
 
 @return 默认路径
 */
static inline NSString *defaultDocumentPath()
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] copy];
}




@implementation FMDBManager

+ (instancetype)db
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSLog(@"path = %@",defaultDocumentPath());
        _db = [FMDBManager databaseWithPath:[defaultDocumentPath() stringByAppendingPathComponent:@"model.sqlite"]];
        if(![_db open])
        {
            NSLog(@"打开数据库失败");
        }
        
    });
    return _db;
}

/**
 创建数据库表格
 
 @param tableName 数据库表名
 @return 是否成功
 */
- (BOOL)createWithTableName:(NSString *)tableName
{
    return [self createWithModel:nil withTableName:tableName];
}

/**
 创建数据库表格
 
 @param model 数据模型
 @return 是否成功
 */
- (BOOL)createWithModel:(id<modelProtocol>) model
{
    return [self createWithModel:model withTableName:nil];
}

/**
 创建数据库表格

 @param model 数据模型
 @param tableName 数据库表名
 @return 是否创建成功
 */
- (BOOL)createWithModel:(id<modelProtocol>)model withTableName:(NSString *)tableName
{
    BOOL success = NO;
    //1.表名
    if (!tableName || !tableName.length ) {
        tableName = [NSString stringWithFormat:@"%@_table",model.class];
    }
    //2.创建数据库表
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id integer PRIMARY KEY, model blob NOT NULL, modelID text NOT NULL);",tableName];
    success = [self executeUpdate:sql];
    return success;
}

/**
 添加数据

 @param model 数据模型对象(不可为空)
 @return 是否添加成功
 */
- (BOOL)addWithModel:(id <modelProtocol>) model
{
    //1.表名
    NSString *tableName = [NSString stringWithFormat:@"%@_table",model.class];
    
    //2.模型转data
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    
    //3.插入数据
   return [self executeUpdateWithFormat:@"INSERT INTO %@(model, modelID) VALUES(%@, %@);",tableName,data,model.modelID];
}

/**
 删除数据

 @param model 数据模型对象
 @return 是否删除成功
 */
- (BOOL)removeWithModel:(id <modelProtocol>) model
{
    //1.表名
    NSString *tableName = [NSString stringWithFormat:@"%@_table",model.class];
    
    //2.删除数据
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE modelID=%@;",tableName,model.modelID];
    return [self executeUpdate:sql];
}
- (BOOL)updateWithModel:(id <modelProtocol>) model
{
    //1.表名
    NSString *tableName = [NSString stringWithFormat:@"%@_table",model.class];
    
    //2.更新数据
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET model=%@ WHERE modelID=%@;",tableName,model,model.modelID];
   return [self executeUpdate:sql];
}

/**
 查询所有数据
 
 @return 查到的数据
 */
- (NSArray <id<modelProtocol>> *)getModelsWithClass:(Class) modelClass
{
    //1.表名
    NSString *tableName = [NSString stringWithFormat:@"%@_table",modelClass];
    
    //2.查询数据
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@;",tableName];
    FMResultSet *set = [self executeQuery:sql];
    return [self modelWithSet:set];
}

/**
 分页查询数据
 
 @param page 页码
 @return 当前页数据
 */
- (NSArray <id<modelProtocol>> *)getModelsWithClass:(Class) modelClass WithPage:(int) page
{
    int size = 20;
    int pos = (page - 1) * size;
    //1.表名
    NSString *tableName = [NSString stringWithFormat:@"%@_table",modelClass];
    
    //2.查询数据
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ORDER BY id DESC LIMIT %d,%d;",tableName,pos,size];
    FMResultSet *set = [self executeQuery:sql];
    return [self modelWithSet:set];
}

#pragma mark - Private
/**
 set转模型数据

 @param set FMResultSet
 @return 模型数组
 */
- (NSArray <id<modelProtocol>> *)modelWithSet:(FMResultSet *)set
{
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        id data = [set objectForColumnName:@"model"];
        id<modelProtocol> model = (id<modelProtocol>)[NSKeyedUnarchiver unarchiveObjectWithData:data];
       
        [array addObject:model];
    }
    return array;
}

@end


