//
//  HYBTestEntry.m
//  RuntimeDemo
//
//  Created by huangyibiao on 16/1/14.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBTestEntry.h"

@implementation HYBTestEntry


+ (void)test {
  NSDictionary *originDict = @{@"k1": @"v1",
                               @"k2": @"v2",
                               @"k3": @"v3",
                               @"k4": @"v4",
                               @"k5": @"v5",
                               @"k6": @"v6",
                               @"k7": @"v7",
                               @"k8": @"v8",
                               @"k9": @"v9"};
  NSDictionary *paramters = @{@"kk1": @"",
                              @"kk2": @"vv2"};
  
  NSDictionary *resutDict = @{@"k1": @"v1",
                              @"k2": @"v2",
                              @"k3": @"v3",
                              @"k4": @"v4",
                              @"k5": @"v5",
                              @"k6": @"v6",
                              @"k7": @"v7",
                              @"k8": @"v8",
                              @"k9": @"v9",
                              @"kk1": @"",
                              @"kk2":@"vv2"};

  for (NSUInteger i = 0; i < 1000000; ++i) {
   NSMutableDictionary *allParams = [[NSMutableDictionary alloc] initWithDictionary:paramters];
    [allParams addEntriesFromDictionary:originDict];
    
    // 判断是否相等
    if (resutDict.count != allParams.count) {
      NSLog(@"merge but it is not equal");
      continue;
    }
    
    for (NSString *key in resutDict.allKeys) {
      NSString *value1 = [resutDict objectForKey:key];
      NSString *value2 = [allParams objectForKey:key];
      
      if (![value1 isEqualToString:value2]) {
        NSLog(@"merge but it is not equal");
        continue;
      }
    }
  }
}

@end
