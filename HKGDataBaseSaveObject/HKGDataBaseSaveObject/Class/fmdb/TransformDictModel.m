//
//  TransformDictModel.m
//  Demo-Custom
//
//  Created by ZPP on 2017/3/18.
//  Copyright © 2017年 com.jiutian.com. All rights reserved.
//

#import "TransformDictModel.h"
#import <objc/runtime.h>
@implementation TransformDictModel
+ (id)dictTransformToModel:(NSDictionary *)dict model:(NSString *)clsStr
{
    Class cls  = NSClassFromString(clsStr);
    id model = [[cls alloc] init];
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++)
    {
        const char *proName = ivar_getName(ivars[i]);
//        const char *attrStr = ivar_getTypeEncoding(ivars[i]);
        NSString *property = [[NSString stringWithCString:proName encoding:NSUTF8StringEncoding] substringFromIndex:1];
//        NSString *attribute = [NSString stringWithCString:attrStr encoding:NSUTF8StringEncoding];
        id value  = [dict objectForKey:property];
        if (![value isKindOfClass:[NSNull class]])
        {
        [model setValue:value forKey:property];
        }
        
    }
     free(ivars);
    return model;
}

+ (NSDictionary *)modelTransformDict:(id)model
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *clsStr = [NSString stringWithCString:object_getClassName(model) encoding:NSUTF8StringEncoding];
    Class cls  = NSClassFromString(clsStr);
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++)
    {
        const char *proName = ivar_getName(ivars[i]);
        NSString *property = [[NSString stringWithCString:proName encoding:NSUTF8StringEncoding] substringFromIndex:1];
        id value = [model valueForKey:property];
        if (![value isKindOfClass:[NSNull class]] && value)
            [dict setObject:value forKey:property];
        else
            [dict setObject:@"null" forKey:property];
        
    }
     free(ivars);
    return dict;
}
@end
