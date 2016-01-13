//
//  UIWebView+Swizzling.m
//  RuntimeDemo
//
//  Created by huangyibiao on 16/1/13.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import "NSObject+Swizzling.h"

@implementation UIViewController (Swizzling)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [self swizzleSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)
     withSwizzledSelector:@selector(hdf_webView:shouldStartLoadWithRequest:navigationType:)];
  });
}

- (BOOL)hdf_webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSString *url = request.URL.absoluteString;
  
  // 注意containsString是iOS8以后才有，具体要兼容ios6则需要自己写
  // 这里只是为了简便测试
  if ([url containsString:@"userId"] && [url containsString:@"token"]) {
    return [self hdf_webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
  }
  
  if ([url isEqualToString:@"about:blank"]) {
    return [self hdf_webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
  }
  
  url = [NSString stringWithFormat:@"%@?userId=123&token=ssdfsfdf", url];
  NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  [webView loadRequest:req];
  
  return NO;
}

@end
