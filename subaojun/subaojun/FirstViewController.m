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
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

static NSString *const HYurl =@"http://byw2378880001.my3w.com/";
@interface FirstViewController()<UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate>
{

    int count;
    int totalPage;
    int  currentPage;
    NewsList *list;
}
@property(readwrite,nonatomic,copy)NSDictionary *params;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *newsArray;
// peek && pop 相关
@property (nonatomic, assign) CGRect sourceRect;       // 用户手势点 对应需要突出显示的rect
@property (nonatomic, strong) NSIndexPath *indexPath;  // 用户手势点 对应的indexPath
@end
@implementation FirstViewController
- (NSMutableArray *)newsArray
{
    if (nil == _newsArray) {
        _newsArray = [[NSMutableArray alloc]init];
    }
    
    return _newsArray;
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
    
    self.title =@"速报君";
   
    currentPage = 1;
    totalPage = 2;
//    count = 15;
//    [HttpTool get:HYurl parameters:_params withCompletionBlock:^(id returnValue) {
//        NSDictionary *dic =returnValue[@"objDataSet"];
//        list = [NewsList yy_modelWithJSON:dic];
//        [_tableView reloadData];
//        [ _mutableArr addObject:list];
//        NSLog(@"%lu",(unsigned long)list.objDataSet.count);
//    } withFailureBlock:^(NSError *error) {
//        NSLog(@"%@",error);
//        
//    }];
    // 注册Peek和Pop方法
    [self registerForPreviewingWithDelegate:self sourceView:self.view];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.rowHeight = 70.0f;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
//    [self addHeader];
//    [self addFooter];
//    [self getData];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         currentPage = 1;
        [self getData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        currentPage ++;
        [self getData];
    }];
    
}
/**
 * 更新视图.
 */
- (void) updateView
{
    [self.tableView reloadData];
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
     _params =  [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:currentPage],@"page", nil];
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
        NSLog(@"%lu",(unsigned long)list.objDataSet.count);
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}
//上拉加载
//- (void)addFooter {
//    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//    footer.scrollView = self.tableView;
//    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
//        currentPage ++;
//        [self getData];
//        if (currentPage  > totalPage) {
//            
//            [_tableView reloadData];
//            [_footer endRefreshing];
//            return ;
//        }
//    };
//    [_tableView reloadData];
//    _footer = footer;
//}
////  下拉刷新
//- (void)addHeader {
//    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//    header.scrollView = self.tableView;
//    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
//    {
//        currentPage = 1;
//        if (currentPage == 1) {
//            [_tableView reloadData];
//            [_header endRefreshing];
//        }
//        
//    };
//    [header beginRefreshing];
//    _header = header;
//}
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    UIViewController *childVC = [[UIViewController alloc] init];

    previewingContext.sourceRect = self.sourceRect;
//    NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    // 获取当前indexPath
     NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
#pragma mark - 解决刷新后无数据预览的情况
    News *newsInfo =list.objDataSet[indexPath.row - 1] ;
    // 加个白色背景
    UIView *bgView =[[UIView alloc] initWithFrame:CGRectMake(20, 10, kWidth - 40, kHeight - 20 - 64 * 2)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    if ([newsInfo.contentInfo  isEqual:@""]) {
        
        self.traitCollection.forceTouchCapability == UIForceTouchCapabilityUnavailable;
    }
    [childVC.view addSubview:bgView];
    // 加个lable
    UILabel *lable = [[UILabel alloc] initWithFrame:bgView.bounds];
    lable.numberOfLines = 0;
    lable.font =[UIFont systemFontOfSize:24];
//    lable.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    lable.text =newsInfo.contentInfo;
    [bgView addSubview:lable];
    
    return childVC;
}
/** 获取用户手势点所在cell的下标。同时判断手势点是否超出tableView响应范围。*/
//- (BOOL)getShouldShowRectAndIndexPathWithLocation:(CGPoint)location {
//    NSInteger row = (location.y - 20)/50;
//    self.sourceRect = CGRectMake(0, row * 50 + 20, kWidth, 50);
//    self.indexPath = [NSIndexPath indexPathForItem:row inSection:0];
//    // 如果row越界了，返回NO 不处理peek手势
//    return row >= _newsArray.count ? NO : YES;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return list.objDataSet.count ;
    return _newsArray.count;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        DetailViewController *DVC = [[DetailViewController alloc]init];
        [self.navigationController pushViewController:DVC animated:YES];
        //    News *newsInfo =list.objDataSet[indexPath.row];
        News *newsInfo =_newsArray[indexPath.row];
        DVC.detailText = newsInfo.contentInfo;
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.backBarButtonItem = barItem;
   
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellID];
    }
    
    News *newsInfo =_newsArray[indexPath.row];
    if([newsInfo.contentInfo  isEqual:@""])
    {
        cell.textLabel.numberOfLines =3;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.userInteractionEnabled =YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *strdate=newsInfo.newsDate;
    
    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    
    f.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    //将字符串格式转换为时间格式 dateFromString
    NSDate *ndate=[f dateFromString:strdate];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    //2>指定要转换的格式
    formatter.dateFormat=@"HH:mm:ss";
    //3>将日期转换为字符串 stringFromDate
    NSString *datestr=[formatter stringFromDate:ndate];
    UILabel  *label =[UILabel new];
    label.text =datestr;
    label.font =[UIFont systemFontOfSize:5];
    NSString *str =[label.text stringByAppendingString:[NSString stringWithFormat:@" %@",newsInfo.title]];
//    NSString *str
//    cell.textLabel.text =newsInfo.title;
//    cell.detailTextLabel.text =datestr;
    cell.textLabel.text =str;
    return cell;
}
@end
