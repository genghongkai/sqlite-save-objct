//
//  TransformDictModel.h
//  Demo-Custom
//
//  Created by ZPP on 2017/3/18.
//  Copyright © 2017年 com.jiutian.com. All rights reserved.
//模型字典互转

#import <Foundation/Foundation.h>

@interface TransformDictModel : NSObject
/**
 字典转模型
 @param dict 要转成模型的字典
 @param clsStr 要转出模型的类名
 @return 模型
 */
+ (id)dictTransformToModel:(NSDictionary *)dict model:(NSString *)clsStr;

/**
 模型转字典
 @param model 要转成字典的模型
 @return 转成功后的字典
 */
+ (NSDictionary *)modelTransformDict:(id)model;
@end
