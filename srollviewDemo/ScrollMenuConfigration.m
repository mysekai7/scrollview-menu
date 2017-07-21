//
//  ScrollMenuConfigration.m
//  srollviewDemo
//
//  Created by sk on 2017/7/21.
//  Copyright © 2017年 szy. All rights reserved.
//

#import "ScrollMenuConfigration.h"

@implementation ScrollMenuConfigration


+ (instancetype)pageScrollViewMenuConfigration{
    
    return [[self alloc] init];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showNavigation = YES;
    }
    return self;
}

@end
