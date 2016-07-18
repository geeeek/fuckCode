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
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface DetailViewController ()<UIWebViewDelegate,UINavigationControllerDelegate>
{
    NSInteger row;
}
@end

@implementation DetailViewController
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"详情";
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Kwidth, Kheight)];
    NSURL *url = [NSURL URLWithString:self.detailText];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
    webView.delegate=self;
    [self setRightBtn];
}
-(void)setRightBtn
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [rightButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
     [rightButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
}
-(void)share
{
        NSArray* imageArray = @[[UIImage imageNamed:@"shareSDK"]];
    //    UIImage *image =[UIImage imageNamed:@"APPIcon"];
        if (imageArray) {
    
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:self.detailTitle
                                             images:imageArray
                                                url:self.detailText
                                              title:@"速报君"
                                               type:SSDKContentTypeAuto];
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
    
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];}
        

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
