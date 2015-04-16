//
//  HBTabBarItem.h
//  HBCustomView
//
//  Created by knight on 15/4/16.
//  Copyright (c) 2015年 knight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    TabItemEnable,
    TabItemDisable
} TabState;

@interface HBTabBarItem : UIView{

}
@property (nonatomic, assign) TabState state;
@property (nonatomic, strong) UIImage * selectedImg;
@property (nonatomic, strong) UIImage * unSelectedImg;

- (instancetype)initWithSelectedImg:(UIImage *) enableImg unSelectedImg:(UIImage *) disableImg;


@end
