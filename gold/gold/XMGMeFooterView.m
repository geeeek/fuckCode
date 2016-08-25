//
//  XMGMeFooterView.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/15.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGMeFooterView.h"
#import "XMGMeSquare.h"
#import "XMGMeSquareButton.h"
#import "UIView+XMGExtension.m"
#import "MJExtension.h"
#import "GlobalHeader.h"
#import "moreViewController.h"

@interface XMGMeFooterView()
@end

@implementation XMGMeFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 参数
        NSArray *array = @[ @{ @"name":@"银行卡",@"icon":@"yinhangka"},
                          @{ @"name":@"提/换/存金单",@"icon":@"tihuodan"},
                          @{ @"name":@"安全中心",@"icon":@"anquanzhongxin"},
                          @{ @"name":@"充值",@"icon":@"chongzhi"},
                          @{ @"name":@"常见问题",@"icon":@"changjianwenti"},
                          @{ @"name":@"邀请好友",@"icon":@"yaoqinghaoyou"},
                          @{ @"name":@"提现",@"icon":@"tixian"},
                          @{ @"name":@"交易规则",@"icon":@"jiaoyiguize"},
                          @{ @"name":@"关于我们",@"icon":@"guanyuwomen"}
                            
                            ];
        NSArray *squares = [XMGMeSquare mj_objectArrayWithKeyValuesArray:array];
        
        [self createSquares:squares];
        
    }
    // 根据模型数据创建对应的控件
    
    return self;
}

/**
 *  根据模型数据创建对应的控件
 */
- (void)createSquares:(NSArray *)squares
{
    // 方块个数
    NSUInteger count = squares.count;
    
    // 方块的尺寸
    NSUInteger maxColsCount = 3; // 一行的最大列数
    CGFloat buttonW = self.xmg_width / maxColsCount;
    CGFloat buttonH = (Kheight-340) / maxColsCount;
    
    // 创建所有的方块
    for (NSUInteger i = 0; i < count; i++) {
        // 创建按钮
        XMGMeSquareButton *button = [XMGMeSquareButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        // 设置frame
        button.xmg_x = (i % maxColsCount) * buttonW;
        button.xmg_y = (i / maxColsCount) * buttonH;
        button.xmg_width = buttonW;
        button.xmg_height = buttonH;
        
        // 设置数据
        button.square = squares[i];
    }
    
    // 设置footer的高度 == 最后一个按钮的bottom(最大Y值)
//    self.xmg_height = self.subviews.lastObject.xmg_bottom;
    
    // 设置tableView的contentSize // 重新刷新数据(会重新计算contentSize)
    
}

- (void)buttonClick:(XMGMeSquareButton *)button
{
    if ([button.square.name isEqualToString:@"常见问题"]) {
        NSLog(@"点击了常见问题按钮");
    }else
    {
    //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"尚未登录请先登录" message:nil preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"点击了取消按钮");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"点击了确定按钮");
    }]];
        //弹出提示框；
//        [UIApplication sharedApplication].delegate
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window.rootViewController presentViewController:alert animated:true completion:nil];
//        [window.rootViewController addSubview:alert];
    }
    
    
   

}

@end
