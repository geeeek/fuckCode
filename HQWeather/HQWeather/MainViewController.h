//
//  MainViewController.h
//  HQWeather
//
//  Created by 胡杨科技 on 16/7/7.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLCityPickerController.h"
#import <CoreLocation/CoreLocation.h>
#import <corelocation/CLLocationManagerDelegate.h>

@protocol changCityNameDelegate <NSObject>
- (void)changCityName:(NSString*)cityText;
@end
@interface MainViewController : UIViewController <TLCityPickerDelegate,CLLocationManagerDelegate>
@property(nonatomic,weak) id<changCityNameDelegate> delegate;
@end

