//
//  ViewController.m
//  H5App
//
//  Created by Blavtes on 2018/12/13.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import "ViewController.h"
#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#import "WebView.h"

@interface ViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, assign) int count;

@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = [NSMutableArray arrayWithCapacity:1];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://h5.h5youyou.com/youxi-h5/?tid=1199&mob=ios&gid=27e9098090eda8a605703d6afeb611b3"]];
    UIScrollView *scroll1 = [UIScrollView new];
    scroll1.delegate = self;
    scroll1.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH , MAIN_SCREEN_HEIGHT);
    scroll1.contentSize = CGSizeMake(MAIN_SCREEN_WIDTH * 2 , MAIN_SCREEN_HEIGHT*1.1);
    [self.view addSubview:scroll1];
    _scroll1 = scroll1;
    
//    UIScrollView *scroll2 = [UIScrollView new];
//    scroll2.delegate = self;
//    scroll2.frame = CGRectMake(MAIN_SCREEN_WIDTH * 0.5 + 2, 0, MAIN_SCREEN_WIDTH * 0.5 - 2, MAIN_SCREEN_HEIGHT);
//    scroll2.contentSize = CGSizeMake(MAIN_SCREEN_WIDTH * 0.5 , MAIN_SCREEN_HEIGHT);
//    [self.view addSubview:scroll2];
//    _scroll2 = scroll2;
    
    _scroll1.maximumZoomScale = 1.5;

    WebView *web = [[WebView alloc] initWithFrame:CGRectMake(20, 20, MAIN_SCREEN_WIDTH * 0.9, MAIN_SCREEN_HEIGHT * 0.9)];
    web.removeCall = ^{
         [self checkoutWeb];
    };
    [_scroll1 addSubview:web];
    [web start];
    _count = 1;
    [_array addObject:web];
    
    UISwitch *swi = [[UISwitch alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH * 0.5 -10, 10, 20, 20)];
    [swi addTarget:self action:@selector(checkout:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:swi];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)checkout:(UISwitch*)sender {
    _scroll1.scrollsToTop = YES;
//    _scroll2.scrollsToTop = YES;
    if (sender.on) {
//        __block slf = self;
        _count += 1;
        
        _scroll1.contentSize = CGSizeMake(_count * (MAIN_SCREEN_WIDTH * 0.9) + _count * 20, MAIN_SCREEN_HEIGHT * 1.1);
       __block WebView *web = [[WebView alloc] initWithFrame:CGRectMake( (_count  - 1)* ( MAIN_SCREEN_WIDTH * 0.9) + 20 *_count , 20, MAIN_SCREEN_WIDTH * 0.9, MAIN_SCREEN_HEIGHT * 0.9)];
        web.removeCall = ^{
           
            [self checkoutWeb];
            
        };
        [_scroll1 addSubview:web];
       [web start];
        [_array addObject:web];

    } else {
        

    }
    NSLog(@"count %d _sc %f, %f",_count,_scroll1.contentSize.width,_scroll1.contentSize.height);
}

-(void)checkoutWeb
{
    self.count--;
    self.scroll1.contentSize = CGSizeMake(self.count * (MAIN_SCREEN_WIDTH * 0.9 + 40), MAIN_SCREEN_HEIGHT);
    
    NSArray *array = self.scroll1.subviews;
    int i = 1;
    for (WebView *web in array) {
        web.frame = CGRectMake( (i  - 1)*  MAIN_SCREEN_WIDTH * 0.9 + ( i * 20 ), 20, MAIN_SCREEN_WIDTH * 0.9, MAIN_SCREEN_HEIGHT * 0.9);
        i++;
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

@end
