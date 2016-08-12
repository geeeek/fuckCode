//
//  MainViewController.m
//  HQWeather
//
//  Created by 胡杨科技 on 16/7/7.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//
#define kwidth [UIScreen mainScreen].bounds.size.width
#define kheight [UIScreen mainScreen].bounds.size.height
#import "MainViewController.h"
#import "MultiplePagesViewController.h"
#import "ViewController.h"
#import "SVProgressHUD.h"
#import "cityInfo.h"
#import "CityTableViewController.h"

@interface MainViewController()<MultiplePagesViewControllerDelegate>
{
    int vcConunt;
}
@property (strong, nonatomic) MultiplePagesViewController *multiplePagesViewController;
@property (strong, nonatomic) CityTableViewController *cityVC;
@property (strong, nonatomic) ViewController *vc;
@property (nonatomic, strong) CLLocationManager *locationManger;
@property(nonatomic,copy)NSMutableArray *cityArray;
//@property (nonatomic, strong) CLGeocoder *geocoder;

@end
@implementation MainViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBtn];
    RLMResults<cityInfo *> *citys = [cityInfo allObjects];
    // Do any additional setup after loading the view, typically from a nib.
    vcConunt =citys.count;
    if (citys) {
        for (int i = 0; i < citys.count; i ++) {
            [self addDefaultPageViewControllers];
            
//            [self.delegate changCityName:citys[i]];
        }
    }
   
    [self addDefaultPageViewControllers];
    [self.view addSubview:self.multiplePagesViewController.view];
    [self addChildViewController:self.multiplePagesViewController];
    self.multiplePagesViewController.delegate = self;

}
-(void)addBtn
{
  
    CGFloat btnWidth = 40;
    CGFloat margin = 5;
    CGFloat btnX =(kwidth -btnWidth - margin);
    CGFloat btnY =(kheight -btnWidth - margin);
    UIButton *infoBtn =[[UIButton alloc]initWithFrame:CGRectMake(margin, btnY, btnWidth, btnWidth)];
    [infoBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [self.multiplePagesViewController.view addSubview:infoBtn];
    [infoBtn addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
   
    UIButton *addBtn =[[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnWidth, btnWidth)];
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [self.multiplePagesViewController.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addNewCity) forControlEvents:UIControlEventTouchUpInside];
}
-(void)pushVC
{
     self.cityVC =[[CityTableViewController alloc]init];
    [self presentViewController:_cityVC animated:YES completion:nil];
}

//添加城市页面，城市个数不超过5个
- (void)addDefaultPageViewControllers {
    
         UIStoryboard *board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
         _vc =[board instantiateViewControllerWithIdentifier:@"view"];
//         [_vc initWithText:self.vc.cityLabel.text];
        [self.multiplePagesViewController addViewController:_vc];
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.multiplePagesViewController.view.frame = self.view.frame;
}

#pragma mark - <MultiplePagesViewControllerDelegate>
- (void)pageChangedTo:(NSInteger)pageIndex {
    // do something when page changed in MultiplePagesViewController
    self.multiplePagesViewController.pageControl.currentPage = pageIndex;
 
    
}
- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
#pragma mark --将添加视图的代码添加在此处保证每次是选中了某个城市才会添加一个视图
     vcConunt =vcConunt +1;
     if(vcConunt <= 5){
    [self addDefaultPageViewControllers];
    self.delegate =_vc;
    self.vc.cityLabel.text =city.cityName;
    [self SaveData:city.cityName];
    [_cityArray addObject:city.cityName];
         
    [self.delegate changCityName:city.cityName];
    }else
     {
         [SVProgressHUD showInfoWithStatus:@"最多只能添加五个城市！"];
     }
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
       
        
    }];
}
//存储添加的城市名称
-(void)SaveData:(NSString *)data
{
    NSString *str = [data stringByReplacingOccurrencesOfString:@"市" withString:@""];
    cityInfo *citys = [[cityInfo alloc] init];
    citys.cityName =str;
    // 获取默认的 Realm 实例
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 每个线程只需要使用一次即可
    // 通过事务将数据添加到 Realm 中
    [realm beginWriteTransaction];
    [realm addObject:citys];
    [realm commitWriteTransaction];
    
}

- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
//    [self.multiplePagesViewController removeViewController:vcConunt];
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - getters and setters
- (MultiplePagesViewController*)multiplePagesViewController {
    if (!_multiplePagesViewController) {
        _multiplePagesViewController = [[MultiplePagesViewController alloc] init];
        _multiplePagesViewController.view.frame = self.view.frame;
        _multiplePagesViewController.delegate = self;
    }
    
    return _multiplePagesViewController;
}
-(void)addNewCity{
   
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
//    cityPickerVC.locationCityID = @"1400010000";
    //    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}
@end
