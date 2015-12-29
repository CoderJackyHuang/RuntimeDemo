//
//  UIControl+HYBBlock.m
//  RuntimeDemo
//
//  Created by huangyibiao on 15/12/27.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "UIControl+HYBBlock.h"
#import <objc/runtime.h>

static const void *sHYBUIControlTouchUpEventBlockKey = "sHYBUIControlTouchUpEventBlockKey";

@implementation UIControl (HYBBlock)

- (void)setHyb_touchUpBlock:(HYBTouchUpBlock)hyb_touchUpBlock {
  objc_setAssociatedObject(self,
                           sHYBUIControlTouchUpEventBlockKey,
                           hyb_touchUpBlock,
                           OBJC_ASSOCIATION_COPY);
  
  [self removeTarget:self
              action:@selector(hybOnTouchUp:)
    forControlEvents:UIControlEventTouchUpInside];
  
  if (hyb_touchUpBlock) {
    [self addTarget:self
             action:@selector(hybOnTouchUp:)
   forControlEvents:UIControlEventTouchUpInside];
  }
}

- (HYBTouchUpBlock)hyb_touchUpBlock {
  return objc_getAssociatedObject(self, sHYBUIControlTouchUpEventBlockKey);
}

- (void)hybOnTouchUp:(UIButton *)sender {
  HYBTouchUpBlock touchUp = self.hyb_touchUpBlock;
  
  if (touchUp) {
    touchUp(sender);
  }
}

@end
