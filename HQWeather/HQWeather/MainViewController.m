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
#import "TLCityPickerController.h"
#import <CoreLocation/CoreLocation.h>
#import <corelocation/CLLocationManagerDelegate.h>
#import "HttpTool.h"

@interface MainViewController() <TLCityPickerDelegate,CLLocationManagerDelegate>
{
    int vcConunt;
}
@property (strong, nonatomic) MultiplePagesViewController *multiplePagesViewController;
@property (strong, nonatomic) ViewController *vc;
@property (nonatomic, strong) CLLocationManager *locationManger;
//@property (nonatomic, strong) CLGeocoder *geocoder;

@end
@implementation MainViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManger stopUpdatingLocation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    vcConunt =1;
    [self.view addSubview:self.multiplePagesViewController.view];
    [self addChildViewController:self.multiplePagesViewController];
    [self addDefaultPageViewControllers];
    [self.vc.addCity addTarget:self action:@selector(addCity) forControlEvents:UIControlEventTouchUpInside];
//    self.locationManger = [[CLLocationManager alloc] init];
//    self.locationManger.delegate = self;
//    self.locationManger.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManger.distanceFilter = 1000;
//    [self.locationManger requestAlwaysAuthorization];
//    [self.locationManger startUpdatingLocation];
    
//    [self setButton];
}
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *currLocation = [locations lastObject];
//    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
//    // 获取当前所在的城市名
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    //根据经纬度反向地理编译出地址信息
//    [geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *array, NSError *error)
//     {
//         if (array.count > 0)
//         {
//             CLPlacemark *placemark = [array objectAtIndex:0];
//             
//             //将获得的所有信息显示到label上
////             self.location.text = placemark.name;
//             //获取城市
//             NSString *city = placemark.locality;
//             if (!city) {
//                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                 city = placemark.administrativeArea;
//             }
//             _vc.locatCity =city;
//             NSLog(@"city = %@", city);
//             
//         }
//         else if (error == nil && [array count] == 0)
//         {
//             NSLog(@"No results were returned.");
//         }
//         else if (error != nil)
//         {
//             NSLog(@"An error occurred = %@", error);
//         }
//     }];
//    
//    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
//    [manager stopUpdatingLocation];
//}
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    if ([error code] == kCLErrorDenied)
//    {
//        //访问被拒绝
//    }
//    if ([error code] == kCLErrorLocationUnknown) {
//        //无法获取位置信息
//    }
//}
//-(void)setButton
//{
//    UIButton *btn1=[UIButton new];
//    [btn1 setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
//    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.bottom.mas_equalTo(10);
//        make.width.mas_lessThanOrEqualTo(40);
//        make.height.mas_lessThanOrEqualTo(40);
//    }];
////    [self.view addSubview:btn1];
//    [self.view addSubview:btn1];
//    UIButton *btn2=[UIButton new];
//    [btn2 setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
//    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-10);
//        make.bottom.mas_equalTo(10);
//        make.width.mas_lessThanOrEqualTo(40);
//        make.height.mas_lessThanOrEqualTo(40);
//    }];
//    [self.view addSubview:btn2];
//
//}
//添加城市页面，城市个数不超过5个
- (void)addDefaultPageViewControllers {
     if(vcConunt <= 5){
        UIStoryboard *board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _vc =[board instantiateViewControllerWithIdentifier:@"view"];
        [self.multiplePagesViewController addViewController:_vc];
       [self.vc.addCity addTarget:self action:@selector(addCity) forControlEvents:UIControlEventTouchUpInside];
         vcConunt =vcConunt +1;
    }
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
    NSLog(@"%@",city.cityName);
    self.vc.cityLabel.text =city.cityName;
    
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)addCity{
    [self addDefaultPageViewControllers];
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    
    cityPickerVC.locationCityID = @"1400010000";
    //    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}
@end
