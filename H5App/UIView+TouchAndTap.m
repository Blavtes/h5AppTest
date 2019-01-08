//
//  UIView+TouchAndTap.m
//  H5App
//
//  Created by Blavtes on 2018/12/17.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import "UIView+TouchAndTap.h"
#import <objc/runtime.h>

@implementation UIView (TouchAndTap)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self safetyMethod];
    });
}
+ (void)safetyMethod
{
       Class __View = NSClassFromString(@"UIButton");
    [self exchangeClassMethod:__View method1Sel:@selector(addTarget:action:forControlEvents:) method2Sel:@selector(as_addTarget:action:forControlEvents:)];
}

- (void)as_addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    NSLog(@"target %@",target);
    [self as_addTarget:target action:action forControlEvents:controlEvents];
}

/**
 *  类方法的交换
 *
 *  @param anClass    哪个类
 *  @param method1Sel 方法1
 *  @param method2Sel 方法2
 */
+ (void)exchangeClassMethod:(Class)anClass method1Sel:(SEL)method1Sel method2Sel:(SEL)method2Sel
{
    Method method1 = class_getClassMethod(anClass, method1Sel);
    Method method2 = class_getClassMethod(anClass, method2Sel);
    method_exchangeImplementations(method1, method2);
}


/**
 *  对象方法的交换
 *
 *  @param anClass    哪个类
 *  @param method1Sel 方法1(原本的方法)
 *  @param method2Sel 方法2(要替换成的方法)
 */
+ (void)exchangeInstanceMethod:(Class)anClass method1Sel:(SEL)method1Sel method2Sel:(SEL)method2Sel
{
    Method originalMethod = class_getInstanceMethod(anClass, method1Sel);
    Method swizzledMethod = class_getInstanceMethod(anClass, method2Sel);
    
    BOOL didAddMethod =
    class_addMethod(anClass,
                    method1Sel,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(anClass,
                            method2Sel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

@end
