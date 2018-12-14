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
@property (nonatomic, weak) UIView *maskView;
 @end

@implementation WebView

- (instancetype)initWithFrame:(CGRect)frame
{
 
    if (self = [super initWithFrame:frame]) {
       
        
        WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(10, 0, 0.9 * MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT *0.9)];
//        web.delegate =self;
        web.backgroundColor = [UIColor grayColor];
        [self addSubview:web];
        _webView = web;
        
       
//        [btn setBackgroundColor:[UIColor grayColor]];
//        UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 0.9 * MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT *0.9)];
//        mask.backgroundColor = [UIColor colorWithRed:15 green:15 blue:15 alpha:0.02];
//        [self addSubview:mask];
//        _maskView = mask;
        
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(20, 40, 40, 25);
        [btn setTitle:@"CLS" forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

        
//        UIButton *Mask = [UIButton new];
//        [Mask addTarget:self action:@selector(Mask:) forControlEvents:UIControlEventTouchUpInside];
//        Mask.frame = CGRectMake(20, 60, 40, 25);
//        [Mask setTitle:@"MAS" forState:UIControlStateNormal];
//        [Mask setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//
//        [self addSubview:Mask];
        
        
//        self.backgroundColor = [UIColor redColor];
    }
    return  self;
}

- (void)Mask:(id)sender
{
    if (!_maskView.isHidden) {
        _maskView.hidden = YES;

    } else {
        _maskView.hidden = NO;
    }
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    //3种状态无法响应事件
//    if (self.userInteractionEnabled == NO || self.hidden == YES ||  self.alpha <= 0.01) return nil;
//    //触摸点若不在当前视图上则无法响应事件
//    if ([self pointInside:point withEvent:event] == NO) return nil;
//    //从后往前遍历子视图数组
//    int count = (int)self.subviews.count;
//    for (int i = count - 1; i >= 0; i--)
//    {
//        // 获取子视图
//        UIView *childView = self.subviews[i];
//        // 坐标系的转换,把触摸点在当前视图上坐标转换为在子视图上的坐标
//        CGPoint childP = [self convertPoint:point toView:childView];
//        //询问子视图层级中的最佳响应视图
//        UIView *fitView = [childView hitTest:childP withEvent:event];
//        if (fitView == _maskView)
//        {
//            //如果子视图中有更合适的就返回
//            return fitView;
//        }
//    }
//    //没有在子视图中找到更合适的响应视图，那么自身就是最合适的
//    return self;
//}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//
//    NSLog(@"%s", __func__);
//    CGPoint tmpPoint = [self convertPoint:point toView:_maskView];
//
//    if([_maskView pointInside:tmpPoint withEvent:event]){
//
//        return YES;
//    }
//
//    return [super pointInside:point withEvent:event];
//}

- (void)start
{
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://h5.h5youyou.com/youxi-h5/?tid=1199&mob=ios&gid=27e9098090eda8a605703d6afeb611b3"]];
    [self.webView loadRequest:request];
}

- (void)remove:(id)sender
{
  
    [_webView removeFromSuperview];
//    _webView.delegate = nil;
    _webView = nil;
    [self removeFromSuperview];
    if (_removeCall) {
        _removeCall();
    }
}
/// 接收到服务器跳转请求之后调用 (服务器端redirect)，不一定调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
}
/// 3 在收到服务器的响应头，根据response相关信息，决定是否跳转。decisionHandler必须调用，来决定是否跳转，参数WKNavigationActionPolicyCancel取消跳转，WKNavigationActionPolicyAllow允许跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"%@",navigationResponse);
}
/// 1 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
