//
//  ScrollMenuConfigration.h
//  srollviewDemo
//
//  Created by sk on 2017/7/21.
//  Copyright © 2017年 szy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrollMenuConfigration : NSObject

/** 是否显示导航条 YES*/
@property (nonatomic, assign) BOOL showNavigation;


+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)pageScrollViewMenuConfigration;

@end
