//
//  CHReturnObjc.m
//  RichTextDemo
//
//  Created by 杨春至 on 2017/6/27.
//  Copyright © 2017年 com.hofon.www. All rights reserved.
//

#import "CHReturnObjc.h"

@implementation CHReturnObjc

+(NSObject *)getObjcBy:(long long)address{
    NSObject *objc = (NSObject *)address;
    return objc;
}
@end
