//
//  ViewController.m
//  HQWeather
//
//  Created by 胡杨科技 on 16/6/22.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//
#define kwidth [UIScreen mainScreen].bounds.size.width
#define kheight [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "HttpTool.h"
#import "CurrentWeather.h"
#import "Weathers.h"
#import "NSObject+YYModel.h"
#import <CoreLocation/CoreLocation.h>
#import <corelocation/CLLocationManagerDelegate.h>
#import "SVProgressHUD.h"
#import "YYWebImage.h"
#import "MainViewController.h"
#import "UIColor+Wonderful.h"
#import "SXColorGradientView.h"
#import "UIColor+Wonderful.h"

//static NSString * const isLocation = @"isLocation";
static NSString *const Appkey =@"16908";
static NSString *const Sign =@"fcb273a68e9127bd2aaa6de5a30951f5";
@interface ViewController () <CLLocationManagerDelegate,changCityNameDelegate>
{
    Weathers *weathers;
    Weathers *curWeathers;
}
@property (nonatomic, strong) CLLocationManager *locationManger;
@property(nonatomic,copy)NSString *cityStr;
@end

@implementation ViewController
-(void)changCityName:(NSString *)cityText
{
     _cityStr = cityText;
     [_locationManger stopUpdatingLocation];
      [SVProgressHUD dismiss];
    [self getData:_cityStr];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManger stopUpdatingLocation];
}
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
//    self.view.backgroundColor =Wonderful_GreenColor3;
//    SXColorGradientView *grv = [SXColorGradientView createWithColor:[UIColor paleGreen] frame:CGRectMake(0, 0,kwidth,kheight) direction:SXGradientToBottom];
    
    
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
//    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    _locationManger = manager;
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
                 [self getData:_cityStr];
//                 [self setData];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SVProgressHUD dismiss];
                 });
             });
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
         [_locationManger stopUpdatingLocation];
     }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [_locationManger stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSUserDefaults *userDef =[NSUserDefaults standardUserDefaults];
    [userDef setBool:NO forKey:@"location"];
    [userDef synchronize];
    [[NSNotificationCenter
      defaultCenter] postNotificationName:@"location" object:self];
    [SVProgressHUD showInfoWithStatus:@"无法获取位置信息"];
    
}

-(void)getData:(NSString *)cityNm
{
//    http:api.k780.com:88/?app=weather.future&weaid=1&appkey=16908&sign=fcb273a68e9127bd2aaa6de5a30951f5&format=json
    dispatch_group_t group =dispatch_group_create();
    dispatch_group_enter(group);
    NSString *str1  = [cityNm stringByReplacingOccurrencesOfString:@"市" withString:@""];
    NSString *str2 =[NSString stringWithFormat:@"http:api.k780.com:88/?app=weather.future&weaid=%@&appkey=%@&sign=%@&format=json",str1,Appkey,Sign];
    NSString *stringCleanPath = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [HttpTool get:stringCleanPath parameters:nil withCompletionBlock:^(id returnValue) {
        weathers = [Weathers yy_modelWithDictionary:returnValue];
        dispatch_group_leave(group);
    } withFailureBlock:^(NSError *error) {
        
         dispatch_group_leave(group);
        return ;
    }];
    dispatch_group_enter(group);
    NSString *str3 =[NSString stringWithFormat:@"http:api.k780.com:88/?app=weather.today&weaid=%@&appkey=%@&sign=%@&format=json",str1,Appkey,Sign];
    NSString *stringCleanPath2 = [str3 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [HttpTool get:stringCleanPath2 parameters:nil withCompletionBlock:^(id returnValue) {
        curWeathers =[Weathers yy_modelWithDictionary:returnValue];
        dispatch_group_leave(group);
    } withFailureBlock:^(NSError *error) {
        
        dispatch_group_leave(group);
        return ;
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self setData];
    });

    
}
-(void)setData
{
//    self.cityLabel.text =weathers.result[0].citynm;
    self.cityLabel.text =_cityStr;
    self.weatherLabel.text =weathers.result[0].weather;
    self.HighTmp.text =weathers.result[0].temp_high;
    self.lowTmp.text =weathers.result[0].temp_low;
    self.onelabel.text =weathers.result[1].week;
    self.twoLabel.text= weathers.result[2].week;
    self.secondLabel.text = weathers.result[3].week;
    NSString *strTmp  = [curWeathers.resultData.temperature_curr stringByReplacingOccurrencesOfString:@"℃" withString:@""];
    self.currentTmp.text =strTmp;
     self.bigImage.image = [UIImage imageNamed:[self loadWeatherImageNamed:weathers.result[0].weather]];
    self.oneImage.image = [UIImage imageNamed:[self loadWeatherImageNamed:weathers.result[1].weather]];
    self.twoImage.image = [UIImage imageNamed:[self loadWeatherImageNamed:weathers.result[2].weather]];
    self.secondImage.image = [UIImage imageNamed:[self loadWeatherImageNamed:weathers.result[3].weather]];
}
#pragma mark---天气图片还没有完全，天气描述判断还有问题
//根据天气情况返回对应的天气图片名
- (NSString *)loadWeatherImageNamed:(NSString *)type {
    
    if ([type containsString:@"晴"]) {
        return @"111.png";
    }
    if ([type containsString:@"阴"]) {
        return @"22.png";
    }
    if([type containsString:@"多云"])
    {
        return @"44.png";
    }
    if([type containsString:@"雾"])
    {
        return @"99.png";
    }
    if([type containsString:@"沙尘"])
    {
        return @"shachengbo.png";
    }
    if([type containsString:@"雨"])
    {
        return @"w.png";
    }
    if([type containsString:@"雪"])
    {
        return @"u.png";
    }
    if([type containsString:@"雷"])
    {
        return @"r.png";
    }
  
    return @"default";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -城市选择代理方法

@end
