//
//  WebView.m
//  H5App
//
//  Created by Blavtes on 2018/12/13.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import "WebView.h"
#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface WebView() <UIWebViewDelegate>

@end

@implementation WebView

- (instancetype)initWithFrame:(CGRect)frame
{
 
    if (self = [super initWithFrame:frame]) {
       
        
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(20, 0, 0.9 * MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT *0.9)];
        web.delegate =self;
        [self addSubview:web];
        _webView = web;
        
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(20, 10, 60, 60);
        [btn setTitle:@"X" forState:UIControlStateNormal];
        [self addSubview:btn];
//        self.backgroundColor = [UIColor redColor];
    }
    return  self;
}

- (void)start
{
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://h5.h5youyou.com/youxi-h5/?tid=1199&mob=ios&gid=27e9098090eda8a605703d6afeb611b3"]];
    [self.webView loadRequest:request];
}

- (void)remove:(id)sender
{
  
    [_webView removeFromSuperview];
    _webView.delegate = nil;
    _webView = nil;
    [self removeFromSuperview];
    if (_removeCall) {
        _removeCall();
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad # %@",webView.request.URL.absoluteString);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad # %@",webView.request.URL.absoluteString);
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
