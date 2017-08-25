//
//  ZHMyModel.m
//  ZHFinance
//
//  Created by 耿宏凯 on 2017/8/23.
//  Copyright © 2017年 com.jiutian.com. All rights reserved.
//

#import "ZHMyModel.h"
#import "MJExtension.h"

@implementation ZHMyModel

@synthesize modelID=_modelID;


MJCodingImplementation

//-(void)encodeWithCoder:(NSCoder *)aCoder
//{
////    NSLog(@"调用了encodeWithCoder:方法");
//    [aCoder encodeObject:self.name forKey:@"name"];
//    [aCoder encodeObject:self.modelID forKey:@"modelID"];
//    [aCoder encodeObject:self.message forKey:@"message"];
//    [aCoder encodeObject:self.code forKey:@"code"];
//}
//
// // 当从文件中读取一个对象的时候就会调用该方法
// // 在该方法中说明如何读取保存在文件中的对象
// // 也就是说在该方法中说清楚怎么读取文件中的对象
//-(id)initWithCoder:(NSCoder *)aDecoder
//{
////    NSLog(@"调用了initWithCoder:方法");
//    //注意：在构造方法中需要先初始化父类的方法
//    if (self=[super init]) {
//        self.name=[aDecoder decodeObjectForKey:@"name"];
//        self.message=[aDecoder decodeObjectForKey:@"message"];
//        self.modelID=[aDecoder decodeObjectForKey:@"modelID"];
//        self.code=[aDecoder decodeObjectForKey:@"code"];
//    }
//     return self;
//}

@end
