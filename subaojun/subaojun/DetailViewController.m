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

@interface DetailViewController ()
{
    NSInteger row;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"详情";
    self.view.backgroundColor =[UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = self.detailText;
//    NSLog(@"%@",self.detailText);
    label.font =[UIFont systemFontOfSize:20];
    label.numberOfLines =0;
    self.navigationController.navigationBar.tintColor =[UIColor redColor];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    [self.view addSubview:label];
    
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
