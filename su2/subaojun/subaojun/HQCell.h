//
//  HQCell.h
//  subaojun
//
//  Created by 胡杨科技 on 16/6/23.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
