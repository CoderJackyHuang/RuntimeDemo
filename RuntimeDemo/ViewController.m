//
//  ViewController.m
//  RuntimeDemo
//
//  Created by huangyibiao on 15/12/25.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/objc.h>
#import "HYBTestModel.h"
#import "HDFArchiveModel.h"
#import "HYBCat.h"
#import "HYBMsgSend.h"
#import "HYBMethodExchange.h"
#import "HYBPropertyLearn.h"
#import "HYBMethodLearn.h"
#import "UIViewController+Swizzling.h"

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

//  [HYBTestModel test];
//  [HDFArchiveModel test];
//  [HYBCat test];
//  [HYBMsgSend test];
//  [HYBMethodExchange test];
//  [HYBPropertyLearn test];
//  [HYBMethodLearn test];
  [self testWebview];
}

- (void)testWebview {
  self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  self.webView.delegate = self;
  NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.haodf.com/"]];
  [self.webView loadRequest:req];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSLog(@"url: %@", request.URL.absoluteString);
  
  return YES;
}

@end
