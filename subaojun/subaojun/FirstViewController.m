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
}
@property (nonatomic, strong) PopMenu *popMenu;
@property(readwrite,nonatomic,copy)NSMutableDictionary *params;

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *newsArray;
@property (strong,nonatomic) NSArray *lateNews;
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
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         currentPage = 1;
        [self getData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        currentPage ++;
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
//        NSLog(@"%lu",(unsigned long)list.objDataSet.count);
        
    } withFailureBlock:^(NSError *error) {
//        NSLog(@"%@",error);
         [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return list.objDataSet.count ;
    return _newsArray.count;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      News *newsInfo =_newsArray[indexPath.row];
    if (![newsInfo.contentInfo  isEqual:@""]) {
        DetailViewController *DVC = [[DetailViewController alloc]init];
        [self.navigationController pushViewController:DVC animated:YES];
        //    News *newsInfo =list.objDataSet[indexPath.row];
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
//    static NSString *cellID = @"cellID";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                      reuseIdentifier:cellID];
//    }
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
//    UILabel  *label =[UILabel new];
//    label.text =datestr;
//    label.font =[UIFont systemFontOfSize:5];
      NSString *str1 =[datestr stringByAppendingString:[NSString stringWithFormat:@" %@",newsInfo.title]];
//    NSString *newStr =[NSString stringWithFormat:@"%@",datestr];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:str1];
    //设置：在0-3个单位长度内的内容显示成红色
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 6)];
  
//    NSString *str
//    cell.textLabel.text =newsInfo.title;
//    cell.detailTextLabel.text =datestr;

    
    //image在左，文字在右，default
  
    
//    self.oneButton_line.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
//    self.oneButton_line.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
    
//    [self.oneButton_line_1 setImagePosition:LXMImagePositionLeft spacing:spacing];
    
    cell.textLabel.font =[UIFont systemFontOfSize:18];
    cell.infoLabel.attributedText =str2;
    [cell.shareBtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
  
        return cell;
}
-(void)popView
{
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:4];
    
    MenuItem *menuItem = [MenuItem itemWithTitle:@"新浪微博" iconName:@"weibo"];
    [items addObject:menuItem];
     menuItem = [MenuItem itemWithTitle:@"微信好友" iconName:@"wechat"];
    [items addObject:menuItem];
    menuItem = [MenuItem itemWithTitle:@"朋友圈" iconName:@"wechat_time"];
    [items addObject:menuItem];
    menuItem = [MenuItem itemWithTitle:@"QQ" iconName:@"qq_logo"];
    [items addObject:menuItem];
    if (!_popMenu) {
        _popMenu = [[PopMenu alloc] initWithFrame:CGRectMake(0,kHeight-150,kWidth,150) items:items];
        _popMenu.menuAnimationType = kPopMenuAnimationTypeNetEase;
    }
    if (_popMenu.isShowed) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissView)];
        tap.cancelsTouchesInView =NO;
        return;
       
    }
    _popMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem) {
        NSLog(@"%@",selectedItem.title);
    };
    
    [_popMenu showMenuAtView:self.view];
}
-(void)dissMissView
{
    [_popMenu dismissMenu];
}



@end
