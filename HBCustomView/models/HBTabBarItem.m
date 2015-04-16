//
//  HBTabBarItem.m
//  HBCustomView
//
//  Created by knight on 15/4/16.
//  Copyright (c) 2015年 knight. All rights reserved.
//

#import "HBTabBarItem.h"

@implementation HBTabBarItem

- (instancetype)initWithSelectedImg:(UIImage *) enableImg unSelectedImg:(UIImage *) disableImg{
    if (self = [super init]) {
        self.selectedImg = enableImg;
        self.unSelectedImg = disableImg;
        self.state = TabItemDisable;
    }
    return self;
}


@end
