
//
//  ViewController.m
//  subaojun
//
//  Created by 胡杨科技 on 16/6/7.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "VTMagic.h"
#import "VTMagicController.h"
#import "FirstViewController.h"
#import "MJRefresh.h"
@interface ViewController ()
@property (nonatomic, strong)  NSArray *menuList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"速报君";
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
        [self.navigationController.navigationBar setTitleTextAttributes:
      @{NSFontAttributeName:[UIFont systemFontOfSize:18],
        NSForegroundColorAttributeName:[UIColor whiteColor]}];
   self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.sliderColor = [UIColor redColor];
    self.magicView.layoutStyle = VTLayoutStyleDefault;
    self.magicView.switchStyle = VTSwitchStyleDefault;
    self.magicView.navigationHeight = 40.f;
//    self.magicView.dataSource = self;
//    self.magicView.delegate = self;
//    [self integrateComponents];
    [self addNotification];
    [self generateTestData];
    [self.magicView reloadData];
    
    

    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    static dispatch_once_t refresh;
    //解决查看详情后重新跳转到第一个页面
    dispatch_once(&refresh, ^{
        [self.magicView switchToPage:0 animated:YES];
    });
    }

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification
- (void)addNotification
{
    [self removeNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return _menuList;
    
}
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
//    static NSString *gridId = @"grid.identifier";
//      FirstViewController *VC = [magicView dequeueReusablePageWithIdentifier:gridId];
//    if (!VC) {
//        VC =[FirstViewController new];
//    }
     NSArray *newArray = [[NSArray alloc]initWithObjects:@"top",@"caijing",@"yule",@"tiyu",@"keji",@"shishang",@"junshi",@"guonei",@"guoji",@"shehui", nil];
    FirstViewController *VC=[[FirstViewController alloc]initTitle:newArray[pageIndex]];
   
    return VC;
}
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    }
    return menuItem;
}

//- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
//{
//    
//}

- (void)generateTestData
{
   NSArray *menuList = [[NSArray alloc]initWithObjects:@"头条",@"财经",@"娱乐",@"体育",@"科技",@"时尚",@"军事",@"国内",@"国际",@"社会", nil];
    _menuList =menuList;
}
#pragma mark ---添加导航栏右边的加号按钮
//- (void)integrateComponents
//{
//    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//    [rightButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
//    [rightButton setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
//    [rightButton setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
//    [rightButton setTitle:@"+" forState:UIControlStateNormal];
//    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
//    rightButton.center = self.view.center;
//    self.magicView.rightNavigatoinItem = rightButton;
//}
//- (void)subscribeAction
//{
//    NSLog(@"subscribeAction");
//    // against status bar or not
//    self.magicView.againstStatusBar = !self.magicView.againstStatusBar;
//    [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
