//
//  YHHeader.h
//  yiyuan
//
//  Created by 胡杨科技 on 16/8/11.
//  Copyright © 2016年 胡杨网络. All rights reserved.
//

#ifndef YHHeader_h
#define YHHeader_h

#define YHTabBarColor(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
/*** 日志 ***/
#ifdef DEBUG
#define YHLog(...) NSLog(__VA_ARGS__)
#else
#define YHLog(...)
#endif
#endif /* YHHeader_h */
