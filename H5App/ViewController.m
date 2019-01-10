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
#import <WebKit/WebKit.h>
#import "UIView+TouchAndTap.h"
//merroy
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
#import <SDWebImageManager.h>

//cpu
#import <mach/mach.h>
#import <assert.h>
#import "YJCustomURLProtocol.h"
#import "JYCustomDataProtocol.h"

@interface ViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, assign) int count;

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, weak)    WebView *web;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UITextField
    _array = [NSMutableArray arrayWithCapacity:1];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://h5.h5youyou.com/youxi-h5/?tid=1199&mob=ios&gid=27e9098090eda8a605703d6afeb611b3"]];
    UIScrollView *scroll1 = [UIScrollView new];
    scroll1.delegate = self;
    scroll1.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH , MAIN_SCREEN_HEIGHT);
    scroll1.contentSize = CGSizeMake(MAIN_SCREEN_WIDTH * 2.15 , MAIN_SCREEN_HEIGHT*1);
    [self.view addSubview:scroll1];
    _scroll1 = scroll1;
    
//    UIScrollView *scroll2 = [UIScrollView new];
//    scroll2.delegate = self;
//    scroll2.frame = CGRectMake(MAIN_SCREEN_WIDTH * 0.5 + 2, 0, MAIN_SCREEN_WIDTH * 0.5 - 2, MAIN_SCREEN_HEIGHT);
//    scroll2.contentSize = CGSizeMake(MAIN_SCREEN_WIDTH * 0.5 , MAIN_SCREEN_HEIGHT);
//    [self.view addSubview:scroll2];
//    _scroll2 = scroll2;s
    self.view.backgroundColor = [UIColor darkGrayColor];
//    _scroll1.maximumZoomScale = 1.5;
    [NSURLProtocol registerClass:[YJCustomURLProtocol class]];
    [NSURLProtocol registerClass:[JYCustomDataProtocol class]];
    
    WebView *web = [[WebView alloc] initWithFrame:CGRectMake(20, 20, MAIN_SCREEN_WIDTH , MAIN_SCREEN_HEIGHT)];
    web.removeCall = ^{
         [self checkoutWeb];
    };
    [_scroll1 addSubview:web];
    [web start];
    _web = web;
    _count = 1;
    [_array addObject:web];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 25, 25)];
    [btn addTarget:self action:@selector(checkout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 12.5;
    [btn setTitle:@"O" forState:UIControlStateNormal];
//    swi.titleLabel.textColor = [UIColor grayColor];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *hide = [[UIButton alloc] initWithFrame:CGRectMake(5, MAIN_SCREEN_HEIGHT - 65, 60, 30)];
    [hide addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hide];
    
    
    
    UIButton *cls = [[UIButton alloc] initWithFrame:CGRectMake(5, 320, 25, 25)];
    [cls addTarget:self action:@selector(cls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cls];
    cls.layer.masksToBounds = YES;
    cls.layer.cornerRadius = 12.5;
    [cls setTitle:@"cls" forState:UIControlStateNormal];
    //    swi.titleLabel.textColor = [UIColor grayColor];
    [cls setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cls setBackgroundColor:[UIColor grayColor]];
    // Do any additional setup after loading the view, typically from a nib.
    

    
//    hide.layer.masksToBounds = YES;
//    btn.layer.cornerRadius = 12.5;
    [hide setTitle:@"H" forState:UIControlStateNormal];
    //    swi.titleLabel.textColor = [UIColor grayColor];
    [hide setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [hide setBackgroundColor:[UIColor grayColor]];
    
    
    UIButton *show = [[UIButton alloc] initWithFrame:CGRectMake(5, MAIN_SCREEN_HEIGHT - 30, 40, 30)];
    [show addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:show];
    //    hide.layer.masksToBounds = YES;
    //    btn.layer.cornerRadius = 12.5;
    [show setTitle:@"S" forState:UIControlStateNormal];
    //    swi.titleLabel.textColor = [UIColor grayColor];
    [show setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [show setBackgroundColor:[UIColor grayColor]];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *gprs = [self getGprs3GFlowIOBytes];
    
    UIButton *g3 = [[UIButton alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 65, MAIN_SCREEN_HEIGHT - 25, 60, 20)];
    [g3 addTarget:self action:@selector(g3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:g3];
    g3.titleLabel.font = [UIFont systemFontOfSize:10];
    //    hide.layer.masksToBounds = YES;
    //    btn.layer.cornerRadius = 12.5;
    [g3 setTitle:gprs forState:UIControlStateNormal];
    //    swi.titleLabel.textColor = [UIColor grayColor];
    [g3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [g3 setBackgroundColor:[UIColor grayColor]];

    NSString *cs =[NSString stringWithFormat:@"%2.f%%",[self appCpuUsage]];
    UIButton *cpu = [[UIButton alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 45, MAIN_SCREEN_HEIGHT - 48, 40, 20)];
    [cpu addTarget:self action:@selector(cpu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cpu];
    cpu.titleLabel.font = [UIFont systemFontOfSize:10];
    //    hide.layer.masksToBounds = YES;
    //    btn.layer.cornerRadius = 12.5;
    [cpu setTitle:cs forState:UIControlStateNormal];
    //    swi.titleLabel.textColor = [UIColor grayColor];
    [cpu setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cpu setBackgroundColor:[UIColor grayColor]];
}

- (void)cls:(id)sender
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *js =  [cachePath stringByAppendingPathComponent:@"js"];
    NSString *css =  [cachePath stringByAppendingPathComponent:@"css"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:js error:nil];
    [fileManager removeItemAtPath:css error:nil];

}

- (void)checkouHtml
{
    NSString *doc = @"document.documentElement.innerHTML";
    
//    [self.web.webView evaluateJavaScript:doc
//                     completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
//                         if (error) {
//                             NSLog(@"JSError:%@",error);
//                         }
//                         NSLog(@"html:%@",htmlStr);
//                     }] ;
}

- (void)g3:(UIButton*)btn
{
    NSString *gprs = [self getGprs3GFlowIOBytes];
    [btn setTitle:gprs forState:UIControlStateNormal];

}

- (NSString *)getCache
{
    NSUInteger bytes = [[[SDWebImageManager sharedManager] imageCache] getSize];
    
    if(bytes < 1024)        // B
    {
        return [NSString stringWithFormat:@"%dB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024)    // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)    // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

- (void)cpu:(UIButton*)btn
{
    NSString *cs =[NSString stringWithFormat:@"%2.f%%",[self appCpuUsage]];
    [btn setTitle:cs forState:UIControlStateNormal];
    
}

- (void)show:(id)send
{
    _scroll1.hidden = NO;
    [self checkouHtml ];
}

- (void)hide:(id)send
{
    _scroll1.hidden = YES;
}

- (IBAction)checkout:(id)sender {
    _scroll1.scrollsToTop = YES;
//    _scroll2.scrollsToTop = YES;
//    if (sender.on) {
//        __block slf = self;
        _count += 1;
        
        _scroll1.contentSize = CGSizeMake(_count * (MAIN_SCREEN_WIDTH * 1.15) + _count * 40 + 20, MAIN_SCREEN_HEIGHT * 1);
       __block WebView *web = [[WebView alloc] initWithFrame:CGRectMake( (_count  - 1)* ( MAIN_SCREEN_WIDTH * 1) + 20 *_count , 20, MAIN_SCREEN_WIDTH * 1, MAIN_SCREEN_HEIGHT * 1)];
        web.removeCall = ^{
           
            [self checkoutWeb];
            
        };
    if (_count == 1) {
        _web = web;
    }
        [_scroll1 addSubview:web];
       [web start];
        [_array addObject:web];

  
    NSLog(@"count %d _sc %f, %f",_count,_scroll1.contentSize.width,_scroll1.contentSize.height);
}

-(void)checkoutWeb
{
    self.count--;
    self.scroll1.contentSize = CGSizeMake(self.count * (MAIN_SCREEN_WIDTH * 1.15 + 40) + 20, MAIN_SCREEN_HEIGHT * 1);
    
    NSArray *array = self.scroll1.subviews;
    int i = 1;
    for (WebView *web in array) {
        web.frame = CGRectMake( (i  - 1)*  MAIN_SCREEN_WIDTH * 1 + ( i * 20 ), 20, MAIN_SCREEN_WIDTH * 1, MAIN_SCREEN_HEIGHT * 1);
        i++;
    }
}


//获取3G或者GPRS的流量
- (NSString *)getGprs3GFlowIOBytes
{
    
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return 0;
    }
    
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        //3G或者GPRS
        if (!strcmp(ifa->ifa_name, "pdp_ip0"))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            NSLog(@"%s :iBytes is %d, oBytes is %d",
                  ifa->ifa_name, iBytes, oBytes);
        }
    }
    
    
    freeifaddrs(ifa_list);
    
    uint32_t bytes = 0;
    
    bytes = iBytes + oBytes;
    
    //将bytes单位转换
    
    if(bytes < 1024)        // B
    {
        return [NSString stringWithFormat:@"%dB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024)    // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)    // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
    
}


- (CGFloat)appCpuUsage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    long total_time     = 0;
    long total_userTime = 0;
    CGFloat total_cpu   = 0;
    int j;
    
    // for each thread
    for (j = 0; j < (int)thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            total_time     = total_time + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            total_userTime = total_userTime + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            total_cpu      = total_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
    }
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return total_cpu;
}


@end
