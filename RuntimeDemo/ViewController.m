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
#import "HYBTestEntry.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

//  [HYBTestModel test];
//  [HDFArchiveModel test];
//  [HYBCat test];
  [HYBMsgSend test];
//  [HYBMethodExchange test];
//  [HYBPropertyLearn test];
//  [HYBMethodLearn test];
//  [self testWebview];
//  [HYBTestEntry test];
}

- (void)testWebview {
  self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  self.webView.delegate = self;
  NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://t.cn/RbQXJ6j"]];
  [self.webView loadRequest:req];
  [self.view addSubview:self.webView];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSLog(@"url: %@", request.URL.absoluteString);
  NSLog(@"query: %@", request.URL.query);
//  [ViewController filterWebView:webView withRequest:request];
  
  return YES;
}

+ (BOOL)filterWebView:(UIWebView *)webView withRequest:(NSURLRequest *)request {
  // 未登录状态下，不用增加
//  if (kIsEmptyString([HDFCipher token])) {
//    return YES;
//  }
  
  NSString *url = request.URL.absoluteString;
  
  if ([url rangeOfString:@"userId"].location != NSNotFound ) {
    return YES;
  }
  
  if ([url isEqualToString:@"about:blank"]) {
    return YES;
  }
  
  
  NSString *query = request.URL.query;
  NSString *format = @"%@?userId=%@&token=%@";
  if (query.length != 0) {
    format = @"%@&userId=%@&token=%@";
  }
  
//  if ([HDFCipher isDoctorApp]) {
    url = [NSString stringWithFormat:format,
           url,
@"xxxxxx",
           @"sdhfodsfdf"];
//  } else if ([HDFCipher isPatientApp]) {
//    url = [NSString stringWithFormat:format,
//           url,
//           [[NSClassFromString(@"HaodfUserManager") sharedManager] userIdString],
//           [HDFCipher token]];
//  }
  NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  [webView loadRequest:req];
  
  NSString *url1=@"http://unmi.cc?p1=%+&sd &p2=中文";
  NSLog(@"encode: %@", [[self class] encodeURL:url1]);
  
  return NO;
}

+ (NSString *)encodeURL:(NSString *)url {
  NSString *newString =
  CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                            (CFStringRef)url,
                                                            NULL,
                                                            CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
  if (newString) {
    return newString;
  }
  
  return url;
}

@end
