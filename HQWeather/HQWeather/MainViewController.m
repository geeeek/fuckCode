//
//  MainViewController.m
//  HQWeather
//
//  Created by 胡杨科技 on 16/7/7.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//
#import "MainViewController.h"
#import "MultiplePagesViewController.h"
#import "ViewController.h"
#import "Masonry.h"

#import "HttpTool.h"
#import "SVProgressHUD.h"

@interface MainViewController()
{
    int vcConunt;
}
@property (strong, nonatomic) MultiplePagesViewController *multiplePagesViewController;
@property (strong, nonatomic) ViewController *vc;
@property (nonatomic, strong) CLLocationManager *locationManger;
//@property (nonatomic, strong) CLGeocoder *geocoder;

@end
@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    static dispatch_once_t refresh;
    //解决查看详情后返回页面重复刷新问题
    dispatch_once(&refresh, ^{
        
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    vcConunt =1;
    [self.vc.addCity addTarget:self action:@selector(addNewCity) forControlEvents:UIControlEventTouchUpInside];
    [self addDefaultPageViewControllers];
    [self.view addSubview:self.multiplePagesViewController.view];
    [self addChildViewController:self.multiplePagesViewController];
}

//添加城市页面，城市个数不超过5个
- (void)addDefaultPageViewControllers {
    
         UIStoryboard *board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
         _vc =[board instantiateViewControllerWithIdentifier:@"view"];
//         [_vc initWithText:self.vc.cityLabel.text];
        [self.multiplePagesViewController addViewController:_vc];
       [self.vc.addCity addTarget:self action:@selector(addNewCity) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.multiplePagesViewController.view.frame = self.view.frame;
}

#pragma mark - <MultiplePagesViewControllerDelegate>

- (void)pageChangedTo:(NSInteger)pageIndex {
    // do something when page changed in MultiplePagesViewController
 
    
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
- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    //    [self.ci setTitle:city.cityName forState:UIControlStateNormal];
//    self.cityLabel.text =city.cityName;
#pragma mark --将添加视图的代码添加在此处保证每次是选中了某个城市才会添加一个视图
     vcConunt =vcConunt +1;
     if(vcConunt <= 5){
    [self addDefaultPageViewControllers];
    self.vc.cityLabel.text =city.cityName;
    [self.delegate changCityName:city.cityName];
    self.delegate =_vc;
     }else
     {
         [SVProgressHUD showInfoWithStatus:@"最多只能添加五个城市！"];
     }
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
//    [self.multiplePagesViewController removeViewController:vcConunt];
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)addNewCity{
   
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    cityPickerVC.locationCityID = @"1400010000";
    //    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}
@end
