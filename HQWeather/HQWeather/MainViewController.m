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
@interface MainViewController() <TLCityPickerDelegate>
{
    int *vcConunt;
}
@property (strong, nonatomic) MultiplePagesViewController *multiplePagesViewController;
@property (strong, nonatomic) ViewController *vc;

@end
@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    vcConunt =0;
    [self.view addSubview:self.multiplePagesViewController.view];
    [self addChildViewController:self.multiplePagesViewController];
    [self addDefaultPageViewControllers];
    [self.vc.addCity addTarget:self action:@selector(addCity) forControlEvents:UIControlEventTouchUpInside];
//    [self setButton];
}
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
- (void)addDefaultPageViewControllers {
     if(vcConunt <= 5){
        UIStoryboard *board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _vc =[board instantiateViewControllerWithIdentifier:@"view"];
        [self.multiplePagesViewController addViewController:_vc];
       [self.vc.addCity addTarget:self action:@selector(addCity) forControlEvents:UIControlEventTouchUpInside];
         vcConunt =vcConunt +1;
    }else
        return;
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
