//
//  DetailViewController.m
//  TableViewDemo
//
//  Created by 胡杨网络 on 16/6/3.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//
#define Kwidth   [UIScreen mainScreen].bounds.size.width
#define Kheight  [UIScreen mainScreen].bounds.size.height
#import "DetailViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "SVProgressHUD.h"
@interface DetailViewController ()<UIWebViewDelegate>
{
    NSInteger row;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"详情";

    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor =[UIColor redColor];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Kwidth, Kheight)];
    NSURL *url = [NSURL URLWithString:self.detailText];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
    webView.delegate=self;
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD show];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
