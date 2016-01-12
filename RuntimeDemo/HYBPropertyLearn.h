//
//  HYBPropertyLearn.h
//  RuntimeDemo
//
//  Created by huangyibiao on 16/1/10.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYBPropertyLearn : NSObject {
  float _websiteTitle;
  
  @private
  float _privateAttribute;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, assign) int count;
@property (nonatomic, weak) id delegate;
@property (atomic, strong) NSNumber *atomicProperty;

+ (void)test;

@end
