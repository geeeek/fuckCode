//
//  ViewController.m
//  HQWeather
//
//  Created by 胡杨科技 on 16/6/22.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//

#import "MainViewController.h"
#import "HttpTool.h"
#import "CurrentWeather.h"
#import "Weathers.h"
#import "NSObject+YYModel.h"
#import "TLCityPickerController.h"

static NSString *const Appkey =@"16908";
static NSString *const Sign =@"fcb273a68e9127bd2aaa6de5a30951f5";
@interface MainViewController ()<TLCityPickerDelegate>
{
    Weathers *weathers;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
//    [self setData];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)getData
{
//    http:api.k780.com:88/?app=weather.future&weaid=1&appkey=16908&sign=fcb273a68e9127bd2aaa6de5a30951f5&format=json
    NSString *str =[NSString stringWithFormat:@"http:api.k780.com:88/?app=weather.future&weaid=1&appkey=%@&sign=%@&format=json",Appkey,Sign];
    [HttpTool get:str parameters:nil withCompletionBlock:^(id returnValue) {
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

- (IBAction)addCity:(UIButton *)sender {
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    
    cityPickerVC.locationCityID = @"1400010000";
    //    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
    
}
#pragma mark -城市选择代理方法
- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
//    [self.ci setTitle:city.cityName forState:UIControlStateNormal];
    self.cityLabel.text =city.cityName;
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
