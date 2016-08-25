//
//  productViewController.m
//  gold
//
//  Created by 胡杨科技 on 16/8/23.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//

#import "productViewController.h"
#import "SDCycleScrollView.h"
#import "GlobalHeader.h"
#import "oneCell.h"
#import "twoCell.h"
#import "BarView.h"
#import "ChartViewController.h"
#import "YHNavigationController.h"
static NSString *const oneCellId =@"one";
static NSString *const twoCellId =@"two";
@interface productViewController()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)oneCell *cell1;
@property(nonatomic,strong)twoCell *cell2;
@property(nonatomic,strong)BarView *barView;

@end
@implementation productViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor =[UIColor lightGrayColor];
}
-(void)setupView
{
//  循环轮播图
    NSArray *array =@[@"tihuo_cunjin",@"huangou"];
    _cycleScrollView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Kwidth, 100) imageURLStringsGroup:array];
//    _cycleScrollView.delegate =self;
    _cycleScrollView.autoScrollTimeInterval =5.0;
    _cycleScrollView.showPageControl =NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_cycleScrollView];
//  添加barView
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"BarView" owner:nil options:nil];
    _barView = [nibView firstObject];
    [_barView setFrame:CGRectMake(0,102, Kwidth,60)];
    [self.view addSubview:_barView];
    
//  设置tableView
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 164, Kwidth,(Kheight-210)) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource =self;
//    [self.tableView registerClass:[oneCell class] forCellReuseIdentifier:oneCellId];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([oneCell class]) bundle:nil] forCellReuseIdentifier:oneCellId];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([twoCell class]) bundle:nil] forCellReuseIdentifier:twoCellId];
    [self.view addSubview:_tableView];
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushLineView)];
    [_barView addGestureRecognizer:tapGesturRecognizer];
}
-(void)pushLineView
{
    ChartViewController *chartView =[[ChartViewController alloc]init];
//    YHNavigationController *nav=[[YHNavigationController alloc]initWithRootViewController:chartView];
    [self.navigationController pushViewController:chartView animated:YES];
   
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }else
        return 5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
    [self presentViewController:alert animated:true completion:nil];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0) {
        oneCell *cell =[tableView dequeueReusableCellWithIdentifier:oneCellId];
        return cell;
    }else{
        twoCell *cell=[tableView dequeueReusableCellWithIdentifier:twoCellId];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


@end
