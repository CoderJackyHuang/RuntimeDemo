//
//  HYBDog.m
//  RuntimeDemo
//
//  Created by huangyibiao on 15/12/31.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "HYBDog.h"
#import <objc/runtime.h>


@implementation HYBDog

// 第一步：实现此方法，在调用对象的某方法找不到时，会先调用此方法，允许
// 我们动态添加方法实现
+ (BOOL)resolveInstanceMethod:(SEL)sel {
  // 我们这里没有给dog声明有eat方法，因此，我们可以动态添加eat方法
  if ([NSStringFromSelector(sel) isEqualToString:@"eat"]) {
    class_addMethod(self, sel, (IMP)eat, "v@:");
    return YES;
  }
  
  return [super resolveInstanceMethod:sel];
}

// 这个方法是我们动态添加的哦
//
void eat(id self, SEL cmd) {
  NSLog(@"%@ is eating", self);
}

@end
