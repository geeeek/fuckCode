//
//  ViewController.m
//  HQWeather
//
//  Created by 胡杨科技 on 16/6/22.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//

#import "ViewController.h"
#import "HttpTool.h"
#import "CurrentWeather.h"
#import "Weathers.h"
#import "NSObject+YYModel.h"
#import <CoreLocation/CoreLocation.h>
#import <corelocation/CLLocationManagerDelegate.h>
#import "SVProgressHUD.h"

static NSString *const Appkey =@"16908";
static NSString *const Sign =@"fcb273a68e9127bd2aaa6de5a30951f5";
@interface ViewController () <CLLocationManagerDelegate>
{
    Weathers *weathers;
}
@property (nonatomic, strong) CLLocationManager *locationManger;
@property(nonatomic,copy)NSString *cityStr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getData];
    [SVProgressHUD show];
    self.locationManger = [[CLLocationManager alloc] init];
    self.locationManger.delegate = self;
    self.locationManger.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManger.distanceFilter = 1000;
    [self.locationManger requestAlwaysAuthorization];
    [self.locationManger startUpdatingLocation];

}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             //将获得的所有信息显示到label上
             //             self.location.text = placemark.name;
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
              _cityStr =city;
             
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 // time-consuming task
                 [self getData];
//                 [self setData];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SVProgressHUD dismiss];
                 });
             });
            
             NSLog(@"city = %@", city);
             
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
         [manager stopUpdatingLocation];
     }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}

-(void)getData
{
//    http:api.k780.com:88/?app=weather.future&weaid=1&appkey=16908&sign=fcb273a68e9127bd2aaa6de5a30951f5&format=json
   
        NSString *str1  = [_cityStr stringByReplacingOccurrencesOfString:@"市" withString:@""];
    
    NSString *str2 =[NSString stringWithFormat:@"http:api.k780.com:88/?app=weather.future&weaid=%@&appkey=%@&sign=%@&format=json",str1,Appkey,Sign];
    NSString *stringCleanPath = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [HttpTool get:stringCleanPath parameters:nil withCompletionBlock:^(id returnValue) {
//        NSDictionary *dic =returnValue;
        weathers = [Weathers yy_modelWithDictionary:returnValue];
        
        [self setData];
    } withFailureBlock:^(NSError *error) {
        return ;
    }];
}
-(void)setData
{
    self.cityLabel.text =weathers.result[0].citynm;
    self.weatherLabel.text =weathers.result[0].weather;
    self.HighTmp.text =weathers.result[0].temp_high;
    self.lowTmp.text =weathers.result[0].temp_low;
//    self.currentTmp.text =weathers.result[0].cu;
    self.onelabel.text =weathers.result[1].week;
    self.twoLabel.text= weathers.result[2].week;
    self.secondLabel.text = weathers.result[3].week;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -城市选择代理方法

@end
