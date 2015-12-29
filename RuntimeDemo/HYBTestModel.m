//
//  HYBTestModel.m
//  RuntimeDemo
//
//  Created by huangyibiao on 15/12/28.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "HYBTestModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation HYBTestModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    for (NSString *key in dictionary.allKeys) {
      id value = [dictionary objectForKey:key];
      
      if ([key isEqualToString:@"testModel"]) {
        HYBTestModel *testModel = [[HYBTestModel alloc] initWithDictionary:value];
        value = testModel;
        self.testModel = testModel;
        
        continue;
      }
      
      SEL setter = [self propertySetterWithKey:key];
      if (setter != nil) {
        ((void (*)(id, SEL, id))objc_msgSend)(self, setter, value);
      }
    }
  }
  
  return self;
}

- (NSDictionary *)toDictionary {
  unsigned int outCount = 0;
  objc_property_t *properties = class_copyPropertyList([self class], &outCount);
  
  if (outCount != 0) {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:outCount];
    
    for (unsigned int i = 0; i < outCount; ++i) {
      objc_property_t property = properties[i];
      const void *propertyName = property_getName(property);
      NSString *key = [NSString stringWithUTF8String:propertyName];
      
      // 继承于NSObject的类都会有这几个在NSObject中的属性
      if ([key isEqualToString:@"description"]
          || [key isEqualToString:@"debugDescription"]
          || [key isEqualToString:@"hash"]
          || [key isEqualToString:@"superclass"]) {
        continue;
      }
      
    // 我们只是测试，不做通用封装，因此这里不额外写方法做通用处理，只是写死测试一下效果
    if ([key isEqualToString:@"testModel"]) {
      if ([self respondsToSelector:@selector(toDictionary)]) {
        id testModel = [self.testModel toDictionary];
        if (testModel != nil) {
          [dict setObject:testModel forKey:key];
        }
        continue;
      }
    }
      
      SEL getter = [self propertyGetterWithKey:key];
      if (getter != nil) {
        // 获取方法的签名
        NSMethodSignature *signature = [self methodSignatureForSelector:getter];
        
        // 根据方法签名获取NSInvocation对象
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        // 设置target
        [invocation setTarget:self];
        // 设置selector
        [invocation setSelector:getter];
        
        // 方法调用
        [invocation invoke];
        
        // 接收返回的值
        __unsafe_unretained NSObject *propertyValue = nil;
        [invocation getReturnValue:&propertyValue];
        
        //        id propertyValue = [self performSelector:getter];
        
        if (propertyValue == nil) {
          if ([self respondsToSelector:@selector(defaultValueForEmptyProperty)]) {
            NSDictionary *defaultValueDict = [self defaultValueForEmptyProperty];
            
            id defaultValue = [defaultValueDict objectForKey:key];
            propertyValue = defaultValue;
          }
        }
        
        if (propertyValue != nil) {
          [dict setObject:propertyValue forKey:key];
        }
      }
    }
    
    free(properties);
    
    return dict;
  }
  
  free(properties);
  return nil;
}

- (SEL)propertyGetterWithKey:(NSString *)key {
  if (key != nil) {
    SEL getter = NSSelectorFromString(key);
    
    if ([self respondsToSelector:getter]) {
      return getter;
    }
  }
  
  return nil;
}

- (SEL)propertySetterWithKey:(NSString *)key {
  NSString *propertySetter = key.capitalizedString;
  propertySetter = [NSString stringWithFormat:@"set%@:", propertySetter];
  
  // 生成setter方法
  SEL setter = NSSelectorFromString(propertySetter);
  
  if ([self respondsToSelector:setter]) {
    return setter;
  }
  
  return nil;
}

#pragma mark - HYBEmptyPropertyProperty
- (NSDictionary *)defaultValueForEmptyProperty {
  return @{@"name" : [NSNull null],
           @"title" : [NSNull null],
           @"count" : @(1),
           @"commentCount" : @(1),
           @"classVersion" : @"0.0.1"};
}

+ (void)test {
  NSMutableSet *set = [NSMutableSet setWithArray:@[@"可变集合", @"字典->不可变集合->可变集合"]];
  NSDictionary *dict = @{@"name"  : @"标哥的技术博客",
                         @"title" : @"http://www.henishuo.com",
                         @"count" : @(11),
                         @"results" : [NSSet setWithObjects:@"集合值1", @"集合值2", set , nil],
                         @"summaries" : @[@"sm1", @"sm2", @{@"keysm": @{@"stkey": @"字典->数组->字典->字典"}}],
                         @"parameters" : @{@"key1" : @"value1", @"key2": @{@"key11" : @"value11", @"key12" : @[@"三层", @"字典->字典->数组"]}},
                         @"classVersion" : @(1.1),
                         @"testModel" : @{@"name"  : @"标哥的技术博客",
                                          @"title" : @"http://www.henishuo.com",
                                          @"count" : @(11),
                                          @"results" : [NSSet setWithObjects:@"集合值1", @"集合值2", set , nil],
                                          @"summaries" : @[@"sm1", @"sm2", @{@"keysm": @{@"stkey": @"字典->数组->字典->字典"}}],
                                          @"parameters" : @{@"key1" : @"value1", @"key2": @{@"key11" : @"value11", @"key12" : @[@"三层", @"字典->字典->数组"]}},
                                          @"classVersion" : @(1.1)}};
  HYBTestModel *model = [[HYBTestModel alloc] initWithDictionary:dict];
  
  NSLog(@"%@", model);
  
  NSLog(@"model->dict: %@", [model toDictionary]);
}

@end
