
//
//  HYBMethodExchange.m
//  RuntimeDemo
//
//  Created by huangyibiao on 16/1/4.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBMethodExchange.h"
#import <objc/runtime.h>
#import "NSMutableArray+Swizzling.h"
#import "NSArray+Swizzling.h"

@implementation HYBMethodExchange


+ (void)test {

//  Method originalMethod = class_getInstanceMethod([NSArray class], @selector(lastObject));
//  Method newMedthod = class_getInstanceMethod([NSArray class], NSSelectorFromString(@"hdf_lastObject"));
//  method_exchangeImplementations(originalMethod, newMedthod);
  
  NSMutableArray *array = [@[@"value", @"value1"] mutableCopy];
  [array lastObject];
  
  [array removeObject:@"value"];
  [array removeObject:nil];
  [array addObject:@"12"];
  [array addObject:nil];
  [array insertObject:nil atIndex:0];
  [array insertObject:@"sdf" atIndex:10];
  [array objectAtIndex:100];
  [array removeObjectAtIndex:10];
  
  NSMutableArray *anotherArray = [[NSMutableArray alloc] init];
  [anotherArray objectAtIndex:0];
  
  NSString *nilStr = nil;
  NSArray *array1 = @[@"ara", @"sdf", @"dsfdsf", nilStr];
  NSLog(@"array1.count = %lu", array1.count);
}

// C语言版
void swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
  Method originalMethod = class_getInstanceMethod(class, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
  
  // 若已经存在，则添加会失败
  BOOL didAddMethod = class_addMethod(class,
                                      originalSelector,
                                      method_getImplementation(swizzledMethod),
                                      method_getTypeEncoding(swizzledMethod));
  
  // 若原来的方法并不存在，则添加即可
  if (didAddMethod) {
    class_replaceMethod(class,
                        swizzledSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}

@end
