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

static NSString *const HYurl =@"http://byw2378880001.my3w.com/";
@interface FirstViewController()<UITableViewDelegate,UITableViewDataSource>
{
//    MJRefreshFooterView *_footer;
//    MJRefreshHeaderView *_header;
    int count;
    int totalPage;
    int  currentPage;
    NewsList *list;
}
@property(readwrite,nonatomic,copy)NSDictionary *params;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *newsArray;
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
    [_tableView.mj_header beginRefreshing];
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.rowHeight = 60.0f;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
//    [self addHeader];
//    [self addFooter];
//    [self getData];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         currentPage = 0;
        [self getData];
    }];
    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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
     _params =  [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:currentPage++],@"page", nil];
    [HttpTool get:HYurl parameters:_params withCompletionBlock:^(id returnValue) {
        [self endRefresh];
        NSDictionary *dic =returnValue[@"objDataSet"];
//        if (1 == currentPage) { // 说明是在重新请求数据.
//            self.newsArray = nil;
//        }
        list = [NewsList yy_modelWithJSON:dic];
        NSArray *array1 =list.objDataSet;
        if(!_newsArray){
            
            
            _newsArray = [NSMutableArray array];
            
        }
        [ _newsArray addObjectsFromArray:array1];
        [_tableView reloadData];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }

    News *newsInfo =_newsArray[indexPath.row];
    if([newsInfo.contentInfo  isEqual:@""])
    {
//        cell.userInteractionEnabled = NO;
        cell.textLabel.numberOfLines =2;
         cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
       
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
//    NSString *str =[datestr stringByAppendingString:newsInfo.title];
    cell.textLabel.text =newsInfo.title;
    cell.detailTextLabel.text =datestr;
    return cell;
}
@end
