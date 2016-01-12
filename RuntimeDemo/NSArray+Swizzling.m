//
//  NSArray+Swizzling.m
//  RuntimeDemo
//
//  Created by huangyibiao on 16/1/12.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "NSArray+Swizzling.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSArray (Swizzling)

//+ (void)load {
//  static dispatch_once_t onceToken;
//  dispatch_once(&onceToken, ^{
//    [self swizzleSelector:@selector(lastObject)
//     withSwizzledSelector:@selector(hdf_lastObject)];
//  });
//}

- (id)hdf_lastObject {
  NSLog(@"%s", __FUNCTION__);
  
 return [self hdf_lastObject];
}


@end
