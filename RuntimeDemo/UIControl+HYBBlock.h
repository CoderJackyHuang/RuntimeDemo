//
//  UIControl+HYBBlock.h
//  RuntimeDemo
//
//  Created by huangyibiao on 15/12/27.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HYBTouchUpBlock)(id sender);

@interface UIControl (HYBBlock)

@property (nonatomic, copy) HYBTouchUpBlock hyb_touchUpBlock;

@end
