//
//  HYBMethodLearn.m
//  RuntimeDemo
//
//  Created by huangyibiao on 16/1/12.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBMethodLearn.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation HYBMethodLearn

- (int)testInstanceMethod:(NSString *)name andValue:(NSNumber *)value {
  NSLog(@"%@", name);
  
  return value.intValue;
}

- (NSArray *)arrayWithNames:(NSArray *)names {
  NSLog(@"%@", names);
  return names;
}

- (void)getMethods {
  unsigned int outCount = 0;
  Method *methodList = class_copyMethodList(self.class, &outCount);
  
  for (unsigned int i = 0; i < outCount; ++i) {
    Method method = methodList[i];
    
    SEL methodName = method_getName(method);
    NSLog(@"方法名：%@", NSStringFromSelector(methodName));
    
    // 获取方法的参数类型
    unsigned int argumentsCount = method_getNumberOfArguments(method);
    char argName[512] = {};
    for (unsigned int j = 0; j < argumentsCount; ++j) {
      method_getArgumentType(method, j, argName, 512);
      
      NSLog(@"第%u个参数类型为：%s", j, argName);
      memset(argName, '\0', strlen(argName));
    }
    
    char returnType[512] = {};
    method_getReturnType(method, returnType, 512);
    NSLog(@"返回值类型：%s", returnType);
    
    // type encoding
    NSLog(@"TypeEncoding: %s", method_getTypeEncoding(method));
  }
  
  free(methodList);
}


+ (void)test {
  HYBMethodLearn *m = [[HYBMethodLearn alloc] init];
//  [m getMethods];
  
  ((void (*)(id, SEL))objc_msgSend)((id)m, @selector(getMethods));
  
  // 这就是为什么有四个参数的原因
  int returnValue = ((int (*)(id, SEL, NSString *, NSNumber *))
                     objc_msgSend)((id)m,
                                   @selector(testInstanceMethod:andValue:),
                                   @"标哥的技术博客",
                                   @100);
  NSLog(@"return value is %d", returnValue);
  
  // 获取方法
  Method method = class_getInstanceMethod([self class], @selector(testInstanceMethod:andValue:));
  
  // 调用函数
  returnValue = ((int (*)(id, Method, NSString *, NSNumber *))method_invoke)((id)m, method, @"测试使用method_invoke", @11);
  NSLog(@"call return vlaue is %d", returnValue);
}

@end
