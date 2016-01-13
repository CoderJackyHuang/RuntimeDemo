//
//  HYBMsgSend.m
//  RuntimeDemo
//
//  Created by huangyibiao on 16/1/2.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBMsgSend.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>

@implementation HYBMsgSend

- (void)noArgumentsAndNoReturnValue {
  NSLog(@"%s was called, and it has no arguments and return value", __FUNCTION__);
}

- (void)hasArguments:(NSString *)arg {
  NSLog(@"%s was called, and argument is %@", __FUNCTION__, arg);
}

- (NSString *)noArgumentsButReturnValue {
  NSLog(@"%s was called, and return value is %@", __FUNCTION__, @"不带参数，但是带有返回值");
  return @"不带参数，但是带有返回值";
}

- (int)hasArguments:(NSString *)arg andReturnValue:(int)arg1 {
  NSLog(@"%s was called, and argument is %@, return value is %d", __FUNCTION__, arg, arg1);
  return arg1;
}

// C函数
int cStyleFunc(const void *arg1, const void *arg2) {
  NSLog(@"%s was called, arg1 is %s, and arg2 is %s", __FUNCTION__, arg1, arg2);
  return 1;
}

- (float)returnFloatType {
  NSLog(@"%s was called, and has return value", __FUNCTION__);
  return 3.121592612321323123;
}

- (CGRect)returnTypeIsStruct {
  NSLog(@"%s was called", __FUNCTION__);
 
  return CGRectMake(0, 0, 10, 10);
}

+ (void)test {
  // 1.创建对象
 HYBMsgSend *msg = ((HYBMsgSend * (*)(id, SEL))objc_msgSend)((id)[HYBMsgSend class], @selector(alloc));
  
  // 2.初始化对象
 msg = ((HYBMsgSend * (*)(id, SEL))objc_msgSend)((id)msg, @selector(init));
  
  // 3.调用无参数无返回值方法
  ((void (*)(id, SEL))objc_msgSend)((id)msg, @selector(noArgumentsAndNoReturnValue));
  
  // 4.调用带一个参数但无返回值的方法
  ((void (*)(id, SEL, NSString *))objc_msgSend)((id)msg, @selector(hasArguments:), @"带一个参数，但无返回值");
  // 5.调用带返回值，但是不带参数
 NSString *retValue = ((NSString * (*)(id, SEL))objc_msgSend)((id)msg, @selector(noArgumentsButReturnValue));
  NSLog(@"5. 返回值为：%@", retValue);
  // 6.带参数带返回值
  int returnValue = ((int (*)(id, SEL, NSString *, int))
                     objc_msgSend)(msg,
                                   @selector(hasArguments:andReturnValue:),
                                   @"参数1",
                                   2016);
  NSLog(@"6. return value is %d", returnValue);
  
  // 7.动态添加方法，然后调用C函数
  class_addMethod(msg.class, NSSelectorFromString(@"cStyleFunc"), (IMP)cStyleFunc, "i@:");
  returnValue = ((int (*)(id, SEL, const void *, const void *))
                 objc_msgSend)((id)msg,
                               NSSelectorFromString(@"cStyleFunc"),
                               "参数1",
                               "参数2");
  NSLog(@"7. return value is %d", returnValue);
  
  // 8.返回浮点型时，调用objc_msgSend/objc_msgSend_fpret,其结果是一样的。
 float retFloatValue = ((float (*)(id, SEL))objc_msgSend_fpret)((id)msg, @selector(returnFloatType));
  NSLog(@"%f", retFloatValue);
  
   retFloatValue = ((float (*)(id, SEL))objc_msgSend)((id)msg, @selector(returnFloatType));
  NSLog(@"%f", retFloatValue);

  // 9.返回结构体时，不能使用objc_msgSend，而是要使用objc_msgSend_stret，否则会crash
  CGRect frame = ((CGRect (*)(id, SEL))objc_msgSend_stret)((id)msg, @selector(returnTypeIsStruct));
  NSLog(@"9. return value is %@", NSStringFromCGRect(frame));

}

@end
