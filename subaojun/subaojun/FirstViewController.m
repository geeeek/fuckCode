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
#import "PopMenu.h"
#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

static NSString *const HYurl =@"http://byw2378880001.my3w.com/";
@interface FirstViewController()<UITableViewDelegate,UITableViewDataSource>
{

    int count;
    int totalPage;
    int  currentPage;
    NewsList *list;
    BOOL _hasMore;
    MJRefreshNormalHeader *header;
}
@property (nonatomic, strong) PopMenu *popMenu;
@property(readwrite,nonatomic,copy)NSMutableDictionary *params;

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *newsArray;
@property (strong,nonatomic) NSArray *lateNews;
@property(nonatomic,copy)NSString *shareNews;
@property(nonatomic,copy)NSString *refreshTitle;
@end
@implementation FirstViewController
-(NSArray *)lateNews
{
    if (_lateNews == nil) {
        _lateNews =[NSArray array];
    }
    return _lateNews;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    static dispatch_once_t refresh;
    //解决查看详情后返回页面重复刷新问题
    dispatch_once(&refresh, ^{
         [_tableView.mj_header beginRefreshing];
    });
   
}
-(void)viewDidLoad
{
    [super viewDidLoad];
//    self.title =@"速报君";
    self.navigationItem.title =@"速报君";
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:18],
    NSForegroundColorAttributeName:[UIColor redColor]}];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    _tableView.rowHeight = 70.0f;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//         currentPage = 1;
//        [self getData];
//        
//    }];
      header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        currentPage = 1;
        [self getData];
        [self changRefreshTitle];

    }];
   
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor redColor];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:13];
    _tableView.mj_header =header;
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        currentPage ++;
        [self getData];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"HQCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
}
#pragma mark- 每次刷新修改状态文字
-(void)changRefreshTitle
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"title" ofType:@"json"];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];
    NSArray *arr = [dictionary allKeys];
     int value = arc4random() % dictionary.count;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.refreshTitle =[dictionary objectForKey:arr[value]];
        [header setTitle:self.refreshTitle forState:MJRefreshStateIdle];
        [header setTitle:self.refreshTitle forState:MJRefreshStatePulling];
        [header setTitle:self.refreshTitle forState:MJRefreshStateRefreshing];
    });
    
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
     _params =  [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:currentPage],@"page", nil];
    [HttpTool get:HYurl parameters:_params withCompletionBlock:^(id returnValue) {
      
        NSDictionary *dic =returnValue[@"objDataSet"];
        if (1 == currentPage) { //
            self.newsArray = nil;
        }
        list = [NewsList yy_modelWithJSON:dic];
        NSArray *array1 =list.objDataSet;
        if(!_newsArray){
            
            _newsArray = [NSMutableArray array];
        }
        [ _newsArray addObjectsFromArray:array1];
        [_tableView reloadData];
          [self endRefresh];
    } withFailureBlock:^(NSError *error) {
         [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsArray.count;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      News *newsInfo =_newsArray[indexPath.row];
    if (![newsInfo.contentInfo  isEqual:@""]) {
        DetailViewController *DVC = [[DetailViewController alloc]init];
        [self.navigationController pushViewController:DVC animated:YES];
        DVC.detailText = newsInfo.contentInfo;
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.backBarButtonItem = barItem;
        
    }
    
         return;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     HQCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    News *newsInfo =_newsArray[indexPath.row];
    if([newsInfo.contentInfo  isEqual:@""])
    {
        cell.textLabel.numberOfLines =2;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.textLabel.numberOfLines =2;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *strdate=newsInfo.newsDate;
    
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    
    f.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    //将字符串格式转换为时间格式 dateFromString
    NSDate *ndate=[f dateFromString:strdate];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    //2>指定要转换的格式
    formatter.dateFormat=@"HH:mm";
    //3>将日期转换为字符串 stringFromDate
    NSString *datestr=[formatter stringFromDate:ndate];
      NSString *str1 =[datestr stringByAppendingString:[NSString stringWithFormat:@" %@",newsInfo.title]];
//    NSString *newStr =[NSString stringWithFormat:@"%@",datestr];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:str1];
    //设置：在0-3个单位长度内的内容显示成红色
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 6)];
    cell.textLabel.font =[UIFont systemFontOfSize:18];
    cell.infoLabel.attributedText =str2;
    cell.shareBtn.tag =indexPath.row;
    [cell.shareBtn addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
  
        return cell;
}
-(void)popView:(UIButton *)btn
{
    News *newsInfo =_newsArray[btn.tag];
    if([newsInfo.contentInfo  isEqual:@""])
    {
        self.shareNews =newsInfo.title;
    }
    else
    {
       
        self.shareNews =newsInfo.contentInfo;
        
    }

    NSArray* imageArray = @[[UIImage imageNamed:@"shareSDK"]];
//    UIImage *image =[UIImage imageNamed:@"APPIcon"];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.shareNews
                                         images:imageArray
                                            url:[NSURL URLWithString:HYurl]
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


@end
