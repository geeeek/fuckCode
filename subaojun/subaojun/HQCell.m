//
//  HQCell.m
//  subaojun
//
//  Created by 胡杨科技 on 16/6/23.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//

#import "HQCell.h"
#import "UIButton+LXMImagePosition.h"
@interface HQCell()
@end
@implementation HQCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//            CGFloat spacing = 10;
//        self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
//        self.shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
