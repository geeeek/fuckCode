//
//  moreViewController.m
//  gold
//
//  Created by 胡杨科技 on 16/8/23.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//

#import "moreViewController.h"
#import "SDCycleScrollView.h"
#import "GlobalHeader.h"
#import "bottomView.h"
#import "Masonry.h"
#import "XMGMeFooterView.h"

@interface moreViewController()<SDCycleScrollViewDelegate>

@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@end
@implementation moreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNav];
    [self setupView];
    
    // Do any additional setup after loading the view, typically from a nib.
}
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder]) {
//        UIView *containerView = [[[UINib nibWithNibName:@"bottomView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
//        CGRect newFrame = CGRectMake(0, Kheight-100, Kwidth, 100);
//        containerView.frame = newFrame;
//        [self.view addSubview:containerView];
//    }
//    return self;
//}
-(void)setupView
{
    NSArray *array =@[@"tihuo_cunjin",@"huangou"];
    _cycleScrollView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Kwidth, 100) imageURLStringsGroup:array];
    _cycleScrollView.delegate =self;
    _cycleScrollView.autoScrollTimeInterval =5.0;
    _cycleScrollView.showPageControl =NO;
    [self.view addSubview:_cycleScrollView];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 102, Kwidth,60)];
    view.backgroundColor =[UIColor whiteColor];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 25, 25)];
    [image setImage:[UIImage imageNamed:@"my_user_icon"]];
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(60, 18,100,30);
    label.text=@"请点击登录";
    [view addSubview:label];
    [view addSubview:image];
    [self.view addSubview:view];
    UITapGestureRecognizer *tapGestur=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(login)];
    [view addGestureRecognizer:tapGestur];
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"bottomView" owner:nil options:nil];
     bottomView *containerView = [nibView firstObject];
    [containerView setFrame:CGRectMake(0,(Kheight-179), Kwidth,130)];
    [self.view addSubview:containerView];
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callPhone)];
    [containerView addGestureRecognizer:tapGesturRecognizer];
    XMGMeFooterView *SquareView=[[XMGMeFooterView alloc]initWithFrame:CGRectMake(0, 164, Kwidth, Kheight-290)];
    [self.view addSubview:SquareView];
    
}
-(void)login
{
    NSLog(@"点击登录");
}
-(void)callPhone
{
    NSLog(@"点击拨打电话————————————");
}
-(void)setupNav
{
    self.navigationItem.title = @"更多";
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIButton *LoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [LoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [LoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [LoginBtn sizeToFit];
    // 这句代码放在sizeToFit后面
    [LoginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:LoginBtn];
}
//-(void)login
//{
//    NSLog(@"点击了登录按钮");
//}
@end
