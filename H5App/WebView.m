//
//  WebView.m
//  H5App
//
//  Created by Blavtes on 2018/12/13.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import "WebView.h"
#import "CryptUtil.h"
#import <objc/runtime.h>
#import "NSString+MD5.h"

#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface WebView() <WKNavigationDelegate>
@property (nonatomic, weak) UIView *maskView;
 @end

@implementation WebView

- (instancetype)initWithFrame:(CGRect)frame
{
 
    if (self = [super initWithFrame:frame]) {
       
        
        WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(10, 0, 0.9 * MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT *0.85)];
//        web.delegate =self;
        web.backgroundColor = [UIColor grayColor];
        web.navigationDelegate = self;
        [self addSubview:web];
        _webView = web;
//        NotificationCenter default.addObserver(self, selector: @selector(getFocusElementId), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFocusElementId) name:UIKeyboardWillShowNotification object:nil];
        
//        [btn setBackgroundColor:[UIColor grayColor]];
//        UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 0.9 * MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT *0.9)];
//        mask.backgroundColor = [UIColor colorWithRed:15 green:15 blue:15 alpha:0.02];
//        [self addSubview:mask];
//        _maskView = mask;
        
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(20, 80, 25, 25);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 12.5;
        [btn setTitle:@"CS" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor grayColor]];
        [self addSubview:btn];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        
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

- (void)getFocusElementId
{
    NSString * javaScriptQuery = @"document.activeElement.id";
//
//    webView.evaluateJavaScript(javaScriptQuery) { (result, error) -> Void in
//        print("focus element id = \(result as? String)")
//    }
    [_webView evaluateJavaScript:javaScriptQuery completionHandler:^(id _Nullable resul, NSError * _Nullable error) {
        NSLog(@"resul %@",resul);
    }];
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

- (NSString *)urlMd5ReqIdString
{
    NSArray *tid = @[@"1177",@"1188",@"1199",@"1198",@"1178",@"1179",@"1181"];
    NSString *codeStr = [NSString stringWithFormat:@"%@_%.2f_%ld",@"123xsdf3hd",CFAbsoluteTimeGetCurrent(),random()];
    NSString *url = CryptUtil->decryptDES128WithMD5(@"tJnep7hi7ihEI45B93k1gX0RFFjCEpxtibQswu8Ids6cyz7I92nKPh8kVNip6GYa",kCryptKey,kIvValue);
    return [NSString stringWithFormat:@"%@?tid=%@&mob=ios&gid=%@",url,tid[arc4random_uniform([tid count])],[[codeStr MD5Sum] lowercaseString]];
}

- (NSString *)url
{

    NSArray *arr = @[[self urlMd5ReqIdString],[self urlMd5ReqIdString],[self urlMd5ReqIdString],[self urlMd5ReqIdString],[self urlMd5ReqIdString],[self urlMd5ReqIdString],[self urlMd5ReqIdString],[self urlMd5ReqIdString],[self urlMd5ReqIdString],[self urlMd5ReqIdString],[self urlMd5ReqIdString],[self urlMd5ReqIdString],[self urlMd5ReqIdString],[self urlMd5ReqIdString],[self urlMd5ReqIdString]];
    NSLog(@"%@",arr);
    return arr[arc4random_uniform([arr count])];

}

- (void)start
{
    
    __weak typeof(self) weakself = self;
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        
        __strong typeof(self) strongSelf = weakself;
        
        [strongSelf.webView setCustomUserAgent:[strongSelf userAgent]];
        //        echo(@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"UserAgent"]);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[strongSelf url]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
        [strongSelf.webView loadRequest:request];
        [strongSelf webView:strongSelf.webView enableGL:NO debugUrl:@""];
    }];

   
  
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
     decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
}
/// 1 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //拦截URL，判断http或https请求头部信息
    
    NSMutableURLRequest *mutableRequest = [navigationAction.request mutableCopy];
    NSDictionary *headFields = mutableRequest.allHTTPHeaderFields;
    NSString *    agent  = headFields[@"User-Agent"];//登录的token
    //判断请求头是否存在uuid字段，如果否，则表示该请求尚未设置请求头
    if (![[self userAgentArrary] containsObject:agent]) {
    
        [mutableRequest setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
        //重新加载设置后的请求
        [webView loadRequest:mutableRequest];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
}

- (NSArray *)userAgentArrary
{
    return @[@"Mozilla/5.0 (Linux; U; Android 2.3.6; en-us; Nexus S Build/GRK39F) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1",
             @"Avant Browser/1.2.789rel1 (http://www.avantbrowser.com)",
             @"Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/532.5 (KHTML, like Gecko) Chrome/4.0.249.0 Safari/532.5",
             @"Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US) AppleWebKit/532.9 (KHTML, like Gecko) Chrome/5.0.310.0 Safari/532.9",
             @"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/534.7 (KHTML, like Gecko) Chrome/7.0.514.0 Safari/534.7",
             @"Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/534.14 (KHTML, like Gecko) Chrome/9.0.601.0 Safari/534.14",
             @"Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.14 (KHTML, like Gecko) Chrome/10.0.601.0 Safari/534.14",
             @"Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.20 (KHTML, like Gecko) Chrome/11.0.672.2 Safari/534.20",
             @"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.27 (KHTML, like Gecko) Chrome/12.0.712.0 Safari/534.27",
             @"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.24 Safari/535.1",
             @"Mozilla/5.0 (Windows NT 6.0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.874.120 Safari/535.2",
             @"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.36 Safari/535.7",
             @"Mozilla/5.0 (Windows; U; Windows NT 6.0 x64; en-US; rv:1.9pre) Gecko/2008072421 Minefield/3.0.2pre",
             @"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.10) Gecko/2009042316 Firefox/3.0.10",
             @"Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.0.11) Gecko/2009060215 Firefox/3.0.11 (.NET CLR 3.5.30729)",
             @"Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6 GTB5",
             @"Mozilla/5.0 (Windows; U; Windows NT 5.1; tr; rv:1.9.2.8) Gecko/20100722 Firefox/3.6.8 ( .NET CLR 3.5.30729; .NET4.0E)",
             @"Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
             @"Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
             @"Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20100101 Firefox/5.0",
             @"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0a2) Gecko/20110622 Firefox/6.0a2",
             @"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20100101 Firefox/7.0.1",
             @"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:2.0b4pre) Gecko/20100815 Minefield/4.0b4pre"];
}

- (NSString *)userAgent
{
    NSArray *userAgent = [self userAgentArrary];
    NSString *agent = userAgent[arc4random_uniform([userAgent count])];
    NSLog(@"agent %@",agent);
    return agent;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
typedef void (*CallFuc)(id, SEL, BOOL);
typedef BOOL (*GetFuc)(id, SEL);
- (BOOL)webView:(WKWebView*)view enableGL:(BOOL)bEnable debugUrl:(NSString *)urlStr
{
    BOOL bRet = NO;
    do {
        Ivar internalVar = class_getInstanceVariable([view class], "_internal");
        if (!internalVar) {
            break;
        }
        
        UIWebViewInternal* internalObj = object_getIvar(view, internalVar);
        Ivar browserVar = class_getInstanceVariable(object_getClass(internalObj), "browserView");
        if (!browserVar) {
            break;
        }
        
        id webbrowser = object_getIvar(internalObj, browserVar);
        Ivar webViewVar = class_getInstanceVariable(object_getClass(webbrowser), "_webView");
        if (!webViewVar) {
            break;
        }
        
        id webView = object_getIvar(webbrowser, webViewVar);
        if (!webView) {
        }
        
        if(object_getClass(webView) != NSClassFromString(@"WebView")) {
            break;
        }
        
        SEL selector = NSSelectorFromString(@"_setWebGLEnabled:");
        IMP impSet = [webView methodForSelector:selector];
        CallFuc func = (CallFuc)impSet;
        func(webView, selector, bEnable);
        
        SEL selectorGet = NSSelectorFromString(@"_webGLEnabled");
        IMP impGet = [webView methodForSelector:selectorGet];
        GetFuc funcGet = (GetFuc)impGet;
        BOOL val = funcGet(webView, selector);
        
        bRet = (val == bEnable);
        
    } while (NO);
    
    return bRet;
}


@end
