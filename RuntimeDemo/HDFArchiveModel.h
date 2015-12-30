//
//  HDFArchiveModel.h
//  RuntimeDemo
//
//  Created by huangyibiao on 15/12/30.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBTestModel.h"

@interface HDFArchiveModel : NSObject <NSCoding>

@property (nonatomic, assign) int    referenceCount;
//@property (nonatomic, strong) HYBTestModel *testModel;
@property (nonatomic, copy) NSString *archive;
@property (nonatomic, assign) const void *session;
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, assign) float  _floatValue;

+ (void)test;

@end
