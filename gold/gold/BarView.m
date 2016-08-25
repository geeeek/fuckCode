
//
//  BarView.m
//  gold
//
//  Created by 胡杨科技 on 16/8/24.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//

#import "BarView.h"


@implementation BarView
-(void)awakeFromNib
{
    [super awakeFromNib];
//    _goldBtn.enabled =NO;
    [_goldBtn setImage:[UIImage imageNamed:@"home_btn_gold"] forState:UIControlStateSelected];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
