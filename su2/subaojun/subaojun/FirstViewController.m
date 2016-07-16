//
//  FirstViewController.m
//  subaojun
//
//  Created by 胡杨科技 on 16/6/7.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//

#import "FirstViewController.h"
#import "HttpTool.h"
#import "NewsList.h"
#import "News.h"
#import "NSObject+YYModel.h"
#import "DetailViewController.h"
#import "MJRefresh.h"
#import "UIView+Extension.h"
#import "HQCell.h"
#import "UIButton+LXMImagePosition.h"
#import "AppDelegate.h"
#import "YYWebImage.h"
#import "SVProgressHUD.h"

//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

//static NSString *const HYurl =@"http://v.juhe.cn/toutiao/index?type=caijing&key=e850bcee6a3b906b7b963143b6b9cfa9";
@interface FirstViewController()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
{
    NewsList *list;
    MJRefreshNormalHeader *header;
}
@property(readwrite,nonatomic,copy)NSMutableDictionary *params;
@property(nonatomic,copy)NSString *menuItem;
@property (strong,nonatomic) UITableView *tableView;
@end
@implementation FirstViewController
-(instancetype)initTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        _menuItem = title;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
   
}

-(void)viewDidLoad
{
    [super viewDidLoad];
     [self getData];
    [_tableView.mj_header beginRefreshing];
   
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kWidth, kHeight-104)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor redColor];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:13];
    _tableView.mj_header =header;
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"HQCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}
/**
 *  停止刷新
 */
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)getData
{
    NSString *url =[NSString stringWithFormat:@"http://v.juhe.cn/toutiao/index?type=%@&key=e850bcee6a3b906b7b963143b6b9cfa9",_menuItem];
    [HttpTool get:url parameters:nil withCompletionBlock:^(id returnValue) {
      
        NSDictionary *dic =returnValue[@"result"];
        list = [NewsList yy_modelWithJSON:dic];
        [self.tableView reloadData];
          [self endRefresh];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载出现问题"];
         [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return list.data.count;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      News *newsInfo =list.data[indexPath.row];
        DetailViewController *DVC = [[DetailViewController alloc]init];
   
        [self.navigationController pushViewController:DVC animated:YES];
//       [self presentViewController:DVC animated:YES completion:nil];
        DVC.detailText = newsInfo.url;
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.backBarButtonItem = barItem;
         return;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     HQCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    News *newsInfo =list.data[indexPath.row];
    cell.image.yy_imageURL =[NSURL URLWithString:newsInfo.thumbnail_pic_s];
    cell.titleLabel.text =newsInfo.title;
    NSString *timeString = [newsInfo.date substringFromIndex:10];
    cell.timeLabel.text =timeString;
    cell.sourceLabel.text =newsInfo.author_name;
        return cell;
}
//-(void)popView:(UIButton *)btn
//{
//    News *newsInfo =_newsArray[btn.tag];
//    if([newsInfo.contentInfo  isEqual:@""])
//    {
//        self.shareNews =newsInfo.title;
//    }
//    else
//    {
//       
//        self.shareNews =newsInfo.contentInfo;
//        
//    }
//
//    NSArray* imageArray = @[[UIImage imageNamed:@"shareSDK"]];
////    UIImage *image =[UIImage imageNamed:@"APPIcon"];
//    if (imageArray) {
//        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:self.shareNews
//                                         images:imageArray
//                                            url:[NSURL URLWithString:HYurl]
//                                          title:@"速报君"
//                                           type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];}
//    
//}


@end
