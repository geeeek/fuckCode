//
//  meViewController.m
//  gold
//
//  Created by 胡杨科技 on 16/8/23.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//

#import "meViewController.h"
#import "LoginViewController.h"

@implementation meViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LoginViewController *view =[[LoginViewController alloc]init];
    [self.navigationController pushViewController:view animated:NO];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
}
@end
