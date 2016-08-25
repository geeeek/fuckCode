//
//  YHNavigationController.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/6.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "YHNavigationController.h"
#import "depositViewController.h"
#import "meViewController.h"

@interface YHNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation YHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // 设置导航控制器为手势识别器的代理
    self.interactivePopGestureRecognizer.delegate = self;
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"users_user_bg"] forBarMetrics:UIBarMetricsDefault];
   
}

/**
 *  重写push方法的目的 : 拦截所有push进来的子控制器
 *
 *  @param viewController 刚刚push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果viewController不是最早push进来的子控制器
        // 左上角
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
//        [backButton setTitle:@"->" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        // 这句代码放在sizeToFit后面
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        // 隐藏底部的工具条
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 所有设置搞定后, 再push控制器
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
//    NSUInteger numberOfViewControllersOnStack = [self.navigationController.viewControllers count];
//    UIViewController *parentViewController = self.navigationController.viewControllers[numberOfViewControllersOnStack];
//    Class parentVCClass = [parentViewController class];
//    NSString *className = NSStringFromClass(parentVCClass);
//    NSLog(@"-----%@",className);
//    NSLog(@"%@",self.childViewControllers.firstObject);
    if ([self.childViewControllers.firstObject isMemberOfClass:[depositViewController class]]||[self.childViewControllers.firstObject isMemberOfClass:[meViewController class]]) {
        self.tabBarController.selectedIndex =0;
    }else
    {
    [self popViewControllerAnimated:YES];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>
/**
 *  手势识别器对象会调用这个代理方法来决定手势是否有效
 *
 *  @return YES : 手势有效, NO : 手势无效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 手势何时有效 : 当导航控制器的子控制器个数 > 1就有效
    return self.childViewControllers.count > 1;
}
@end
